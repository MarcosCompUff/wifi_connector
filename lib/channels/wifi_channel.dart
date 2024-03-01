import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WifiChannel {
  final MethodChannel _channel = const MethodChannel('wifi_connector/connector');

  Future<void> connectWifi(String ssid, String senha) async {
    try {
      await _channel.invokeMethod('connectWifi', {'ssid': ssid, 'senha': senha});
    } on PlatformException catch (e) {
      debugPrint("ERROR: $e");
    }
  }
}
