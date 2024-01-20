import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poker_chip/provider/presentation_providers.dart';
import 'package:poker_chip/util/constant/text_style_constant.dart';

class PotWidget extends ConsumerWidget {
  const PotWidget(this.isHost, {super.key});

  final bool isHost;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pot = ref.watch(potProvider);
    print("pot $pot");
    final sidePots = isHost
        ? ref.watch(hostSidePotsProvider.notifier).totalValue()
        : ref.watch(sidePotsProvider.notifier).totalValue();
    print('$sidePots');
    return SizedBox(
      height: 100,
      width: 200,
      child: Column(
        children: [
          Text('Pot'),
          Text(
            '${pot - sidePots}',
            style: TextStyleConstant.bold20,
          )
        ],
      ),
    );
  }
}
