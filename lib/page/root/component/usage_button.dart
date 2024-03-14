import 'package:flutter/material.dart';
import 'package:poker_chip/util/constant/color_constant.dart';
import 'package:poker_chip/util/constant/context_extension.dart';
import 'package:poker_chip/util/constant/text_style_constant.dart';
import 'package:qr_flutter/qr_flutter.dart';

class UsageButton extends StatelessWidget {
  const UsageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return UsageDialog();
          },
        );
      },
      child: const Text('使い方'),
    );
  }
}

class UsageDialog extends StatefulWidget {
  const UsageDialog({super.key});

  @override
  State<UsageDialog> createState() => _UsageDialogState();
}

class _UsageDialogState extends State<UsageDialog> {
  int index = 0;
  final pages = [
    const _Page1(),
    const _Page2(),
    const _Page3(),
    const _Page4()
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Padding(padding: const EdgeInsets.all(8), child: pages[index]),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                if (index == 0) {
                  return;
                }
                index--;
                setState(() {});
              },
              child: Icon(
                Icons.arrow_left,
                size: 48,
              ),
            ),
            Text('${index + 1} / ${pages.length}'),
            GestureDetector(
              onTap: () {
                print(index);
                if (index == pages.length - 1) {
                  return;
                }
                index++;
                setState(() {});
              },
              child: Icon(
                Icons.arrow_right,
                size: 48,
              ),
            ),
          ],
        )
      ],
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
          Text(
            '1. 人数分のアプリが必要です',
            style:
                TextStyleConstant.bold18.copyWith(color: ColorConstant.black10),
          ),
          const Text(
            '一緒にプレイする人がまだインストールしていない場合は以下のQRコードからインストールしてください',
            style: TextStyleConstant.text,
          ),
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
          Text(
            '2. 部屋作成',
            style:
            TextStyleConstant.bold18.copyWith(color: ColorConstant.black10),
          ),
          const Text(
            '誰か一人が\'部屋作成\'から部屋を作成してください。部屋作成者はユーザーを二人タップすることで席替えが出来ます',
            style: TextStyleConstant.text,
          ),        ],
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
          Text(
            '3. 部屋に参加',
            style:
            TextStyleConstant.bold18.copyWith(color: ColorConstant.black10),
          ),
          const Text(
            '他の人は\'参加する\'から部屋に参加し、RoomIDを入力してください。',
            style: TextStyleConstant.text,
          ),
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
          const Text('4. その他'),
          const Text('初期stackを変更したい場合は右上の設定から変更してください。'),
        ],
      ),
    );
  }
}
