import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Todo'),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            decoration: InputDecoration(hintText: 'Title'),
            controller: titleController,
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(hintText: 'Description'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(onPressed: submitData, child: Text('Submit')),
        ],
      ),
    );
  }

  Future<void> submitData() async{
    // Get the data from form
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description":description,
      "is_completed":false,
    };
    // Submit data to the serverç
    final url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'}
      );
    // show success or fail message based on status
    print(response.statusCode);
    
    if (response.statusCode == 201) {
      //print('Creation Success');
      titleController.text = '';
      descriptionController.text = '';
      showSuccessMessage('Creation Success');
      //print(response.body);
    } else {
      //print('Creation Failed');
      showErrorMessage('Creation Failed');
      //print(response.body);
    }
  }

  void showSuccessMessage(String message){
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showErrorMessage(String message){
    final snackBar = SnackBar(
      content: Text(message,style: TextStyle(color:Colors.white),),
      backgroundColor: Colors.red,
      );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
