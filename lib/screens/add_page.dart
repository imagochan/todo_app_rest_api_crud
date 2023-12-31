import 'package:flutter/material.dart';
import 'package:todo_app_rest_api_crud/services/todo_service.dart';

import '../utils/snackbar_helper.dart';

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({super.key,this.todo});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool isEdit=false;

  @override
  void initState(){
    super.initState();
    final todo = widget.todo;
    if (widget.todo != null) {
      isEdit = true;
      final title = todo?['title'];
      final description = todo?['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Edit Todo' : 'Add Todo',
          ),
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
          ElevatedButton(onPressed: isEdit ? updateData : submitData, child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              isEdit ? 'Update' : 'Submit'
              ),
          )),
        ],
      ),
    );
  }

  Future<void> updateData() async{
    // Get the data from form
    final todo = widget.todo;
    if (todo == null) {
      print('cannot call updated without data');
      return;
    }
    final id = todo['_id'];
    //final isCompleted = todo['is_completed'];
    // final title = titleController.text;
    // final description = descriptionController.text;
    // final body = {
    //   "title": title,
    //   "description":description,
    //   "is_completed":false,
    // };
    // Submit data to the server
    //final url = 'https://api.nstack.in/v1/todos/$id';
    //final uri = Uri.parse(url);
    final isSuccess = await TodoService.updateTodo(id,body);
      // show success or fail message based on status
    //print(response.statusCode);
    
    if (isSuccess) {
      //print('Creation Success');
      //titleController.text = '';
      //descriptionController.text = '';
      showSuccessMessage('Update Success');
      //print(response.body);
    } else {
      //print('Creation Failed');
      showErrorMessage(context,message:'Update Failed');
      //print(response.body);
    }
  }

  Future<void> submitData() async{
    // Get the data from form
    // final title = titleController.text;
    // final description = descriptionController.text;
    // final body = {
    //   "title": title,
    //   "description":description,
    //   "is_completed":false,
    // };
    // Submit data to the server
    // final url = 'https://api.nstack.in/v1/todos';
    // final uri = Uri.parse(url);
    final isSuccess = await TodoService.addTodo(body);
    // show success or fail message based on status
    //print(response.statusCode);
    
    if (isSuccess) {
      //print('Creation Success');
      titleController.text = '';
      descriptionController.text = '';
      showSuccessMessage('Creation Success');
      //print(response.body);
    } else {
      //print('Creation Failed');
      showErrorMessage(context, message: 'Creation Failed');
      //print(response.body);
    }
  }

  void showSuccessMessage(String message){
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Map get body {
    final title = titleController.text;
    final description = descriptionController.text;
    return {
      "title": title,
      "description":description,
      "is_completed":false,
    };
  }
}
