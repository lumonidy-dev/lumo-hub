import 'package:flutter/material.dart';

class CarteraScreen extends StatelessWidget {
  const CarteraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cartera page'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Cartera page'),
          ],
        ),
      ),
    );
  }
}
