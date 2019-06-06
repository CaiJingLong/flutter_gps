# gps

Getting location data by gps, Support android and iOS.

## Install

```yaml
dependencies:
  gps: ^0.1.0 # (latest version)
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
