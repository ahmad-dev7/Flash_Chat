import 'package:flash_chat_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _fireStore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
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
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              splashColor: Colors.redAccent,
              onPressed: () {
                Alert(
                  style: KAlertStyle,
                  context: context,
                  title: 'Are you sure!',
                  desc: 'You want to logout?',
                  buttons: [
                    DialogButton(
                      color: Colors.blueGrey,
                      child: Text('Cancel', style: KAlertButtonTextStyle),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    DialogButton(
                      color: Colors.red[700],
                      child: Text('Logout', style: KAlertButtonTextStyle),
                      onPressed: () {
                        setState(() {
                          _auth.signOut();
                          Navigator.pushReplacementNamed(context, '/');
                        });
                      },
                    )
                  ],
                ).show();
              },
              icon: const Icon(Icons.logout),
            )
          ],
          backgroundColor: const Color(0xff1f2936),
          title: const Text('⚡Flash Chat'),
        ),
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
                          CircularProgressIndicator(
                            backgroundColor: Colors.blueAccent,
                            semanticsLabel: 'Loading Chats...',
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
                    final messageWidget = MessageBubble(
                      message: messageText,
                      sender: messageSender,
                      loggedInUser: loggedInUser.email,
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

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.sender,
    required this.loggedInUser,
  });
  final String message;
  final String sender;
  final String? loggedInUser;
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
            Text(
              sender,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          Material(
            elevation: 10,
            color: loggedInUser == sender
                ? const Color.fromARGB(255, 48, 98, 148)
                : const Color(0xff182533),
            borderRadius: loggedInUser == sender
                ? KMessageBorder.copyWith(topLeft: const Radius.circular(50))
                : KMessageBorder.copyWith(topRight: const Radius.circular(50)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
