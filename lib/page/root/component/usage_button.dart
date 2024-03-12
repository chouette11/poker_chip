import 'package:flutter/material.dart';
import 'package:poker_chip/util/constant/context_extension.dart';
import 'package:qr_flutter/qr_flutter.dart';

class UsageButton extends StatefulWidget {
  const UsageButton({super.key});

  @override
  State<UsageButton> createState() => _UsageButtonState();
}

class _UsageButtonState extends State<UsageButton> {
  int index = 0;
  final pages = [
    const _Page1(),
    const _Page2(),
    const _Page3(),
    const _Page4()
  ];

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Padding(
                  padding: const EdgeInsets.all(8), child: pages[index]),
              actions: [
                Row(
                  children: [
                    GestureDetector(child: Icon(Icons.arrow_left)),
                    Text('${index + 1} / ${pages.length}'),
                    GestureDetector(
                        onTap: () {
                          if (index == pages.length - 1) {
                            return;
                          }
                          index++;
                        },
                        child: Icon(Icons.arrow_right)),
                  ],
                )
              ],
            );
          },
        );
      },
      child: const Text('使い方'),
    );
  }
}

class _Page1 extends StatelessWidget {
  const _Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      width: 400,
      child: Column(
        children: [
          const Text('使い方'),
          const Text('1. 人数分のアプリが必要です'),
          const Text('一緒にプレイする人がまだインストールしていない場合は以下のQRコードからインストールしてください。'),
          SizedBox(child: QrImageView(data: 'https://onelink.to/pabhbm'))
        ],
      ),
    );
  }
}

class _Page2 extends StatelessWidget {
  const _Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      width: 400,
      child: Column(
        children: [
          const Text('使い方'),
          const Text('2. 部屋を作成'),
          Text(
              '誰か一人が\'${context.l10n.makeRoom}\'から部屋を作成してください。部屋作成者はユーザーを二人タップすることで席替えができます。'),
          SizedBox(child: QrImageView(data: 'https://onelink.to/pabhbm'))
        ],
      ),
    );
  }
}

class _Page3 extends StatelessWidget {
  const _Page3({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      width: 400,
      child: Column(
        children: [
          const Text('使い方'),
          const Text('3. 部屋に参加'),
          Text('他の人は\'${context.l10n.join}\'から部屋に参加し、RoomIDを入力してください。'),
          SizedBox(child: QrImageView(data: 'https://onelink.to/pabhbm'))
        ],
      ),
    );
  }
}

class _Page4 extends StatelessWidget {
  const _Page4({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      width: 400,
      child: Column(
        children: [
          const Text('使い方'),
          const Text('4. その他'),
          const Text('初期stackを変更したい場合は右上の設定から変更してください。'),
          SizedBox(child: QrImageView(data: 'https://onelink.to/pabhbm'))
        ],
      ),
    );
  }
}
