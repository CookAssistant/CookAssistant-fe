import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _extractedText = '';
  final ImagePicker _picker = ImagePicker();

  VisionApiService visionApiService = VisionApiService();

  void _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      String? text = await visionApiService.annotateImage(image.path);
      setState(() {
        _extractedText = text ?? 'No text detected';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text Detection App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_extractedText.isNotEmpty) Text(_extractedText),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick an Image'),
            ),
          ],
        ),
      ),
    );
  }
}

class VisionApiService {
  final String baseUrl = 'https://vision.googleapis.com/v1/images:annotate';
  final String projectId = 'cookassistant-420213';
  final String gcloudToken = 'your-gcloud-token';

  Future<String?> annotateImage(String imagePath) async {
    final request = VisionRequest(
      requests: [
        AnnotateImageRequest(
          image: _Image(
            content: await encodeImageToBase64(imagePath),
          ),
          features: [Feature()],
        ),
      ],
    );

    final headers = {
      HttpHeaders.authorizationHeader: "Bearer $gcloudToken",
      "x-goog-user-project": projectId,
      HttpHeaders.contentTypeHeader: "application/json; charset=utf-8",
    };

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: headers,
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<dynamic> textAnnotations = jsonResponse['responses'][0]['textAnnotations'];
      if (textAnnotations.isNotEmpty) {
        return textAnnotations[0]['description'];
      }
    }
    return null;
  }
}

Future<String> encodeImageToBase64(String imagePath) async {
  final imageFile = File(imagePath);
  final Uint8List imageBytes = await imageFile.readAsBytes();
  return base64Encode(imageBytes);
}

class VisionRequest {
  final List<AnnotateImageRequest> requests;

  VisionRequest({required this.requests});

  Map<String, dynamic> toJson() => {
    'requests': requests.map((request) => request.toJson()).toList(),
  };
}

class AnnotateImageRequest {
  final _Image image;
  final List<Feature> features;

  AnnotateImageRequest({required this.image, required this.features});

  Map<String, dynamic> toJson() => {
    'image': image.toJson(),
    'features': features.map((feature) => feature.toJson()).toList(),
  };
}

class _Image {
  final String content;

  _Image({required this.content});

  Map<String, dynamic> toJson() => {
    'content': content,
  };
}

class Feature {
  final String type = "TEXT_DETECTION";

  Map<String, dynamic> toJson() => {
    'type': type,
  };
}
