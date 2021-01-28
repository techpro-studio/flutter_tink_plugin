
import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:tink_plugin/tink_result.dart';

class TinkPlugin {
  static const _channel = MethodChannel("studio.techpro.tink_plugin");

  static Future<TinkResult> authenticateWithURL(String url) async {
    final result = await _channel.invokeMethod("authenticate", [url]);
    return TinkResult.fromJson(jsonDecode(result));
  }
}
