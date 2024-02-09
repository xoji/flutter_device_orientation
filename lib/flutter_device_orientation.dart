library flutter_device_orientation;

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:sensors_plus/sensors_plus.dart';

class FlutterDeviceOrientationBuilder extends StatefulWidget {
  const FlutterDeviceOrientationBuilder({super.key, required this.builder});

  final Widget Function(BuildContext context, DeviceOrientation orientation)
      builder;

  @override
  State<FlutterDeviceOrientationBuilder> createState() =>
      _FlutterDeviceOrientationBuilderState();
}

class _FlutterDeviceOrientationBuilderState
    extends State<FlutterDeviceOrientationBuilder> {
  DeviceOrientation _deviceOrientation = DeviceOrientation.portraitUp;
  late StreamSubscription<AccelerometerEvent> _sensorStream;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _sensorStream = accelerometerEventStream().listen((event) {
      if (event.x > 6 &&
          event.y < 6 &&
          event.y > -6 &&
          _deviceOrientation != DeviceOrientation.landscapeRight) {
        setState(() {
          _deviceOrientation = DeviceOrientation.landscapeRight;
        });
      } else if (event.y > -6 &&
          event.y < 6 &&
          event.x < -6 &&
          _deviceOrientation != DeviceOrientation.landscapeLeft) {
        setState(() {
          _deviceOrientation = DeviceOrientation.landscapeLeft;
        });
      } else if (event.x < 6 &&
          event.x > -6 &&
          event.y > 6 &&
          _deviceOrientation != DeviceOrientation.portraitUp) {
        setState(() {
          _deviceOrientation = DeviceOrientation.portraitUp;
        });
      } else if (event.x < 6 &&
          event.x > -6 &&
          event.y < -6 &&
          _deviceOrientation != DeviceOrientation.portraitDown) {
        setState(() {
          _deviceOrientation = DeviceOrientation.portraitDown;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _sensorStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _deviceOrientation);
  }
}
