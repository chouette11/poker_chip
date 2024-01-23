import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poker_chip/util/constant/color_constant.dart';

class RootPageDebug extends ConsumerStatefulWidget {
  const RootPageDebug({Key? key}) : super(key: key);

  @override
  ConsumerState<RootPageDebug> createState() => _RootPageDebugState();
}

class _RootPageDebugState extends ConsumerState<RootPageDebug> {
  bool isChanged = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: ColorConstant.back,
        body: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 52),
                    ElevatedButton(
                      onPressed: () async {
                        context.push('/host');
                        
                      },
                      child: const Text('部屋作成'),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () async {
                        context.go('/participant');
                      },
                      child: const Text('参加する'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        context.go('/participant', extra: '5f865cf4-02d2-4249-812e-d0c5d8eecad3');
                      },
                      child: const Text('参加する'),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () async {
                        context.push('/ori');
                      },
                      child: const Text('ori'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        context.push('/host_ex');
                      },
                      child: const Text('host'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
