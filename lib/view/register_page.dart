import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  var _validate = true;
  var _ipCheck = true;
  var _idCheck = true;
  var _pwdCheck = true;
  var _pwd2Check = true;
  var _nickNameCheck = true;

  Future<http.Response> registerPostRequest(String ip, Map data) async {
    var url = 'http://$ip/register';

    var body = json.encode(data);

    var response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: body);
    debugPrint("${response.statusCode}");
    debugPrint(response.body);

    return response;
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
    final ipController = TextEditingController();
    final idController = TextEditingController();
    final pwdController = TextEditingController();
    final pwd2Controller = TextEditingController();
    final nickNameController = TextEditingController();
    final scrollController = ScrollController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: ipController,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    label: const Text('IP'),
                    errorText: _ipCheck ? null : '접속하실 IP를 입력해주세요'),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: idController,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    label: const Text('아이디'),
                    errorText: _idCheck ? null : '아이디를 입력해주세요'),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: pwdController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  label: const Text('비밀번호'),
                  errorText: _pwdCheck
                      ? _validate
                          ? null
                          : '비밀번호가 일치하지 않습니다.'
                      : '비밀번호를 입력해주세요',
                ),
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
              ),
              const SizedBox(height: 15),
              TextField(
                controller: pwd2Controller,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    label: const Text('비밀번호 확인'),
                    errorText: _pwd2Check
                        ? _validate
                            ? null
                            : '비밀번호가 일치하지 않습니다.'
                        : '비밀번호를 입력해주세요'),
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
              ),
              const SizedBox(height: 30),
              TextField(
                  controller: nickNameController,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      label: const Text('닉네임'),
                      errorText: _nickNameCheck ? null : '닉네임을 입력해주세요')),
              const SizedBox(height: 30),
              ElevatedButton(
                  onPressed: () {
                    final ip = ipController.text.trim();
                    final id = idController.text.trim();
                    final pwd = pwdController.text.trim();
                    final pwd2 = pwd2Controller.text.trim();
                    final nickName = nickNameController.text.trim();

                    if (ip.isNotEmpty &&
                        id.isNotEmpty &&
                        pwd.isNotEmpty &&
                        pwd2.isNotEmpty &&
                        nickName.isNotEmpty) {
                      if (pwd == pwd2) {
                        Map data = {"id": id, "pwd": pwd, "nickName": nickName};

                        registerPostRequest(ip, data).then((value) {
                          if (value.statusCode == 204) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                                (route) => false);
                          } else {
                            _showDialog(context, '잠시 후 다시 시도해주세요.');
                          }
                        });
                      } else {
                        setState(() {
                          _validate = !_validate;
                        });
                      }
                    } else {
                      setState(() {
                        _ipCheck = ip.isNotEmpty;
                        _idCheck = id.isNotEmpty;
                        _pwdCheck = pwd.isNotEmpty;
                        _pwd2Check = pwd2.isNotEmpty;
                        _nickNameCheck = nickName.isNotEmpty;
                      });
                    }
                  },
                  style: ButtonStyle(
                      fixedSize:
                          MaterialStateProperty.all(const Size(320, 48))),
                  child: const Text('회원가입 완료')),
            ],
          ),
        ),
      ),
    );
  }
}
