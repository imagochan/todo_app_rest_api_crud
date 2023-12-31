import 'dart:convert';

import 'package:http/http.dart' as http;

// all todo api call will be here
class TodoService {
  static Future<bool> deletebyId(String id) async{
    //delete item
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    //will return true or false depending on the OK status code.
    return response.statusCode == 200;
  }

  static Future<List?> fetchTodos() async{
    final url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      return result;
    } else {
      return null;
    }
  }

  //returns boolean because it can either work or fail
  static Future<bool> updateTodo(String id, Map body) async{
    // Submit data to the server
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'}
      );
    return response.statusCode == 200;
  }

  //returns boolean because it can either work or fail
  static Future<bool> addTodo(Map body) async{
    // Submit data to the server
    final url = 'https://api.nstack.in/v1/todos/';
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'}
      );
    return response.statusCode == 201;
  }
}