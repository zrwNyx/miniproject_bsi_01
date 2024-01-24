import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mini_project/domain/usecase.dart';
import 'package:mini_project/entity.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

List<dynamic> chatroom = [];
var usecase = Usecase();

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController usernamecontroller = TextEditingController();
  @override
  initState() {
    usecase.getListChat('ondNC');
    super.initState();
  }

  void getAllData(String username) async {
    var a = await usecase.getChatRoom(username) as List<dynamic>;
    chatroom = a;
    setState(() {
      String test;
      if (chatroom.length > 0) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatPage(
                    username: username,
                    roomID: chatroom,
                  )),
        );
      }
    });
    print(chatroom);
  }

  @override
  Widget build(BuildContext context) {
    print(chatroom.length);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo Home Page'),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          TextField(
            controller: usernamecontroller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Username',
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                getAllData(usernamecontroller.text);
              });
            },
            child: const Text('Login'),
          ),
        ]),
      ),
    );
  }
}

class ChatPage extends StatefulWidget {
  final String username;
  final List roomID;
  ChatPage({required this.username, required this.roomID});

  @override
  State<ChatPage> createState() => _ChatPageState(username: this.username);
}

class _ChatPageState extends State<ChatPage> {
  final String username;
  _ChatPageState({required this.username});

  @override
  initState() {
    getChat();
    super.initState();
  }

  List<dynamic> chat = [];
  void getChat() async {
    var resp = await usecase.getChat(widget.username);
    setState(() {
      resp.forEach((element) {
        chat.add(element);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Chat Page'),
        ),
        body: Center(
            child: ListView.builder(
          itemCount: chat.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(chat[index]),
              onTap: () {
                String a = widget.roomID[index].toString();
                print(a);
                usecase.getListChat(a);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatList(
                            userName: widget.username,
                            roomID: a,
                          )),
                );
              },
            );
          },
        )));
  }
}

class ChatList extends StatefulWidget {
  final String roomID;
  final String userName;
  const ChatList({required this.userName, required this.roomID});

  @override
  State<ChatList> createState() => _ChatListState();
}

List<Message> messages = [];

class _ChatListState extends State<ChatList> {
  TextEditingController textcontroller = TextEditingController();
  void test() async {
    messages.clear();
    var a = await usecase.getListChat(widget.roomID);
    setState(() {
      for (var p in a) {
        messages.add(p);
      }
      print(messages);
    });
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
          title: const Text('Chat List'),
        ),
        body: Column(
          children: [
            Container(
              height: 600,
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(messages[index].text),
                    subtitle: Text(messages[index].username),
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
                setState(() {
                  test();
                });
              },
              child: const Text('Send'),
            ),
          ],
        ));
  }
}
