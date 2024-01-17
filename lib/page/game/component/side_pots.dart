import 'package:flutter/material.dart';

class SidePotsWidget extends StatelessWidget {
  const SidePotsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ListView.builder(
        itemBuilder: (context, itemCount) {
          return SizedBox(
            child: Column(
              children: [
                Text('Pot $itemCount'),

              ],
            ),
          );
        },
      ),
    );
  }
}
