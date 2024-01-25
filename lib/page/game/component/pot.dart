import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poker_chip/provider/presentation/pot.dart';
import 'package:poker_chip/util/constant/color_constant.dart';
import 'package:poker_chip/util/constant/text_style_constant.dart';

class PotWidget extends ConsumerWidget {
  const PotWidget(this.isHost, {super.key});

  final bool isHost;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pot = ref.watch(potProvider);
    final sidePots = isHost
        ? ref.watch(hostSidePotsProvider.notifier).totalValue()
        : ref.watch(sidePotsProvider.notifier).totalValue();
    return Container(
      height: 52,
      width: 80,
      decoration: BoxDecoration(
        color: ColorConstant.black30.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16)
      ),
      child: Column(
        children: [
          const Text(
            'Pot',
            style: TextStyleConstant.bold12,
          ),
          Text(
            '${pot - sidePots}',
            style: TextStyleConstant.bold20,
          )
        ],
      ),
    );
  }
}
