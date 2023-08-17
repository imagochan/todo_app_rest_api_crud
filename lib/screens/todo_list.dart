import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:todo_app_rest_api_crud/screens/add_page.dart';
import 'package:todo_app_rest_api_crud/services/todo_service.dart';
import 'package:todo_app_rest_api_crud/widgets/todo_card.dart';
import '../utils/snackbar_helper.dart';

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
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              }
            ),
            child: Visibility(
              visible: items.isNotEmpty,
              replacement: Center(child: Text('No Todo Items',style: Theme.of(context).textTheme.headlineMedium,)),
              child: ListView.builder(
                itemCount: items.length,
                padding: EdgeInsets.all(8),
                itemBuilder: (context,index){
                  final item = items[index];
                  //final id = item['_id'] as String;
                return TodoCard(
                  index: index, 
                  item: item, 
                  navigateEdit: navigateToEditPage, 
                  deletebyId: deletebyId
                );
                },
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: navigateToAddPage, label: Text('Add Todo')),
    );
  }

  Future<void> navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(todo: item),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading=true;
    });
    fetchTodo();
  }

  Future<void> navigateToAddPage() async{
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading=true;
    });
    fetchTodo();
  }

  Future<void> deletebyId(String id) async{
    //delete item
    final isSuccess = await TodoService.deletebyId(id);//new call belongs to todo service
    if(isSuccess){
      //remove item from list
      
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {
      //show error
      showErrorMessage(context,message:'Deletion failed');
    }
  }

  Future<void> fetchTodo() async{
    final response = await TodoService.fetchTodos();

    if (response !=null) {
      setState(() {
        items = response;
      });
    } else {
      showErrorMessage(context,message:'something went wrong');
    }
    setState(() {
      isLoading=false;
    });
    
    //print(response.statusCode);
    //print(response.body);
  }

  //  void showSuccessMessage(String message){
  //  final snackBar = SnackBar(content: Text(message));
  //  ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //}

  // void showErrorMessage(String message){
  //   final snackBar = SnackBar(
  //     content: Text(message,style: TextStyle(color:Colors.white),),
  //     backgroundColor: Colors.red,
  //     );
  //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
  // }
}
