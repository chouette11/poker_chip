import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poker_chip/provider/presentation_providers.dart';
import 'package:poker_chip/util/constant/color_constant.dart';
import 'package:poker_chip/util/constant/context_extension.dart';
import 'package:poker_chip/util/constant/text_style_constant.dart';

class IdTextField extends ConsumerWidget {
  const IdTextField(this.join, {super.key});

  final void Function(WidgetRef) join;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isStart = ref.watch(isJoinProvider);
    final error = ref.watch(errorTextProvider);
    return Visibility(
      visible: !isStart,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
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
                hintStyle:
                    TextStyle(fontSize: 16, color: ColorConstant.black50),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyleConstant.normal16
                  .copyWith(color: ColorConstant.black30),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: TextStyleConstant.bold12.copyWith(color: Colors.red),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => join(ref),
            child: Text(context.l10n.enter),
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.participantTaskKill,
            style: TextStyleConstant.normal16
                .copyWith(color: ColorConstant.black10),
          ),
        ],
      ),
    );
  }
}
