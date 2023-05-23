import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;

class AddTodoPage extends StatefulWidget {

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {

   TextEditingController titleController = TextEditingController();
   TextEditingController descriptionController = TextEditingController();

   bool isEdit= false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text(
          isEdit? 'Edit Todo': 'Add Todo',
        ),
      ),
      body: ListView(
       children:[
         TextField(
           controller: titleController,
           decoration: const InputDecoration(
             border: OutlineInputBorder(),
             hintText: 'Title',
           ),
         ),
         TextField(
           controller: descriptionController,
           decoration: const InputDecoration(
             border: OutlineInputBorder(),
             hintText: 'Description',
           ),
         ),
         ElevatedButton(
             onPressed: submitData,
             child: const Text('Submit'),
         )
       ],
      ),
    );
  }
  Future<void> submitData() async {

    final title= titleController.text;
    final description= descriptionController.text;

    final body= {
      "title": title,
      "description": description,
      "is_completed": false
    };

    const url= 'https://api.nstack.in/v1/todos';
    final uri= Uri.parse(url);

    final response= await http.post(
        uri,
        body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json'
      },
    );

    if(response.statusCode== 201){
      //resetting the text field

      titleController.text= " ";
      descriptionController.text= " ";

      showSuccessMessage('Creation Success');
    }else{
      showErrorMessage('creation failed');
    }
  }

  void showSuccessMessage(String message){
    final snackBar= SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
   void showErrorMessage(String message){
     final snackBar= SnackBar(content: Text(message));
     ScaffoldMessenger.of(context).showSnackBar(snackBar);
   }
}
