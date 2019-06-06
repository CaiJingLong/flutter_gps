# gps

Getting location data by gps, Support android and iOS.

[![0.1.1](https://img.shields.io/pub/v/gps.svg)](https://pub.dev/packages/gps)
[![GitHub](https://img.shields.io/github/license/caijinglong/flutter_gps.svg)](https://github.com/caijinglong/flutter_gps)

## Install

```yaml
dependencies:
  gps: ^0.1.1 # (latest version)
```

## Usage

```dart
import 'package:gps/gps.dart';

void main() async{
  var latlng = await Gps.currentGps();
  print(latlng.lat);
  print(latlng.lng);
}
```

Get GPS information only once.

## LICENSE

MIT
