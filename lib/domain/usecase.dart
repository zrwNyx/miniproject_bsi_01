import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mini_project/data/datasource.dart';
import 'package:mini_project/data/repository.dart';
import 'package:mini_project/entity.dart';

class Usecase {
  Repository? _repository = Repository(DataSource());

  Future<List?> getChatRoom(String username) async {
    var b = await _repository!.getChatRoom(username);
    var data = jsonDecode(b!) as Map<String, dynamic>;
    var a = data!['data'] as Map<String, dynamic>;
    var c = a['rooms'] as List<dynamic>;
    //print(data);
    return c;
  }

  Future<List<dynamic>> getChat(String username) async {
    List<dynamic> listUsername = [];
    var b = await _repository!.getChat(username);
    var data = jsonDecode(b!) as Map<String, dynamic>;
    var a = data!['data'] as List<dynamic>;
    a.forEach((element) {
      listUsername.add(element['users']);
    });

    List<dynamic> filteredNames = listUsername
        .map((sublist) =>
            sublist.where((name) => name != '${username}').toList())
        .toList();
    List<dynamic> flatList =
        filteredNames.expand((sublist) => sublist).toList();

    List<dynamic> allMessages = [];
    for (var dataEntry in data['data']) {
      List<dynamic> messages = dataEntry['messages'];
      allMessages.addAll(messages);
    }

    print(allMessages);
    return flatList;
  }

  Future<List<Message>> getListChat(String id) async {
    var b = await _repository!.getListChat(id);
    var data = jsonDecode(b!) as Map<String, dynamic>;
    var c = data!['data'] as Map<String, dynamic>;
    var d = c['messages'] as List<dynamic>;
    List<Message> messages =
        d.map((jsonItem) => Message.fromJson(jsonItem)).toList();

    return messages;
  }

  Future sendData(String id, String username, String text) async {
    var myResponse = await _repository?.sendChat(id, username, text);
    return myResponse;
  }
}
