import 'package:daily_note_bt/helper/AnnotationHelper.dart';
import 'package:daily_note_bt/model/Annotation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  var _db = AnnotationHelper();
  List<Annotation> _annotations = <Annotation>[];

  _showScreenAdd(){
    showDialog(
        context: context,
        builder: (context){
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

  _recoverAnnotation() async{
    List annotationsRecovery = await _db.recoverAnnotation();

    List<Annotation>? listTemp = <Annotation>[];
    for (var item in annotationsRecovery){
      Annotation annotation = Annotation.fromMap(item);
      listTemp.add(annotation);
    }
    setState(() {
      _annotations = listTemp!;
    });
    listTemp = null;

  }

  _saveNote() async{
    String title = _titleController.text;
    String description = _descriptionController.text;

    Annotation annotation = Annotation(title, description, DateTime.now().toString());
    int result = await _db.saveNote(annotation);
    print("salvar anotação: "+ result.toString());

    _titleController.clear();
    _descriptionController.clear();

    _recoverAnnotation();

  }

  _formatDate(String date){

    initializeDateFormatting("pt_BR");

    var formatter = DateFormat("d/M/y - H:m:s");

    DateTime dateConverter = DateTime.parse(date);
    String dateFormated = formatter.format(dateConverter);

    return dateFormated;

  }

  @override
  void initState() {
    super.initState();
    _recoverAnnotation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My notes"),
        backgroundColor: Colors.lightGreen,
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: _annotations.length,
                  itemBuilder: (context, index){
                    final annotation = _annotations[index];
                    return Card(
                      child: ListTile(
                        title: Text(annotation.title!),
                        subtitle: Text("${_formatDate(annotation.date!)} - ${annotation.description}"),
                      ),
                    );
                  }
              )
          )
        ],
      ),
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
