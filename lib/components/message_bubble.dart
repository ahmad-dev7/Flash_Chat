import 'package:flutter/material.dart';

import '../constants.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.sender,
    required this.loggedInUser,
    required this.time,
    required this.name,
    required this.photo,
    required this.date,
  });
  final String message;
  final String sender;
  final String? loggedInUser;
  final String time;
  final String date;
  final String? name;
  final String? photo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        crossAxisAlignment: loggedInUser == sender
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          if (loggedInUser != sender)
            Padding(
              padding: const EdgeInsets.only(left: 48),
              child: Text(
                '$name',
                style: const TextStyle(
                    color: Color.fromARGB(255, 84, 127, 160), fontSize: 13.8),
              ),
            ),
          Row(
            mainAxisAlignment: loggedInUser == sender
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              loggedInUser == sender
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: CircleAvatar(
                        backgroundColor: const Color(0xFF273E4A),
                        radius: 22,
                        child: photo != "null"
                            ? ClipOval(
                                child: Image(
                                  image: NetworkImage(photo.toString()),
                                  fit: BoxFit.fitWidth,
                                  width: 44,
                                  height: 44,
                                ),
                              )
                            : const Icon(
                                Icons.person,
                                size: 20,
                                color: Colors.white54,
                              ),
                      ),
                    ),
              Material(
                elevation: 10,
                color: loggedInUser == sender
                    ? const Color(0xFF306294)
                    : const Color(0xff182533),
                borderRadius: loggedInUser == sender
                    ? KMessageBorder.copyWith(
                        topLeft: const Radius.circular(50))
                    : KMessageBorder.copyWith(
                        topRight: const Radius.circular(50)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Text(
                    message,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 48),
            child: Text(
              '$date, $time',
              style: const TextStyle(color: Color(0xff3f515e), fontSize: 13),
            ),
          )
        ],
      ),
    );
  }
}
