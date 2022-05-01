import 'package:flutter/material.dart';
import 'package:flutter_chat_example/provider/chat_provider.dart';
import 'package:flutter_chat_example/view/chat_room_page.dart';
import 'package:flutter_chat_example/widget/fancy_fab.dart';
import 'package:provider/provider.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({Key? key}) : super(key: key);

  Future<void> _showMyDialog(BuildContext context) async {
    var codeController = TextEditingController();

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('입장 코드를 입력해주세요.'),
          content: TextField(
              controller: codeController,
              decoration: const InputDecoration(border: OutlineInputBorder())),
          actions: <Widget>[
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('입장'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider(
                          create: (_) => ChatProvider(),
                          child: const ChatRoomPage(),
                        )));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('채팅방 목록'),
      ),
      floatingActionButton: FancyFab(
        floatingButtonList: [
          FloatingActionButton(
            onPressed: () {},
            child: const Icon(
              Icons.add_outlined,
            ),
          ),
          FloatingActionButton(
            onPressed: () {
              _showMyDialog(context);
            },
            child: const Icon(
              Icons.login_outlined,
            ),
          ),
        ],
      ),
      body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: 30,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChangeNotifierProvider(
                                  create: (_) => ChatProvider(),
                                  child: const ChatRoomPage(),
                                )));
                  },
                  splashFactory: InkRipple.splashFactory,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    height: 50,
                    alignment: Alignment.centerLeft,
                    child: Text('테스트 $index'),
                  ),
                );
              })),
    );
  }
}
