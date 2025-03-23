import 'package:flutter/material.dart';

class CustomTextFieldWidget extends StatelessWidget {
  final Map<String, dynamic> widgetConfig;
  final TextEditingController controller;

  const CustomTextFieldWidget({
    super.key,
    required this.widgetConfig,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(widgetConfig["padding"]?.toDouble() ?? 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: widgetConfig["hint"] ?? "",
          labelText: widgetConfig["hint"] ?? "",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              widgetConfig["border_radius"]?.toDouble() ?? 4,
            ),
          ),
          filled: widgetConfig["filled"] ?? false,
          fillColor:
              widgetConfig.containsKey("fill_color")
                  ? getColorFromHex(widgetConfig["fill_color"])
                  : null,
          prefixIcon:
              widgetConfig.containsKey("prefix_icon")
                  ? Icon(_getIconFromString(widgetConfig["prefix_icon"]))
                  : null,
          suffixIcon:
              widgetConfig.containsKey("suffix_icon")
                  ? Icon(_getIconFromString(widgetConfig["suffix_icon"]))
                  : null,
        ),
        obscureText: widgetConfig["obscure"] ?? false,
        keyboardType:
            widgetConfig["keyboard_type"] == "number"
                ? TextInputType.number
                : TextInputType.text,
        maxLength: widgetConfig["max_length"],
      ),
    );
  }

  Color getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  IconData _getIconFromString(String iconName) {
    switch (iconName) {
      case "email":
        return Icons.email;
      case "phone":
        return Icons.phone;
      case "lock":
        return Icons.lock;
      default:
        return Icons.help_outline;
    }
  }
}
