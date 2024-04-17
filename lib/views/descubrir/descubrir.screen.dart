import 'package:flutter/material.dart';

class DescubrirScreen extends StatelessWidget {
  const DescubrirScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Descubrir page'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Descubrir page'),
          ],
        ),
      ),
    );
  }
}
