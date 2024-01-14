import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poker_chip/provider/presentation_providers.dart';
import 'package:poker_chip/util/constant/color_constant.dart';

class Chips extends StatelessWidget {
  const Chips({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      width: MediaQuery.of(context).size.width,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          Chip(color: Color(0xFF74AA9C), size: 64, value: 500),
          Chip(color: Color(0xFFA58CEA), size: 64, value: 300),
          Chip(color: Color(0xFF23ACD8), size: 64, value: 100),
          Chip(color: Color(0xFFFFC03F), size: 64, value: 50),
          Chip(color: Color(0xFFFF7D34), size: 64, value: 10),
        ],
      ),
    );
  }
}

class Chip extends ConsumerWidget {
  const Chip({
    super.key,
    required this.color,
    required this.size,
    required this.value,
  });

  final Color color;
  final double size;
  final int value;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(raiseBetProvider.notifier).update((state) => state + value);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size,
            height: size,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: ColorConstant.black90),
          ),
          SvgPicture.asset(
            'assets/images/chip.svg',
            width: size,
            height: size,
            color: color,
          ),
          Text(value.toString())
        ],
      ),
    );
  }
}
