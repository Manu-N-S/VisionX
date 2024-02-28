import 'package:flutter/material.dart';

class MapMode extends StatefulWidget {
  const MapMode({super.key});

  @override
  State<MapMode> createState() => _MapModeState();
}

class _MapModeState extends State<MapMode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Mode'),
      ),
    );
  }
}
