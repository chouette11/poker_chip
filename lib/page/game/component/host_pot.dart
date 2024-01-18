import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poker_chip/model/entity/side_pot/side_pot_entity.dart';
import 'package:poker_chip/provider/presentation_providers.dart';
import 'package:poker_chip/util/constant/text_style_constant.dart';

class HostPotWidget extends ConsumerWidget {
  const HostPotWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pot = ref.watch(potProvider);
    final sidePots = ref.watch(hostSidePotsProvider);
    return SizedBox(
      height: 100,
      width: 200,
      child: Column(
        children: [
          Text('Pot'),
          Text(
            '${pot - _sidePotsValue(sidePots)}',
            style: TextStyleConstant.bold20,
          )
        ],
      ),
    );
  }
}

int _sidePotsValue(List<SidePotEntity> sidePots) {
  int value = 0;
  for (final pot in sidePots) {
    value += pot.size;
  }
  return value;
}
