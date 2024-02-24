import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:servista/vision_helpers.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ObjectTrackingPage extends StatefulWidget {
  @override
  State<ObjectTrackingPage> createState() => _ObjectTrackingPageState();
}

class _ObjectTrackingPageState extends State<ObjectTrackingPage> {
  late CameraController _controller;
  bool _isCameraReady = false;
  XFile? _imageFile;
  String _text = '';
  final FlutterTts flutterTts = FlutterTts();
  final stt.SpeechToText _speech = stt.SpeechToText();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );

    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isCameraReady = true;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Object Tracking'),
      ),
      body: Column(
        children: [
          _isCameraReady
              ? CameraPreview(_controller)
              : const Center(child: CircularProgressIndicator()),
          Text(_text)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (!_controller.value.isInitialized) {
            return;
          }
          try {
            final image = await _controller.takePicture();
            final bytes = await image.readAsBytes();
            final base64String = base64Encode(bytes);
            print(base64String);
            print("Listening!");

            bool isListening = await _speech.initialize();
            if (!isListening) {
              print('Failed to start listening for speech.');
              return;
            }

            // Listen for speech input
            _speech.listen(
              onResult: (result) {
                setState(() {
                  _text = result.recognizedWords;
                });
              },
            );
            print(_text);
            VisionHelpers.sendImageToServer(
                base64String, _text); // You can use this base64String as needed
            setState(() {
              _imageFile = image;
            });
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(Icons.camera),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
