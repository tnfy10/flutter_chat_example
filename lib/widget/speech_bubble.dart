import 'package:flutter/material.dart';

class SpeechBubble extends StatelessWidget {
  final String text;
  final bool isMe;

  const SpeechBubble({
    Key? key,
    required this.isMe,
    required this.text
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 200),
            decoration: BoxDecoration(
              color: isMe
                  ? Colors.amberAccent
                  : Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              child: Text(text),
            ),
          ),
        ],
      ),
    );
  }
}