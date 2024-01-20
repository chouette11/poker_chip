import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poker_chip/model/entity/side_pot/side_pot_entity.dart';
import 'package:poker_chip/provider/presentation_providers.dart';

class SidePotsWidget extends ConsumerWidget {
  const SidePotsWidget(this.isHost, {super.key});

  final bool isHost;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sidePots =
        isHost ? ref.watch(hostSidePotsProvider) : ref.watch(sidePotsProvider);
    print('sidePots: $sidePots');
    return SizedBox(
      height: 400,
      width: 40,
      child: ListView.builder(
        itemCount: sidePots.length,
        itemBuilder: (context, index) {
          int sidePot = 0;
          if (isHost) {
            final entity = sidePots[index] as SidePotEntity;
            sidePot = entity.size;
          } else {
            sidePot = sidePots[index] as int;
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [Text('Pot ${index + 1}'), Text('$sidePot')],
          );
        },
      ),
    );
  }
}
