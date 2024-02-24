import 'package:flutter/material.dart';

class InteractionMode extends StatelessWidget {
  const InteractionMode({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interaction Mode'),
      ),
      body: const Center(
        child: Text(
          'Interaction Mode0',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}
