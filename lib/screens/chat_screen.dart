import 'package:flash_chat_app/components/drawer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:core';
import 'package:intl/intl.dart';
import 'package:flash_chat_app/components/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _fireStore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final dateFormatter = DateFormat('MMMM d');
  final timeFormatter = DateFormat('h:mm a');
  late User loggedInUser;
  late String messageText;
  bool hasText = false;

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      debugPrint('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff0e1621),
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Image.asset(
                  'assets/images/flash.png',
                  width: 20,
                ),
              ),
              const Text(' Flash Chat'),
              const SizedBox(width: 50)
            ],
          ),
          centerTitle: true,
          backgroundColor: const Color(0xff1f2936),
        ),
        drawer: const MenuDrawer(),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: _fireStore
                    .collection('messages')
                    .orderBy('Time')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.blueAccent,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  final messages = snapshot.data?.docs.reversed;
                  List<MessageBubble> messageWidgets = [];
                  for (var message in messages!) {
                    final messageData = message.data() as Map<String, dynamic>;
                    final messageText = messageData['Text'];
                    final messageSender = messageData['Sender'];
                    final messageTime = messageData['Time'] as Timestamp;
                    final senderName = messageData['Name'];
                    final senderImg = messageData['Photo'];
                    final datetime = DateTime.fromMillisecondsSinceEpoch(
                            messageTime.seconds * 1000)
                        .toLocal();
                    final formattedDate = dateFormatter.format(datetime);
                    final formattedTime = timeFormatter.format(datetime);
                    final messageWidget = MessageBubble(
                      message: messageText,
                      sender: messageSender,
                      loggedInUser: loggedInUser.email,
                      date: formattedDate,
                      time: formattedTime,
                      name: senderName,
                      photo: senderImg,
                    );
                    messageWidgets.add(messageWidget);
                  }
                  return Expanded(
                    child: ListView(
                      reverse: true,
                      children: messageWidgets,
                    ),
                  );
                },
              ),
              Container(
                decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        style: BorderStyle.solid,
                        color: Colors.blue,
                        width: 0.2,
                      ),
                    ),
                    color: Color(0xff17212b)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width / 1.14,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: messageTextController,
                          onChanged: (value) {
                            setState(() {
                              value.isEmpty ? hasText = false : hasText = true;
                            });
                            messageText = value;
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Type your message here...',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        messageTextController.clear();
                        await _fireStore.collection('messages').add({
                          'Text': messageText,
                          'Sender': loggedInUser.email,
                          'Time': DateTime.now(),
                          'Name': await _auth.currentUser!.displayName,
                          "Photo": await _auth.currentUser!.photoURL!.isEmpty
                              ? 'null'
                              : _auth.currentUser!.photoURL,
                        });
                      },
                      icon: hasText
                          ? const Icon(
                              Icons.send,
                              color: Color(0xff5288c1),
                              size: 30,
                            )
                          : const SizedBox(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
