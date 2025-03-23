import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CustomButtonWidget extends StatelessWidget {
  final Map<String, dynamic> widgetConfig;
  final VoidCallback? onPressed;

  const CustomButtonWidget({
    super.key,
    required this.widgetConfig,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    bool isFullWidth = widgetConfig["width"] == "full";
    Color backgroundColor =
        widgetConfig.containsKey("color")
            ? getColorFromHex(widgetConfig["color"])
            : Colors.blue;
    Color textColor =
        widgetConfig.containsKey("text_color")
            ? getColorFromHex(widgetConfig["text_color"])
            : Colors.white;

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          padding: EdgeInsets.symmetric(
            horizontal: widgetConfig["padding_horizontal"]?.toDouble() ?? 16,
            vertical: widgetConfig["padding_vertical"]?.toDouble() ?? 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              widgetConfig["border_radius"]?.toDouble() ?? 12,
            ),
          ),
          elevation: widgetConfig["elevation"]?.toDouble() ?? 4,
        ),
        onPressed: onPressed,
        icon: _getButtonIcon(widgetConfig["action"]),
        label: Text(
          widgetConfig["text"] ?? "Button",
          style: TextStyle(
            fontSize: widgetConfig["font_size"]?.toDouble() ?? 16,
            fontWeight:
                widgetConfig["weight"] == "bold"
                    ? FontWeight.bold
                    : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _getButtonIcon(String? action) {
    switch (action) {
      case "google_auth":
        return Icon(LucideIcons.instagram, color: Colors.white);
      case "apple_auth":
        return Icon(LucideIcons.apple, color: Colors.white);
      case "otp_login":
        return Icon(LucideIcons.phone, color: Colors.white);
      case "firebase_login":
        return Icon(LucideIcons.lock, color: Colors.white);
      case "navigate":
        return Icon(LucideIcons.arrowRight, color: Colors.white);
      case "back":
        return Icon(LucideIcons.arrowLeft, color: Colors.white);
      default:
        return SizedBox.shrink();
    }
  }

  /// Convert Hex Color String to Flutter Color
  Color getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return Color(int.parse(hexColor, radix: 16));
  }
}
