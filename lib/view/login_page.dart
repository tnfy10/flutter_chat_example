import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chat_example/view/register_page.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/chat_provider.dart';
import 'chat_room_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  Future<http.Response> loginPostRequest(Map data) async {
    const url = 'http://myeoru.iptime.org:3000/login';

    var body = json.encode(data);

    var response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: body);
    print("${response.statusCode}");
    print("${response.body}");

    return response;
  }

  Future<void> setUserData(Map data) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('id', data['id']);
    await prefs.setString('nickName', data['nickName']);
    debugPrint("유저 정보 저장");
  }

  Future<dynamic> _showDialog(BuildContext context, String content) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Text(content),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('확인')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final idController = TextEditingController();
    final pwdController = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '채팅앱',
                style: TextStyle(fontSize: 30),
              ),
              const SizedBox(height: 80),
              SizedBox(
                width: 320,
                child: Column(
                  children: [
                    TextField(
                        controller: idController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), label: Text('아이디'))),
                    const SizedBox(height: 15),
                    TextField(
                      controller: pwdController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), label: Text('비밀번호')),
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                        onPressed: () {
                          final id = idController.text.trim();
                          final pwd = pwdController.text.trim();

                          if (id.isNotEmpty && pwd.isNotEmpty) {
                            Map data = {"id": id, "pwd": pwd};
                            loginPostRequest(data).then((value) {
                              if (value.statusCode == 200) {
                                setUserData(jsonDecode(value.body));
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ChangeNotifierProvider(
                                                create: (_) => ChatProvider(),
                                                child: const ChatRoomPage())));
                              } else {
                                _showDialog(context, '아이디와 비밀번호를 확인해주세요.');
                              }
                            });
                          } else {
                            _showDialog(context, '아이디와 비밀번호를 확인해주세요.');
                          }
                        },
                        style: ButtonStyle(
                            fixedSize:
                                MaterialStateProperty.all(const Size(320, 48))),
                        child: const Text('로그인')),
                    const SizedBox(height: 10),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RegisterPage()));
                        },
                        style: ButtonStyle(
                            fixedSize:
                                MaterialStateProperty.all(const Size(320, 48))),
                        child: const Text('회원가입'))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
