import 'package:flutter/material.dart';
import 'package:mini_project/domain/usecase.dart';
import 'package:mini_project/presentation/ChatList.dart';

class ChatPage extends StatefulWidget {
  final String username;
  final List roomID;
  ChatPage({required this.username, required this.roomID});

  @override
  State<ChatPage> createState() => _ChatPageState(username: this.username);
}

var usecase = Usecase();

class _ChatPageState extends State<ChatPage> {
  final String username;
  _ChatPageState({required this.username});

  List<dynamic> alluser = ['adinugraha', 'tutisusanti', 'bambangp'];
  List<dynamic> chat = [];
  List Filter = [];
  List filteredList = [];
  List roomID = [];

  void _showMyDialog(BuildContext context, List filter) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to close dialog
      builder: (BuildContext context) {
        String s = '';
        if (filter.length > 0) {
          s = filter[0].toString();
        } else {
          s = 'User tidak tersedia';
        }
        return AlertDialog(
          title: const Text('Tambah Chat'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text(
                    '$s',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () async {
                    print('$s');
                    if (filter.length > 0) {
                      await usecase.makeRoom(widget.username, s);
                      setState(() {
                        chat.clear();
                        roomID.clear();
                        getChat();
                      });
                    }
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  initState() {
    getChat();

    super.initState();
  }

  void getChat() async {
    var s = await usecase.getChatRoom(widget.username);
    var resp = await usecase.getChat(widget.username);
    setState(() {
      s!.forEach((element) {
        roomID.add(element);
      });
      resp.forEach((element) {
        chat.add(element);
        Filter.add(element);
      });
    });
    Filter.add(widget.username);
    print(Filter);
    filteredList = alluser.where((user) => !Filter.contains(user)).toList();
    print(filteredList);
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
              leading: CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: Text(chat[index]),
              onTap: () {
                String a = roomID[index].toString();
                print(a);
                usecase.getListChat(a);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatList(
                            userName: widget.username,
                            roomID: a,
                            selectedName: chat[index],
                          )),
                );
              },
            );
          },
        )),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showMyDialog(context, filteredList),
          child: const Icon(Icons.add),
          backgroundColor: Colors.green,
        ));
  }
}
