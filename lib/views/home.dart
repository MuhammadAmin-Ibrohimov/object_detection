import 'package:camera/camera.dart';
import 'package:fire_detection_v2/views/bndbox.dart';
import 'package:fire_detection_v2/views/camera.dart';
import 'package:fire_detection_v2/views/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'dart:math' as math;

class MyhomePage extends StatefulWidget {
  final List<CameraDescription> cameras;
  const MyhomePage(this.cameras, {super.key});

  @override
  State<MyhomePage> createState() => _MyhomePageState();
}

class _MyhomePageState extends State<MyhomePage> {
  List<dynamic>? _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;
  String _model = "";

  @override
  void initState() {
    super.initState();
  }

  loadMoadel() async {
    String res;
    res = (await Tflite.loadModel(
        model: 'assets/models/yolov2_tiny.tflite',
        labels: 'assets/models/yolov2_tiny.txt'))!;
    print(res);
  }

  onSelect(model) {
    setState(() {
      _model = model;
    });
    loadMoadel();
  }

  setRecognitions(recognition, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognition;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Fire detection",
            style: TextStyle(color: Colors.black),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: _model == ""
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          onSelect(yolo);
                        },
                        child: const Text("Start detection")),
                  ],
                ),
              ],
            )
          : Stack(
              children: [
                Camera(
                  widget.cameras,
                  _model,
                  setRecognitions,
                ),
                BndBox(
                    _recognitions ?? [],
                    math.max(_imageHeight, _imageWidth),
                    math.min(_imageHeight, _imageWidth),
                    screen.height,
                    screen.width,
                    _model),
              ],
            ),
    );
  }
}
