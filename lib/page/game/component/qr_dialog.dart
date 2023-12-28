import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poker_chip/util/constant/color_constant.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrDialog extends ConsumerWidget {
  const QrDialog(this.id, {super.key});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      backgroundColor: ColorConstant.black100,
      content: SizedBox(
        width: 240,
        height: 160,
        child: QrImageView(
          data: id,
          version: QrVersions.auto,
          size: 200.0,
        ),
      ),
    );
  }
}
