import 'package:flutter/material.dart';

class Hole extends StatelessWidget {
  const Hole({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          'assets/images/tranp.png',
          height: 136,
          width: 72,
        ),
        Image.asset(
          'assets/images/tranp.png',
          height: 136,
          width: 72,
        ),
      ],
    );
  }
}
