import 'package:flutter/material.dart';
import 'defence_option.dart';

class DefenceCheckboxOption extends StatelessWidget {
  const DefenceCheckboxOption({
    required this.title,
    required this.value,
    required this.isChecked,
    required this.onChanged,
    super.key,
  });

  final String title;
  final DefenceOption value;
  final bool isChecked;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!isChecked),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: isChecked,
                onChanged: onChanged,
                activeColor: const Color(0xFF00BFFF),
                checkColor: const Color(0xFF1E1E1E),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}