import 'package:flutter/cupertino.dart';

class ChatProvider extends ChangeNotifier {
  List<Map> chatMapList = [
    {'홍길동': '안녕'},
    {'김길동': '빠이'},
    {'고길동': '????'},
  ];

  void sendMessage(Map<String, String> msg) {
    chatMapList.add(msg);
    notifyListeners();
  }
}