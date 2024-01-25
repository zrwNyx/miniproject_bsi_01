import 'package:http/http.dart' as http;

class DataSource {
  Future<String?> getChatRoom(String username) async {
    try {
      var response = await http
          .get(Uri.parse('http://127.0.0.1:8080/api/user/${username}'));
      return response.body;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String?> getChat(String username) async {
    try {
      var response = await http
          .get(Uri.parse('http://127.0.0.1:8080/api/room/${username}'));
      return response.body;
    } catch (e) {
      return null;
    }
  }

  Future<String?> getListChat(String id) async {
    try {
      var response =
          await http.get(Uri.parse('http://127.0.0.1:8080/api/chat/${id}'));
      return response.body;
    } catch (e) {
      return null;
    }
  }

  Future sendChat(String id, String username, String text) async {
    var response =
        await http.post(Uri.parse('http://127.0.0.1:8080/api/chat/'), body: {
      "id": id,
      "from": username,
      "text": text,
    });
  }

  Future makeRoom(String from, String to) async {
    var response =
        await http.post(Uri.parse('http://127.0.0.1:8080/api/room/'), body: {
      "from": from,
      "to": to,
    });
  }
}
