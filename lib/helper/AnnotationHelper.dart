import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AnnotationHelper {

  static final AnnotationHelper _annotationHelper = AnnotationHelper._internal();
  late Database _db;

  factory AnnotationHelper(){
    return _annotationHelper;
  }

  AnnotationHelper._internal(){
  }

  get db async{
    if( _db != null){
      return _db;
    }else{

    }
  }
  
  _onCreate(Database db, int version) async {
    String sql = "CREATE TABLE notes (id INTEGER PRIMARY KEY AUTOINCREMENT, title VARCHAR, description TEXT, date DATETIME)";
    await db.execute(sql);
  }

  launcherDB() async {
    final pathDatabase = await getDatabasesPath();
    final placeDatabase = join(pathDatabase, "db_my_notes.db");

    var db = await openDatabase(placeDatabase, version: 1, onCreate: _onCreate);
    return db;
  }

}