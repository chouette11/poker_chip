import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poker_chip/provider/presentation_providers.dart';

class Hole extends ConsumerWidget {
  const Hole({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 自分のデータ
    final uid = ref.watch(uidProvider);
    final myData = ref.watch(playerDataProvider).firstWhere((e) => e.uid == uid);
    
    return SizedBox(
      height: 200,
      child: Column(
        children: [
          Text(myData.score.toString()),
          Row(
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
          ),
        ],
      ),
    );
  }
}
