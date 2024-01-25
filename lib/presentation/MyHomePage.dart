import 'package:flutter/material.dart';
import 'package:mini_project/domain/usecase.dart';
import 'package:mini_project/presentation/ChatPage.dart';

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
    super.initState();
  }

  void getAllData(String username) async {
    var a = await usecase.getChatRoom(username) as List<dynamic>;
    chatroom = a;
    setState(() {
      if (chatroom.length > 0) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatPage(
                    username: username,
                    roomID: chatroom,
                  ) as Widget),
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
