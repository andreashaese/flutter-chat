import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'message.dart';
import 'message_bubble.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _scrollController = ScrollController();
  final _textEditingController = TextEditingController();
  final _textFieldFocusNode = FocusNode();

  final _messagesRef =
      FirebaseFirestore.instance.collection("messages").withConverter<Message>(
            fromFirestore: (snapshot, _) => Message.fromJson(snapshot.data()!),
            toFirestore: (obj, _) => obj.toFirestore(),
          );
  late final Stream<QuerySnapshot<Message>> _messagesStream;

  @override
  void initState() {
    super.initState();

    _messagesStream = _messagesRef.orderBy("created_at").snapshots();
    // _messagesStream.listen((_) {
    //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //     _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    //   });
    // });
  }

  void _sendMessage(String message) {
    if (message.isEmpty) {
      return;
    }

    _messagesRef.add(Message(
      message: message,
      author: "Andreas",
      createdAt: DateTime.now(),
    ));
    _textEditingController.clear();
    _textFieldFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot<Message>>(
                stream: _messagesStream,
                builder: (context, snapshot) {
                  final messages = snapshot.data;

                  if (messages == null || messages.size == 0) {
                    return const Center(
                      child: Text("No messages"),
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: messages.size,
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: MessageBubble(messages.docs[i].data()),
                      );
                    },
                  );
                },
              ),
            ),
            const Divider(
              thickness: 1.0,
              color: Colors.black,
              height: 1.0,
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      focusNode: _textFieldFocusNode,
                      controller: _textEditingController,
                      textInputAction: TextInputAction.send,
                      onSubmitted: _sendMessage,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  ElevatedButton.icon(
                    onPressed: () {
                      _sendMessage(_textEditingController.text);
                    },
                    icon: const Icon(Icons.send),
                    label: const Text("Send"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
