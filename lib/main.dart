import 'package:camera/camera.dart';
import 'package:fire_detection_v2/views/home.dart';
import 'package:flutter/material.dart';

List<CameraDescription>? cameras = [];
Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras();
  } catch (e) {
    print('Error: $e.code\nError Message: $e.message');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fire detector app',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: MyhomePage(cameras!),
    );
  }
}
