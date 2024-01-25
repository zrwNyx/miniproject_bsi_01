import 'package:flutter/material.dart';
import 'package:mini_project/entity.dart';
import 'package:mini_project/presentation/ChatPage.dart';

class ChatList extends StatefulWidget {
  final String roomID;
  final String userName;
  final String selectedName;
  const ChatList(
      {required this.userName,
      required this.roomID,
      required this.selectedName});

  @override
  State<ChatList> createState() => _ChatListState();
}

List<Message> messages = [];

class _ChatListState extends State<ChatList> {
  TextEditingController textcontroller = TextEditingController();
  void test() async {
    messages.clear();
    var a = await usecase.getListChat(widget.roomID);

    for (var p in a) {
      messages.add(p);
    }
    print(messages);
    setState(() {});
  }

  @override
  initState() {
    //messages.clear();
    test();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              child: Icon(Icons.person),
            ),
            Text(widget.selectedName),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 600,
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final bool isMe = message.username == widget.userName;
                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(children: [
                      Text(message.text),
                    ]),
                  ),
                );
              },
            ),
          ),
          TextField(
            controller: textcontroller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Message',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              print(widget.roomID);
              usecase.sendData(
                  widget.roomID, widget.userName, textcontroller.text);
              test();
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }
}
