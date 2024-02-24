import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Microphone Button Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MicrophonePage(),
    );
  }
}

class MicrophonePage extends StatefulWidget {
  @override
  _MicrophonePageState createState() => _MicrophonePageState();
}

class _MicrophonePageState extends State<MicrophonePage> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button and start speaking';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Microphone Page'),
      ),
      body: Center(
        child: Text(
          _text,
          style: const TextStyle(fontSize: 20.0),
        ),
      ),
      floatingActionButton: Padding(
          padding: const EdgeInsets.all(20.0),
          child: GestureDetector(
            onTapDown: (details) {
              setState(() {
                _isListening = true;
                _listen();
              });
            },
            onTapUp: (detials) {
              setState(() {
                _isListening = false;
                _listen();
              });
            },
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 35,
              child: Icon(_isListening ? Icons.mic : Icons.mic_none,
                  color: Colors.white),
            ),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }
}
