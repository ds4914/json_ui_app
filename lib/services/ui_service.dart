import 'dart:convert';
import 'package:flutter/services.dart';

abstract class UIService {
  Future<Map<String, dynamic>> loadUIConfig();
}

class UIServiceImpl implements UIService {
  @override
  Future<Map<String, dynamic>> loadUIConfig() async {
    String data = await rootBundle.loadString('assets/ui_config.json');
    return json.decode(data);
  }
}
