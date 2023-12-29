import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poker_chip/provider/presentation_providers.dart';
import 'package:poker_chip/util/constant/color_constant.dart';
import 'package:poker_chip/util/constant/text_style_constant.dart';

class UserBoxes extends ConsumerWidget {
  const UserBoxes({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final players = ref.watch(playerDataProvider);
    final others = players.where((e) => e.uid != ref.read(uidProvider)).toList();
    final users =
        others.map((e) => UserBox(name: e.name ?? '', stack: e.stack)).toList();
    if (users.isEmpty) {
      return Text(others.length.toString(), style: TextStyle(fontSize: 32),);
    } else {
      final List<Widget> child = [];
      final List<Widget> children = [];
      for (var i = 1; i < users.length; i++) {
        if (i % 2 == 0) {
          child.add(users[i]);
          children.add(SizedBox(height: 16));
          children.add(Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: child,
          ));
          child.clear();
        } else {
          child.add(users[i]);
        }
      }
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [users[0]],
          ),
          ...children,
        ],
      );
    }
  }
}

class UserBox extends StatelessWidget {
  const UserBox({super.key, required this.name, required this.stack});
  final String name;
  final int stack;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      width: 100,
      decoration: const BoxDecoration(color: ColorConstant.black60),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(name, style: TextStyleConstant.bold14),
          Text(stack.toString(), style: TextStyleConstant.bold20),
        ],
      ),
    );
  }
}
