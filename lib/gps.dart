import 'dart:async';

import 'package:flutter/services.dart';

class Gps {
  static const MethodChannel _channel = const MethodChannel('top.kikt/gps');

  static Future<GpsLatlng> currentGps() async {
    try {
      var map = await _channel.invokeMethod("gps");
      if (map == null) {
        return null;
      }
      return GpsLatlng.fromMap(map.cast<String, dynamic>());
    } catch (e) {
      return null;
    }
  }
}

class GpsLatlng {
  String lat;
  String lng;

  GpsLatlng._();

  factory GpsLatlng.fromMap(Map<String, dynamic> map) {
    return GpsLatlng._()
      ..lat = map["lat"]
      ..lng = map["lng"];
  }

  @override
  String toString() {
    return "${this.lat}, ${this.lng}";
  }
}
