import 'dart:async';

import 'package:flutter_template/page/tutorial/component/tutorial_appbar.dart';
import 'package:flutter_template/page/tutorial/component/tutorial_text_field.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/util/constant/text_style_constant.dart';
import 'package:flutter_template/util/constant/color_constant.dart';
import 'package:go_router/go_router.dart';

class TutorialPage1 extends ConsumerStatefulWidget {
  const TutorialPage1({super.key});

  @override
  ConsumerState<TutorialPage1> createState() => _PageState();
}

class _PageState extends ConsumerState<TutorialPage1> {
  int count = 0;
  bool isVisible = false;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      print(count);
      setState(() => count++);
      if (count == 3) {
        isVisible = true;
        setState(() {});
      }
      if (count > 5) {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        top: false,
        child: Stack(
          children: [
            Scaffold(
              appBar: const TutorialAppBar(topic: 'うどん', counter: 120),
              backgroundColor: ColorConstant.back,
              bottomSheet: TutorialBottomSheet(
                index: 2,
                text: '何うどんが好き？',
                isFlash: count == 5,
                isEnd: false,
                isTypeWriter: isVisible,
                role: '人間',
                onTap: () => context.push('/tutorial/2'),
              ),
              floatingActionButton: _ScrollButton(onTap: () {}),
              body: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedTextKit(
                      isRepeatingAnimation: false,
                      animatedTexts: [
                        TypewriterAnimatedText(
                          'あなたは人間陣営\nお題に沿って質問をすることによって\nAIを探し出す',
                          textAlign: TextAlign.center,
                          textStyle: TextStyleConstant.normal16,
                        ),
                      ],
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.09,
              child: Visibility(
                visible: isVisible,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: ColorConstant.black30.withOpacity(0.7),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _ScrollButton extends StatelessWidget {
  const _ScrollButton({required this.onTap});

  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              height: 40,
              width: 40,
              decoration: const BoxDecoration(
                color: ColorConstant.accent,
                boxShadow: [
                  BoxShadow(
                    color: ColorConstant.black0,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.arrow_downward_sharp, size: 28),
            ),
          ),
        ],
      ),
    );
  }
}
