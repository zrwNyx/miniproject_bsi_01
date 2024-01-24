import 'package:mini_project/data/datasource.dart';

class Repository {
  final DataSource _dataSource;

  Repository(this._dataSource);

  Future<String?> getChatRoom(String username) async {
    var a = await _dataSource.getChatRoom(username);
    print(a);
    return a;
  }

  Future<String?> getChat(String username) async {
    var a = await _dataSource.getChat(username);
    //print(a);
    return a;
  }

  Future<String?> getListChat(String id) async {
    var a = await _dataSource.getListChat(id);
    //print(a);
    return a;
  }

  Future sendChat(String id, String username, String text) async {
    var a = await _dataSource.sendChat(id, username, text);
    //print(a);
    return a;
  }
}
