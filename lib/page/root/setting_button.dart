import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poker_chip/provider/presentation_providers.dart';

class SettingButton extends ConsumerStatefulWidget {
  const SettingButton({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingButton> createState() => _SettingButtonState();
}

class _SettingButtonState extends ConsumerState<SettingButton> {
  String stack = '1000';

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return IconButton(
      onPressed: () => showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('stack変更'),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                        width: width * 0.6,
                        child: TextField(
                          decoration: const InputDecoration(labelText: 'stack'),
                          onChanged: (value) {
                            stack = value;
                          },
                        )),
                    IconButton(
                        onPressed: () {
                          _stack(ref);
                          Navigator.pop(context);
                          print(stack);
                        },
                        icon: const Icon(Icons.check)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      icon: const Icon(Icons.settings),
    );
  }

  void _stack(WidgetRef ref) {
    ref.read(stackProvider.notifier).update((state) => int.parse(stack));
    print(ref.read(stackProvider));
  }
}
