import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peerdart/peerdart.dart';
import 'package:poker_chip/provider/presentation_providers.dart';

class Host extends ConsumerStatefulWidget {
  const Host({Key? key}) : super(key: key);

  @override
  ConsumerState<Host> createState() => _DataConnectionExampleState();
}

class _DataConnectionExampleState extends ConsumerState<Host> {
  final TextEditingController _controller = TextEditingController();
  String? peerId;
  late DataConnection conn;
  bool connected = false;

  @override
  void dispose() {
    final peer = ref.read(peerProvider);
    peer.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final peer = ref.read(peerProvider);
    ref.read(isConnProvider(peer).notifier).open(context);
  }

  void sendHelloWorld() {
    print('send');
    print(ref.read(conProvider('')).open);
    print(ref.read(conProvider('')).label);
    ref.read(conProvider('')).send('data');
  }

  void sendBinary() {
    final bytes = Uint8List(30);
    conn.sendBinary(bytes);
  }

  void closeConnection() {
    final peer = ref.read(peerProvider);
    peer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _renderState(),
              const Text(
                'Connection ID:',
              ),
              SelectableText('c78da73a-9b97-4efc-9303-4161de32b84f'),
              TextField(
                controller: _controller,
              ),
              ElevatedButton(
                  onPressed: sendHelloWorld,
                  child: const Text("Send Hello World to peer")),
              ElevatedButton(
                  onPressed: sendBinary,
                  child: const Text("Send binary to peer")),
              ElevatedButton(
                  onPressed: closeConnection,
                  child: const Text("Close connection,")),
            ],
          ),
        ));
  }

  Widget _renderState() {
    Color bgColor = connected ? Colors.green : Colors.grey;
    Color txtColor = Colors.white;
    String txt = connected ? "Connected" : "Standby";
    return Container(
      decoration: BoxDecoration(color: bgColor),
      child: Text(
        txt,
        style:
            Theme.of(context).textTheme.titleLarge?.copyWith(color: txtColor),
      ),
    );
  }
}
