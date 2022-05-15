import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';

class ChatProvider extends ChangeNotifier {
  final url = "http://myeoru.iptime.org:3000";
  final List<Map> chatMapList = [];

  void sendMessage(IOWebSocketChannel channel, Map<String, String> msg) {
    channel.sink.add(jsonEncode(msg));
  }

  void updateChat(IOWebSocketChannel channel) {
    channel.stream.listen((event) {
      debugPrint("이벤트 발생: ${event.toString()}");
      chatMapList.add(jsonDecode(event));
      notifyListeners();
    }, onDone: () {
      debugPrint("onDone() 호출");
    }, onError: (err) {
      debugPrint("listen 에러: $err");
    });
  }

  Future<void> chatListRequest() async {
    var response = await http.get(Uri.parse("$url/chat"));
    print("${response.statusCode}");
    print("${response.body}");

    var data = jsonDecode(response.body);

    for (var item in data) {
      chatMapList.add(item);
    }

    notifyListeners();
  }
}