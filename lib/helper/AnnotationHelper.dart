import 'package:daily_note_bt/model/Annotation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AnnotationHelper {

  static final String nameTable = "annotation";
  static final AnnotationHelper _annotationHelper = AnnotationHelper._internal();
  Database? _db;

  factory AnnotationHelper(){
    return _annotationHelper;
  }

  AnnotationHelper._internal(){
  }

  get db async{
    if( _db != null){
      return _db;
    }else{
      _db = await launcherDB();
      return _db;
    }
  }

  _onCreate(Database db, int version) async {
    String sql = "CREATE TABLE $nameTable ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT, "
        "title VARCHAR, "
        "description TEXT, "
        "date DATETIME)";
    await db.execute(sql);
  }

  launcherDB() async {
    final pathDatabase = await getDatabasesPath();
    final placeDatabase = join(pathDatabase, "db_my_notes.db");

    var db = await openDatabase(placeDatabase, version: 1, onCreate: _onCreate);
    return db;
  }

  Future<int> saveNote(Annotation annotation) async{

    var dataBase = await db;
    int result = await dataBase.insert(nameTable, annotation.toMap());
    return result;

  }

  recoverAnnotation() async{
    var dataBase = await db;
    String sql = "SELECT * FROM $nameTable ORDER BY date DESC ";
    List annotations = await dataBase.rawQuery( sql );
    return annotations;
  }

  Future<int> updateNote(Annotation annotation) async {

    var dataBase = await db;
    return await dataBase.update(
      nameTable,
      annotation.toMap(),
      where: "id = ?",
      whereArgs: [annotation.id]
    );
  }
}