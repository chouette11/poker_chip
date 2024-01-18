import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poker_chip/provider/presentation/player.dart';

class RankingSelectButton extends ConsumerStatefulWidget {
  const RankingSelectButton({super.key});

  @override
  ConsumerState<RankingSelectButton> createState() => _RankingSelectButtonState();
}

class _RankingSelectButtonState extends ConsumerState<RankingSelectButton> {
  @override
  Widget build(BuildContext context) {
    final actives = ref.watch(playerDataProvider.notifier).activePlayers();
    final selection = List.generate(actives.length, (index) => false);
    final options = List.generate(actives.length, (index) => '$index位');
    return ToggleButtons(
      isSelected: selection,
      onPressed: (int index) {
        selection[index] = !selection[index];
      },
      constraints: const BoxConstraints(
        minHeight: 32.0,
        minWidth: 56.0,
      ),
      children: options.map((e) => Text(e)).toList(),
    );
  }
}
