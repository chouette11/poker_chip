import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:poker_chip/provider/presentation/player.dart';
import 'package:poker_chip/provider/presentation_providers.dart';
import 'package:poker_chip/util/constant/color_constant.dart';
import 'package:poker_chip/util/constant/text_style_constant.dart';

class EditablePlayerCard extends ConsumerWidget {
  const EditablePlayerCard({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final uid = ref.watch(uidProvider);
    final myData =
        ref.watch(playerDataProvider).firstWhere((e) => e.uid == uid);
    String playername = '';
    int stack = 0;

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('playerName'),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: width * 0.6,
                          child: TextField(
                            decoration:
                                const InputDecoration(labelText: 'playerName'),
                            onChanged: (value) {
                              playername = value;
                            },
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              ref
                                  .read(playerDataProvider.notifier)
                                  .updateName(uid, playername);
                              context.pop();
                            },
                            icon: const Icon(Icons.check)),
                      ],
                    ),
                    const Text('stack'),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: width * 0.6,
                          child: TextField(
                            decoration:
                                const InputDecoration(labelText: 'stack'),
                            onChanged: (value) {
                              stack = int.parse(value);
                            },
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              ref
                                  .read(playerDataProvider.notifier)
                                  .updateStack(uid, stack);
                              context.pop();
                            },
                            icon: const Icon(Icons.check)),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Container(
        height: 64,
        width: 100,
        decoration: const BoxDecoration(color: ColorConstant.black60),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(myData.name ?? 'プレイヤー1', style: TextStyleConstant.bold14),
            Text(myData.stack.toString(), style: TextStyleConstant.bold20),
          ],
        ),
      ),
    );
  }
}
