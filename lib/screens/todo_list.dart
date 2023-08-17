import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_app_rest_api_crud/screens/add_page.dart';
import 'package:http/http.dart' as http;

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isLoading = true;
  List items = [];

  @override
  void initState() {
    // TODO: implement initState
    fetchTodo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(child: CircularProgressIndicator(),),
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context,index){
              final item = items[index];
              final id = item['_id'] as String;
            return ListTile(
              leading: CircleAvatar(child: Text('${index + 1}')),
              title: Text(item['title']),
              subtitle: Text(item['description']),
              trailing: PopupMenuButton(
                onSelected: (value) {
                  if (value == 'edit') {
                    //open edit page
                  } else if(value == 'delete'){
                    //delete and remove item
                    deletebyId(id);
                  }
                },
                itemBuilder: (context){
                  return [
                    PopupMenuItem(
                      child: Text('Edit'),
                      value: 'edit',
                      ),
                    PopupMenuItem(
                      child: Text('Delete'),
                      value: 'delete',
                      ),
                  ];
                },
              ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: navigateToAddPage, label: Text('Add Todo')),
    );
  }

  void navigateToAddPage() {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(),
    );
    Navigator.push(context, route);
  }

  Future<void> deletebyId(String id) async{
    //delete item
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if(response.statusCode == 200){
      //remove item from list
      
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {
      //show error
      showErrorMessage('Deletion Failed');
    }
  }

  Future<void> fetchTodo() async{
    final url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      setState(() {
        items = result;
      });
    } 
    
      setState(() {
        isLoading=false;
      });
    
    print(response.statusCode);
    print(response.body);
  }

  //  void showSuccessMessage(String message){
  //  final snackBar = SnackBar(content: Text(message));
  //  ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //}

  void showErrorMessage(String message){
    final snackBar = SnackBar(
      content: Text(message,style: TextStyle(color:Colors.white),),
      backgroundColor: Colors.red,
      );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
