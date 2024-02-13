import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:poker_chip/data/revenue_data_source.dart';
import 'package:poker_chip/page/component/ad/gdpr.dart';
import 'package:poker_chip/provider/domain_providers.dart';
import 'package:poker_chip/provider/presentation_providers.dart';
import 'package:poker_chip/util/constant/color_constant.dart';
import 'package:poker_chip/util/constant/text_style_constant.dart';

class SettingButton extends ConsumerStatefulWidget {
  const SettingButton({super.key});

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

    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (BuildContext context) => LoaderOverlay(
          closeOnBackButton: true,
          overlayColor: ColorConstant.black90.withOpacity(0.5),
          child: Dialog(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '初期stack変更',
                    style: TextStyleConstant.normal14
                        .copyWith(color: ColorConstant.black0),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: width * 0.6,
                        child: TextFormField(
                          initialValue: ref.read(stackProvider).toString(),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: const InputDecoration(labelText: 'stack'),
                          onChanged: (value) {
                            stack = int.tryParse(value) ?? 1000;
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
                  const SizedBox(height: 16),
                  _DottedDivider(),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () async {
                      context.loaderOverlay.show();
                      Future.delayed(const Duration(seconds: 8), () {
                        context.loaderOverlay.hide();
                      });
                      final a = await ref.read(revenueProvider).buyMonthly();

                      ref.refresh(isProUserProvider);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border:
                              Border.all(width: 2, color: ColorConstant.black10),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                const Icon(
                                  Icons.block,
                                  size: 48,
                                  color: ColorConstant.black40,
                                ),
                                RichText(
                                  textAlign: TextAlign.end,
                                  text: const TextSpan(children: [
                                    TextSpan(
                                      text: 'A',
                                      style: TextStyle(
                                        fontSize: 24,
                                        color: ColorConstant.black0,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'd',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: ColorConstant.black0,
                                      ),
                                    ),
                                  ]),
                                ),
                              ],
                            ),
                            Text(
                              '広告の削除',
                              style: TextStyleConstant.normal18.copyWith(
                                color: ColorConstant.black30,
                              ),
                            ),
                            Text(
                              '¥ 280 / 月',
                              style: TextStyleConstant.normal14.copyWith(
                                color: ColorConstant.black30,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Text(
                    '※キャンセルしない限り自動更新されます',
                    style: TextStyleConstant.normal14
                        .copyWith(color: ColorConstant.black40),
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
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.settings, color: ColorConstant.black0),
            Text(
              '設定',
              style: TextStyleConstant.normal16
                  .copyWith(color: ColorConstant.black0),
            )
          ],
        ),
      ),
    );
  }
}

class _DottedDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double lineWidth = constraints.maxWidth; // Dividerの横幅
        const double dashWidth = 5.0; // 点線の幅
        const double dashSpace = 5.0; // 線と線の間隔

        // 点線の個数を計算
        int dashCount = (lineWidth / (dashWidth + dashSpace)).floor();

        return SizedBox(
          width: lineWidth,
          height: 2.0, // Dividerの高さ
          child: ListView.builder(
            itemCount: dashCount,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              // 各点線の描画
              return Container(
                width: dashWidth,
                height: 1.0, // 点線の高さ
                color: Colors.black, // 点線の色
                margin: const EdgeInsets.symmetric(horizontal: dashSpace),
              );
            },
          ),
        );
      },
    );
  }
}
