import 'package:flutter/material.dart';
import 'package:flutter_chat_example/view/chat_list_page.dart';
import 'package:flutter_chat_example/view/register_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var idController = TextEditingController();
    var pwdController = TextEditingController();

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
                            border: OutlineInputBorder(), label: Text('비밀번호'))),
                    const SizedBox(height: 30),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ChatListPage()));
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
