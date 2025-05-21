import 'package:flutter/material.dart';

class QrGeneratorScreen extends StatefulWidget {
  const QrGeneratorScreen({super.key});

  @override
  State<QrGeneratorScreen> createState() => _QrGeneratorScreenState();
}

class _QrGeneratorScreenState extends State<QrGeneratorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Generate qr"),
    );
  }
}
