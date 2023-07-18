import 'package:notes/models/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NotesDatabase {
  static final NotesDatabase instance = NotesDatabase._init();
  NotesDatabase._init();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filepath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filepath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final String textType = 'TEXT NOT NULL';
    await db.execute('''CREATE TABLE $tableNotes(
        ${NotesField.id} $idType,
        ${NotesField.title} $textType,
        ${NotesField.description} $textType,
        ${NotesField.createdTime} $textType)''');
  }

  Future<Note> create(Note note) async {
    final db = await instance.database;
    final id = await db.insert(tableNotes, note.toJson());
    return note.copy(id: id);
  }

  Future<Note> readNote(int id) async {
    final db = await instance.database;
    final maps = await db.query(tableNotes,
        columns: NotesField.values,
        where: '${NotesField.id} = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    }else{
      throw Exception('ID $id not found');
    }
  }

  Future<List<Note>> readAll() async{
    final db = await instance.database;
    final orderBy = '${NotesField.createdTime} DESC'; // Add the ORDER BY clause
    final result = await db.query(tableNotes, orderBy: orderBy);
    return result.map((json) => Note.fromJson(json)).toList();
  }

  Future<int> update(Note note) async{
    final db = await instance.database;
    return db.update(tableNotes, note.toJson(), where: '${NotesField.id} = ?', whereArgs: [note.id]);

  }

  Future<int> delete(int id) async{
    final db = await instance.database;
    return await db.delete(tableNotes, where: '${NotesField.id} = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
