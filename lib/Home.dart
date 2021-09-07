import 'package:daily_note_bt/helper/AnnotationHelper.dart';
import 'package:daily_note_bt/model/Annotation.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  var _db = AnnotationHelper();

  _showScreenAdd(){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Add note"),
            content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _titleController,
                      autofocus: true,
                      decoration: InputDecoration(
                          labelText: "Title",
                          hintText: "Type title..."
                      ),
                    ),
                    TextField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                            labelText: "Decription",
                            hintText: "Type description..."
                        )
                    )
                  ],
                )
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel")
              ),
              TextButton(
                  onPressed: () {
                    _saveNote();
                    Navigator.pop(context);
                  },
                  child: Text("Save")
              )
            ],
          );
        });
  }
  _saveNote() async{
      String title = _titleController.text;
      String description = _descriptionController.text;

      Annotation annotation = Annotation(title, description, DateTime.now().toString());
      int result = await _db.saveNote(annotation);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My notes"),
        backgroundColor: Colors.lightGreen,
      ),
      body: Container(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: (){
          _showScreenAdd();
        },
      ),
    );
  }
}
