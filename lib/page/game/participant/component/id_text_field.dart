import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poker_chip/provider/presentation_providers.dart';
import 'package:poker_chip/util/constant/color_constant.dart';
import 'package:poker_chip/util/constant/text_style_constant.dart';

class IdTextField extends ConsumerWidget {
  const IdTextField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isStart = ref.watch(isJoinProvider);
    return Visibility(
      visible: !isStart,
      child: SizedBox(
        height: 100,
        width: 300,
        child: TextFormField(
          controller: ref.read(idTextFieldControllerProvider),
          textAlign: TextAlign.left,
          autofocus: false,
          cursorColor: ColorConstant.black30,
          maxLines: 1,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            fillColor: ColorConstant.black90,
            filled: true,
            hintText: '部屋IDを入力',
            hintStyle: TextStyle(fontSize: 16, color: ColorConstant.black50),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide.none,
            ),
          ),
          style: TextStyleConstant.normal16.copyWith(color: ColorConstant.black30),
        ),
      ),
    );
  }
}
