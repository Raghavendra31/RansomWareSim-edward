import 'package:flutter/material.dart';

class IconWithLabel extends StatelessWidget {
  const IconWithLabel({
    required this.icon,
    required this.label,
    this.isInternetIcon = false,
    this.onTap,
    super.key,
  });

  final IconData icon;
  final String label;
  final bool isInternetIcon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    const glowColor = Color(0xFF00BFFF);
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: glowColor, width: 2),
              shape: isInternetIcon ? BoxShape.circle : BoxShape.rectangle,
              boxShadow: [
                BoxShadow(
                  color: glowColor.withAlpha(128),
                  blurRadius: 5,
                )
              ]
            ),
            child: Icon(icon, color: glowColor, size: 40)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: glowColor)),
        ],
      ),
    );
  }
}