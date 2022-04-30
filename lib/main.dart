import 'package:flutter/material.dart';
import 'package:flutter_chat_example/view/chat_list_page.dart';
import 'package:flutter_chat_example/view/chat_room_page.dart';
import 'package:flutter_chat_example/view/login_page.dart';
import 'package:flutter_chat_example/view/register_page.dart';
import 'package:flutter_chat_example/view_destinations.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: ViewDestinations.login,
      routes: {
        ViewDestinations.register : (context) => const RegisterPage(),
        ViewDestinations.chatList : (context) => const ChatListPage(),
        ViewDestinations.chatRoom : (context) => const ChatRoomPage()
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}