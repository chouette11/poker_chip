import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:poker_chip/page/component/ad/gdpr.dart';
import 'package:poker_chip/provider/presentation_providers.dart';
import 'package:poker_chip/util/constant/color_constant.dart';
import 'package:poker_chip/util/constant/text_style_constant.dart';

class SettingButton extends ConsumerStatefulWidget {
  const SettingButton({super.key});

  @override
  ConsumerState<SettingButton> createState() => _SettingButtonState();
}

class _SettingButtonState extends ConsumerState<SettingButton> {
  bool isGDPR = false;

  @override
  void initState() {
    Future(() async => isGDPR = await isUnderGdpr());
    super.initState();
  }

  int stack = 1000;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    int sb = 10;
    int bb = 20;
    int sb2 = 20;
    int bb2 = 40;

    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '初期stack変更',
                  style: TextStyleConstant.normal14
                      .copyWith(color: ColorConstant.black0),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: width * 0.6,
                      child: TextFormField(
                        initialValue: ref.read(stackProvider).toString(),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(labelText: 'stack'),
                        onChanged: (value) {
                          stack = int.tryParse(value) ?? 1000;
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        ref
                            .read(stackProvider.notifier)
                            .update((state) => stack);
                        context.pop();
                      },
                      icon: const Icon(Icons.check),
                    ),
                  ],
                ),
                Visibility(
                  visible: isGDPR,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: () => changeGDPR(),
                        child: Text(
                          'GDPRを変更',
                          style: TextStyleConstant.normal10
                              .copyWith(color: Colors.blueAccent),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text('Blind Levels'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    SizedBox(
                      width: width * 0.2,
                      child: TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'SB 1',
                        ),
                        controller: TextEditingController(text: '10'),
                        onChanged: (value) {
                          sb = int.parse(value);
                        },
                      ),
                    ),
                    SizedBox(
                      width: width * 0.2,
                      child: TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'BB 1',
                        ),
                        controller: TextEditingController(text: '20'),
                        onChanged: (value) {
                          bb = int.parse(value);
                        },
                      ),
                    ),
                    SizedBox(
                      width: width * 0.3,
                      child: TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Duration 1',
                        ),
                        controller: TextEditingController(text: '5'),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                      child: IconButton(
                        onPressed: () {
                          ref.read(sbProvider.notifier).update((state) => sb);
                          ref.read(bbProvider.notifier).update((state) => bb);
                          context.pop();
                        },
                        icon: const Icon(Icons.check),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: width * 0.2,
                      child: TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'SB 2',
                        ),
                        onChanged: (value) {
                          sb2 = int.parse(value);
                        },
                      ),
                    ),
                    SizedBox(
                      width: width * 0.2,
                      child: TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'BB 2',
                        ),
                        onChanged: (value) {
                          bb2 = int.parse(value);
                        },
                      ),
                    ),
                    SizedBox(
                      width: width * 0.3,
                      child: const TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Duration 2',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                      child: IconButton(
                          onPressed: () {
                            context.pop();
                          },
                          icon: const Icon(Icons.close)),
                    ),
                  ],
                ),
                ElevatedButton(
                    onPressed: () {}, child: const Text('Add another level')),
              ],
            ),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.settings, color: ColorConstant.black0),
            Text(
              '設定',
              style: TextStyleConstant.normal16
                  .copyWith(color: ColorConstant.black0),
            )
          ],
        ),
      ),
    );
  }
}
