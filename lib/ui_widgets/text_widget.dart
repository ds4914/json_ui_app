import 'package:flutter/material.dart';

class CustomTextWidget extends StatelessWidget {
  final Map<String, dynamic> widgetConfig;

  const CustomTextWidget({super.key, required this.widgetConfig});

  Color getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      widgetConfig["value"] ?? "",
      style: TextStyle(
        fontSize: widgetConfig["size"]?.toDouble() ?? 16,
        color: widgetConfig.containsKey("color")
            ? getColorFromHex(widgetConfig["color"])
            : Colors.black,
        fontWeight: widgetConfig["weight"] == "bold"
            ? FontWeight.bold
            : FontWeight.normal,
        fontStyle: widgetConfig["italic"] == true ? FontStyle.italic : FontStyle.normal,
        decoration: widgetConfig["underline"] == true
            ? TextDecoration.underline
            : TextDecoration.none,
      ),
      textAlign: widgetConfig["alignment"] == "center"
          ? TextAlign.center
          : widgetConfig["alignment"] == "right"
          ? TextAlign.right
          : TextAlign.start,
      maxLines: widgetConfig["maxLines"] ?? null,
      overflow: widgetConfig["overflow"] == "ellipsis"
          ? TextOverflow.ellipsis
          : TextOverflow.clip,
    );
  }
}