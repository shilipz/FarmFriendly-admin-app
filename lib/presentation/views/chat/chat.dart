import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cucumber_admin/domain/models/chat_model.dart';
import 'package:cucumber_admin/presentation/widgets/common_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cucumber_admin/utils/constants/constants.dart';

class ChatScreen extends StatefulWidget {
  final String farmerId;
  final String receiverName;
  final String senderId;
  final String senderName;
  const ChatScreen(
      {super.key,
      required this.farmerId,
      required this.receiverName,
      required this.senderId,
      required this.senderName});

  @override
  // ignore: library_private_types_in_public_api
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();

  void _handleSubmitted(String text) {
    _textController.clear();
    final user = FirebaseAuth.instance.currentUser;
    ChatMessage message = ChatMessage(
      isSentbyme: true,
      senderId: user!.uid, // Set the sender's user ID
      receiverId: widget.farmerId,
      message: text,
      timestamp: DateTime.now(),
    );

    String chatId = widget.farmerId + user.uid;
    String messageId = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId) // Use the generated timestamp as the document ID
        .set(message.toMap());
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    String chatId = widget.farmerId + user!.uid;
    return Scaffold(
      appBar: AppBar(
          leading: const Arrowback(backcolor: homeorange),
          backgroundColor: kwhite,
          title: Text(
            widget.receiverName,
            style: const TextStyle(color: homeorange),
          )),
      body: Column(
        children: <Widget>[
          Flexible(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(chatId)
                  .collection('messages')
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: snapshot.data!.docs.length,
                  reverse: false,
                  itemBuilder: (_, index) {
                    var message = ChatMessage.fromMap(snapshot.data!.docs[index]
                        .data() as Map<String, dynamic>);
                    return _buildMessage(message);
                  },
                );
              },
            ),
          ),
          const Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(ChatMessage message) {
    bool isSender = message.isSentbyme ?? false;

    CrossAxisAlignment crossAxisAlignment =
        isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    Color messageColor = isSender ? Colors.grey : transOrange;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Material(
            borderRadius: BorderRadius.circular(8.0),
            color: messageColor,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                message.message,
                style: const TextStyle(color: kwhite, fontSize: 15),
              ),
            ),
          ),
          Text(
            DateFormat('hh:mm a').format(message.timestamp),
            style: const TextStyle(fontSize: 12.0, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).canvasColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration:
                    const InputDecoration.collapsed(hintText: 'Send a message'),
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.send,
                color: Colors.grey,
              ),
              onPressed: () => _handleSubmitted(_textController.text),
            ),
          ],
        ),
      ),
    );
  }
}
