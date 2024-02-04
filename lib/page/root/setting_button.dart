import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:poker_chip/page/component/ad/gdpr.dart';
import 'package:poker_chip/provider/presentation_providers.dart';
import 'package:poker_chip/util/constant/text_style_constant.dart';

class SettingButton extends ConsumerStatefulWidget {
  const SettingButton({Key? key}) : super(key: key);

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
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(labelText: 'stack'),
                        onChanged: (value) {
                          stack = int.parse(value);
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
                )
              ],
            ),
          ),
        ),
      ),
      icon: const Icon(Icons.settings),
    );
  }
}
