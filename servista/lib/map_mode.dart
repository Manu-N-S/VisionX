import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;

class MapMode extends StatefulWidget {
  const MapMode({super.key});

  @override
  State<MapMode> createState() => _MapModeState();
}

class _MapModeState extends State<MapMode> {
  late CameraController _cameraController;
  bool _isCameraStreaming = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _startImageCapture();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _cameraController = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    ); // Check if flash mode is available

    _cameraController.setFlashMode(FlashMode.off);

    await _cameraController.initialize();

    setState(() {
      _isCameraStreaming = true; // Turn on camera streaming
    }); // Refresh UI after camera initialization
  }

  void _startImageCapture() {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_isCameraStreaming) {
        XFile? imageFile = await _cameraController.takePicture();
        if (imageFile != null) {
          String base64Image = base64Encode(await imageFile.readAsBytes());
          _sendImageToServer(base64Image);
        }
      }
    });
  }

  Future<void> _sendImageToServer(String base64Image) async {
    // Replace the URL below with your server endpoint
    String url = 'http://192.168.29.104:8000/objfind';
    try {
      var response = await http.post(
        Uri.parse(url),
        body: json.encode({'image': base64Image}),
        headers: {'Content-Type': 'application/json'},
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    } catch (e) {
      print('Error sending image: $e');
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation Mode'),
      ),
      body: _isCameraStreaming
          ? CameraPreview(_cameraController)
          : const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Camera Error",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ],
              ),
            ),
    );
  }
}
