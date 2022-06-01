import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_chat_example/provider/chat_provider.dart';
import 'package:flutter_chat_example/widget/speech_bubble.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';

class ChatRoomPage extends StatefulWidget {
  final String ip;

  const ChatRoomPage({Key? key, required this.ip}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChatRoomPage();
}

class _ChatRoomPage extends State<ChatRoomPage> {
  late IOWebSocketChannel channel;
  final msgController = TextEditingController();
  final listController = ScrollController();
  final focusNode = FocusNode();
  var nickName = '';

  Future<void> getNickName() async {
    final prefs = await SharedPreferences.getInstance();
    nickName = prefs.getString('nickName') ?? '';
  }

  @override
  void initState() {
    super.initState();
    channel = IOWebSocketChannel.connect('ws://${widget.ip}');

    getNickName();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ChatProvider>(context, listen: false).updateChat(channel);
      Provider.of<ChatProvider>(context, listen: false).chatListRequest(widget.ip);
    });
  }

  @override
  void dispose() {
    super.dispose();
    channel.sink.close();
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    if (chatProvider.chatMapList.isNotEmpty) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        listController.animateTo(
          listController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 300),
        );
      });
    }

    return Scaffold(
      backgroundColor: Colors.greenAccent,
      appBar: AppBar(
        title: const Text('채팅방'),
      ),
      body: Column(
        children: [
          Expanded(child: Consumer<ChatProvider>(
            builder: (context, provider, child) {
              return ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
                child: ListView.builder(
                    controller: listController,
                    scrollDirection: Axis.vertical,
                    itemCount: provider.chatMapList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Container(
                          alignment: (provider.chatMapList[index]['nickName'] ==
                                  nickName)
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          width: MediaQuery.of(context).size.width,
                          child: (provider.chatMapList[index]['nickName'] ==
                                  nickName)
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 5, right: 3),
                                      child: Text(
                                        DateFormat('HH:mm').format(
                                            DateTime.fromMicrosecondsSinceEpoch(
                                                int.parse(chatProvider
                                                        .chatMapList[index]
                                                    ['epoch']))),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    SpeechBubble(
                                        isMe: true,
                                        text: provider.chatMapList[index]
                                            ['msg']),
                                  ],
                                )
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      alignment: Alignment.topLeft,
                                      child: const Icon(
                                        Icons.account_circle,
                                        size: 55,
                                        color: Colors.lightBlue,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 7),
                                        Text(provider.chatMapList[index]
                                            ['nickName']),
                                        const SizedBox(height: 2),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            SpeechBubble(
                                                isMe: false,
                                                text: provider
                                                    .chatMapList[index]['msg']),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 5, left: 3),
                                              child: Text(
                                                DateFormat('HH:mm').format(DateTime
                                                    .fromMicrosecondsSinceEpoch(
                                                        int.parse(chatProvider
                                                                .chatMapList[
                                                            index]['epoch']))),
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                        ),
                      );
                    }),
              );
            },
          )),
          Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: msgController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    focusNode: focusNode,
                  ),
                )),
                Container(
                  color: Colors.lightBlue,
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  child: IconButton(
                    color: Colors.white,
                    onPressed: () {
                      if (msgController.text.trim().isNotEmpty &&
                          nickName != '') {
                        var msg = {
                          'nickName': nickName,
                          'msg': msgController.text,
                          'epoch':
                              DateTime.now().microsecondsSinceEpoch.toString()
                        };
                        chatProvider.sendMessage(channel, msg);
                        msgController.text = '';
                        focusNode.requestFocus();
                      }
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
