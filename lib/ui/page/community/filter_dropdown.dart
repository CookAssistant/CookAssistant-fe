import 'package:flutter/material.dart';
import 'package:cook_assistant/widgets/dropdown.dart'; // 수정된 경로에 맞게 조정

class FilterDropdown extends StatelessWidget {
  final String value;
  final List<String> options;
  final Function(String?) onChanged;

  const FilterDropdown({
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
      iconPath: 'assets/icons/filter.svg',
    );
  }
}
