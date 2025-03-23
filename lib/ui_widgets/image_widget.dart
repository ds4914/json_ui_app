import 'package:flutter/material.dart';

class CustomImageWidget extends StatelessWidget {
  final Map<String, dynamic> widgetConfig;

  const CustomImageWidget({super.key, required this.widgetConfig});

  @override
  Widget build(BuildContext context) {
    double? width = _getWidth(widgetConfig["width"], context);
    double? height = widgetConfig["height"]?.toDouble() ?? 150;
    BoxFit fit = _getBoxFit(widgetConfig["fit"]);

    if (widgetConfig.containsKey("src")) {
      return Image.asset(
        widgetConfig["src"],
        width: width,
        height: height,
        fit: fit,
      );
    } else if (widgetConfig.containsKey("url")) {
      return Image.network(
        widgetConfig["url"],
        width: width,
        height: height,
        fit: fit,
      );
    }

    return const SizedBox.shrink();
  }

  double? _getWidth(dynamic widthConfig, BuildContext context) {
    if (widthConfig == "full") {
      return MediaQuery.of(context).size.width;
    }
    return widthConfig?.toDouble();
  }

  BoxFit _getBoxFit(String? fit) {
    switch (fit) {
      case "contain":
        return BoxFit.contain;
      case "cover":
        return BoxFit.cover;
      case "fill":
        return BoxFit.fill;
      case "scaleDown":
        return BoxFit.scaleDown;
      default:
        return BoxFit.fitWidth;
    }
  }
}
