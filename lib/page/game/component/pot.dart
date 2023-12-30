import 'package:flutter/material.dart';
import 'package:poker_chip/util/constant/text_style_constant.dart';

class PotWidget extends StatelessWidget {
  const PotWidget({super.key, required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 200,
      child: Column(
        children: [
          Text('Pot'),
          Text(
            score.toString(),
            style: TextStyleConstant.bold20,
          )
        ],
      ),
    );
  }
}
