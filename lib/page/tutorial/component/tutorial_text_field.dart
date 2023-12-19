import 'dart:async';

import 'package:flutter_template/page/tutorial/component/tutorial_answer_dialog.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/util/constant/text_style_constant.dart';
import 'package:flutter_template/util/constant/color_constant.dart';
import 'package:flutter_template/provider/presentation_providers.dart';

class TutorialBottomSheet extends StatelessWidget {
  const TutorialBottomSheet({
    super.key,
    required this.isEnd,
    required this.isFlash,
    required this.index,
    required this.role,
    this.text,
    required this.onTap,
    required this.isTypeWriter,
  });

  final bool isEnd;
  final bool isFlash;
  final int index;
  final String role;
  final String? text;
  final bool isTypeWriter;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    if (isEnd) {
      return _EndBottomSheet(index: index, role: role);
    } else {
      return TutorialTextField(
        isFlash: isFlash,
        text: text,
        index: index,
        isTypeWriter: isTypeWriter,
        onTap: onTap,
      );
    }
  }
}

class TutorialTextField extends ConsumerStatefulWidget {
  const TutorialTextField({
    super.key,
    required this.index,
    this.text,
    required this.isFlash,
    required this.isTypeWriter,
    required this.onTap,
  });

  final int index;
  final String? text;
  final bool isFlash;
  final bool isTypeWriter;
  final void Function() onTap;

  @override
  ConsumerState<TutorialTextField> createState() => _TutorialTextFieldState();
}

class _TutorialTextFieldState extends ConsumerState<TutorialTextField>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _color;
  int count = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() => count++);
      if (count % 2 == 0) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _color = ColorTween(
      begin: ColorConstant.accent,
      end: ColorConstant.accent2,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: ColorConstant.back,
        boxShadow: [
          BoxShadow(
            color: ColorConstant.black10,
            offset: Offset(0, -0.25),
            blurRadius: 0.5,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Flexible(
                child:
                    _CustomTextBox(1, widget.text ?? '', widget.isTypeWriter)),
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  widget.onTap();
                  _timer!.cancel();
                },
                child: AnimatedBuilder(
                  animation: _color,
                  builder: (context, child) {
                    return Icon(
                      Icons.send,
                      color:
                          widget.isFlash ? _color.value : ColorConstant.accent,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomTextBox extends ConsumerWidget {
  const _CustomTextBox(this.maxLine, this.text, this.isTypeWriter, {Key? key})
      : super(key: key);
  final int maxLine;
  final String text;
  final bool isTypeWriter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        TextFormField(
          controller: ref.read(tutorialTextFieldController),
          textAlign: TextAlign.left,
          cursorColor: ColorConstant.black30,
          maxLines: maxLine,
          decoration: const InputDecoration(
            fillColor: ColorConstant.black90,
            filled: true,
            hintText: 'メッセージを入力',
            hintStyle: TextStyle(fontSize: 16, color: ColorConstant.black50),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide.none,
            ),
          ),
          style:
              TextStyleConstant.normal16.copyWith(color: ColorConstant.black30),
        ),
        Visibility(
          visible: isTypeWriter,
          child: Container(
            height: 80,
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              color: ColorConstant.black90,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 12),
                AnimatedTextKit(
                  isRepeatingAnimation: false,
                  animatedTexts: [
                    TypewriterAnimatedText(
                      text,
                      speed: const Duration(milliseconds: 120),
                      textAlign: TextAlign.center,
                      textStyle: const TextStyle(
                          fontSize: 16, color: ColorConstant.black0),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _EndBottomSheet extends StatelessWidget {
  const _EndBottomSheet({super.key, required this.index, required this.role});

  final int index;
  final String role;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      color: ColorConstant.accent,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Spacer(),
            Text(
              'あなたは $role',
              style: TextStyleConstant.bold12,
            ),
            const Spacer(),
            SizedBox(
              width: 80,
              height: 32,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return TutorialAnswerDialog(index: index);
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: ColorConstant.accent,
                  backgroundColor: ColorConstant.main,
                ),
                child: Text(
                  '解答',
                  style: TextStyleConstant.bold12.copyWith(
                    color: ColorConstant.accent,
                  ),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
