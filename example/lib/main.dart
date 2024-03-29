import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:light_im_sdk/light_im_sdk.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _textEditingController1 = TextEditingController(text: '6');
  final _textEditingController2 = TextEditingController(
    text: 'eyJhbGciOiJFZERTQSIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiNiIsInJvbGUiOjAsInN0YXR1cyI6MCwiaXNzIjoic3FueSIsImV4cCI6MTcwODMyNTQyOCwibmJmIjoxNzA3NzIwNjI4LCJpYXQiOjE3MDc3MjA2Mjh9.z1xT9Zv_AkITLPr3VCjb2RR5uEewer06HOvcroSlyc-xoXumuC4ehdLdTOlX2KReMxd7kKhi3sNqIFh7gAsJAA',
  );

  @override
  void initState() {
    super.initState();
    LightIMSDK.init(
        endpoint: '127.0.0.1:8080/im',
        listener: LightIMSDKListener(
          onReceiveNewMessage: (p0) {
             debugPrint(jsonEncode(p0.toMap()));
          },
        ));
  }

  @override
  void dispose() {
    _textEditingController1.dispose();
    _textEditingController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            controller: _textEditingController1,
          ),
          TextField(
            controller: _textEditingController2,
          ),
          ElevatedButton(
            onPressed: _login,
            child: const Text('登录'),
          ),
          ElevatedButton(
            onPressed: _sendMessage,
            child: const Text('发消息'),
          ),
        ],
      ),
    );
  }

  void _login() async {
    final res = await LightIMSDK.login(
      userId: _textEditingController1.text,
      token: _textEditingController2.text,
    );
     debugPrint(res.toString());
  }

  void _sendMessage() async {
    final res = await LightIMSDK.sendTextMessage(
      conversationId: 'c_6_7',
      text: '你好',
    );
    debugPrint(jsonEncode(res?.data?.toMap() ?? {}));
  }
}
