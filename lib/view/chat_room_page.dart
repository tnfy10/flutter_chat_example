import 'package:flutter/material.dart';
import 'package:flutter_chat_example/provider/chat_provider.dart';
import 'package:provider/provider.dart';

class ChatRoomPage extends StatelessWidget {
  const ChatRoomPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    var msgController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('채팅방'),
      ),
      body: Column(
        children: [
          Expanded(
              child: Consumer<ChatProvider>(
                builder: (context, provider, child) {
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: provider.chatMapList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          alignment: (provider.chatMapList[index].keys.first == 'user')
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          width: MediaQuery.of(context).size.width,
                          child: (provider.chatMapList[index].keys.first == 'user')
                              ? Text(provider.chatMapList[index].values.first)
                              : Column(
                                  children: [
                                    Text(provider.chatMapList[index].keys.first),
                                    Text(provider.chatMapList[index].values.first)
                            ],
                          ),
                        );
                      });
                },
              )
          ),
          SizedBox(
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: 50,
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                      controller: msgController,
                    )
                ),
                Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  child: IconButton(
                    onPressed: () {
                      var msg = {'user': msgController.text};
                      chatProvider.sendMessage(msg);
                      msgController.text = '';
                    },
                    icon: const Icon(
                      Icons.send_outlined,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
