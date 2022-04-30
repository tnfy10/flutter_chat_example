import 'package:flutter/material.dart';
import 'package:flutter_chat_example/view_destinations.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var idController = TextEditingController();
    var pwdController = TextEditingController();
    var pwd2Controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
                controller: idController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), label: Text('아이디'))),
            const SizedBox(height: 30),
            TextField(
                controller: pwdController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), label: Text('비밀번호'))),
            const SizedBox(height: 15),
            TextField(
                controller: pwd2Controller,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), label: Text('비밀번호 확인'))),
            const SizedBox(height: 30),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context,
                      ViewDestinations.login,
                      (route) => false
                  );
                },
                style: ButtonStyle(
                    fixedSize:
                    MaterialStateProperty.all(const Size(320, 48))),
                child: const Text('회원가입 완료')),
          ],
        ),
      ),
    );
  }

}