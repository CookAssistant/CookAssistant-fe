import 'package:flutter/material.dart';
import 'package:cook_assistant/ui/theme/color.dart';
import 'package:cook_assistant/ui/theme/text_styles.dart';
import 'package:cook_assistant/widgets/dropdown.dart';
import 'package:flutter_svg/svg.dart';

class SortingDropdown extends StatelessWidget {
  final String value;
  final List<String> options;
  final Function(String?) onChanged;

  const SortingDropdown({
    Key? key,
    required this.value,
    required this.options,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildDropdownButton(
      value: value,
      options: options,
      onChanged: onChanged,
      iconPath: 'assets/icons/sort.svg',
    );
  }
}
