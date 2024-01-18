import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poker_chip/provider/presentation_providers.dart';

class HostSidePotsWidget extends ConsumerWidget {
  const HostSidePotsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sidePots = ref.watch(hostSidePotsProvider);
    return SizedBox(
      height: 400,
      width: 40,
      child: ListView.builder(
        itemCount: sidePots.length,
        itemBuilder: (context, index) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Pot ${index + 1}'),
              Text('${sidePots[index].size}')
            ],
          );
        },
      ),
    );
  }
}
