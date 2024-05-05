import 'package:flutter/material.dart';
import 'package:cook_assistant/ui/theme/color.dart';
import 'package:cook_assistant/ui/theme/text_styles.dart';
import 'package:cook_assistant/widgets/button/primary_button.dart';
import 'package:cook_assistant/widgets/button/secondary_button.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:cook_assistant/ui/page/make_recipe/making.dart';


enum RecordingState { Stopped, Recording, Finished }

class MakeRecipeVoicePage extends StatefulWidget {
  @override
  _RecordScreenState createState() => _RecordScreenState();
}

class _RecordScreenState extends State<MakeRecipeVoicePage> {
  RecordingState _recordingState = RecordingState.Stopped;
  bool isImageGenerationEnabled = false;
  stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _isListening = false;
  String _text = '';

  @override
  void initState() {
    super.initState();
    _speechToText.initialize(
        onStatus: (status) {
          setState(() {
            _isListening = _speechToText.isListening;
          });
        },
        onError: (errorNotification) {
          setState(() {
            _text = 'Speech recognition error: ${errorNotification.errorMsg}';
          });
        }
    );
  }

  void toggleRecording() {
    setState(() {
      if (_recordingState == RecordingState.Stopped) {
        _recordingState = RecordingState.Recording;
        _listen();
      } else if (_recordingState == RecordingState.Recording) {
        _recordingState = RecordingState.Finished;
        _stopListening();
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MakingPage(recordedText: _text),
          ),
        );
      }
    });
  }

  void _listen() {
    if (!_isListening) {
      _speechToText.listen(onResult: (result) {
        setState(() {
          _text = result.recognizedWords;
        });
      },
        localeId: 'ko_KR',
      );
    }
  }

  void _stopListening() {
    if (_isListening) {
      _speechToText.stop();
    }
  }

  void navigateToNextPage() {
    // Implement navigation logic
  }

  void toggleImageGeneration() {
    setState(() {
      isImageGenerationEnabled = !isImageGenerationEnabled;
    });
  }

  void showTextDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Recorded Text'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(_text),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget button;
    switch (_recordingState) {
      case RecordingState.Recording:
        button = SecondaryButton(
          text: '중지하기',
          onPressed: toggleRecording,
        );
        break;
      case RecordingState.Finished:
        button = PrimaryButton(
          text: '완료하기',
          onPressed: toggleRecording,
        );
        break;
      case RecordingState.Stopped:
      default:
        button = PrimaryButton(
          text: '녹음하기',
          onPressed: toggleRecording,
        );
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '레시피 만들기',
          style: AppTextStyles.headingH4.copyWith(color: AppColors.neutralDarkDarkest),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              '원하는 식단과 제목, 레시피 이름을 포함해서 말해보세요!',
              style: AppTextStyles.headingH1.copyWith(color: AppColors.neutralDarkDarkest),
            ),
            SizedBox(height: 16.0),
            Text(
              'Tell us your desired meal plan, including the ingredients and recipe name!',
              style: AppTextStyles.bodyM.copyWith(color: AppColors.neutralDarkLight),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Checkbox(
                  value: isImageGenerationEnabled,
                  onChanged: (bool? newValue) {
                    toggleImageGeneration();
                  },
                  fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected)) {
                      return AppColors.highlightDarkest;
                    }
                    return AppColors.neutralLightLightest;
                  }),
                ),
                Expanded(
                  child: Text(
                    '완성된 레시피 이미지를 생성하겠습니다.\n(시간이 더 소요됩니다.)',
                    style: AppTextStyles.bodyM.copyWith(color: AppColors.neutralDarkLight),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                alignment: Alignment.center,
                child: Text(
                  _text,
                  style: AppTextStyles.bodyL.copyWith(color: AppColors.neutralDarkDarkest),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: button,
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MakeRecipeVoicePage(),
  ));
}