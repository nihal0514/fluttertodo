import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'add_page.dart';


class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();

}

List items=[];

class _TodoListPageState extends State<TodoListPage> {
  @override
  void initState() {
    fetchtodoList();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: RefreshIndicator(
        onRefresh: fetchtodoList,
        child: ListView.builder(
          itemCount: items.length,
            itemBuilder: (context,index){
            final item= items[index] as Map;
            final id=  item['_id'] as String;
              return ListTile(
                trailing: PopupMenuButton(
                  onSelected: (value){
                    if(value=='edit'){
                      navigateToeditPage();
                    }else if(value=='delete'){
                      deleteById(id);
                    }
                  },
                  itemBuilder: (context){
                    return [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      )
                    ];
                  },
                ),
                title: Text(item['title']),
                subtitle: Text(item['description']),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage,
        label: const Text('Add'),
    ), );
  }
  void navigateToAddPage(){
    final route= MaterialPageRoute(
        builder: (context)=>AddTodoPage(),
    );
    Navigator.push(context,route);
  }
  void navigateToeditPage(){
    final route= MaterialPageRoute(
      builder: (context)=>AddTodoPage(),
    );
    Navigator.push(context,route);
  }

  Future<void> fetchtodoList() async {
    const url= 'https://api.nstack.in/v1/todos';
    final uri= Uri.parse(url);
    final response= await http.get(uri);

    if(response.statusCode== 200){
      final json= jsonDecode(response.body) as Map;
      final result= json['items'] as List;
      setState(() {
       items= result;
      });
    }
  }
  Future<void> deleteById(id) async{
    final response= await http.delete(
      Uri.parse('https://api.nstack.in/v1/todos/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if(response.statusCode== 200){
      print('yes');
      fetchtodoList();
    }
  }
  /*Future<void> editById(id) async{
    final body= {
      "title": "",
      "description": description,
      "is_completed": false
    };

  }*/
}
