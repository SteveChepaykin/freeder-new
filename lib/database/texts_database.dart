import 'package:sqflite/sqflite.dart';
import 'package:freeder_new/models/saved_text_model.dart';

class TextsDatabase {
  static final TextsDatabase instance = TextsDatabase._init();

  static Database? _database;

  TextsDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('texts2.db');
    return _database!;
  }

  Future<Database> _initDB(String filepath) async {
    final dbpath = await getDatabasesPath();
    final path = dbpath + filepath;
    return await openDatabase(path, version: 1, onCreate: createDB);
  }

  Future<void> createDB(Database db, int version) async {
    const idtype = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const integertype = 'INTEGER NOT NULL';
    const texttype = 'TEXT NOT NULL';

    await db.execute('''CREATE TABLE $tableTexts (
        ${SavedTextFields.id} $idtype,
        ${SavedTextFields.title} $texttype,
        ${SavedTextFields.wholetext} $texttype,
        ${SavedTextFields.lastindex} $integertype,
        ${SavedTextFields.timecreated} $texttype
      )''');
  }

  Future<SavedText> create(SavedText st) async {
    final db = await instance.database;
    final id = await db.insert(tableTexts, st.toJson());
    return st.copy(id: id);
  }

  Future<SavedText?> readText(int id) async {
    final db = await instance.database;
    final maps = await db.query(tableTexts, columns: SavedTextFields.values, where: '${SavedTextFields.id} = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return SavedText.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<int> update(SavedText st) async {
    final db = await instance.database;
    return db.update(
      tableTexts,
      st.toJson(),
      where: '${SavedTextFields.id} = ?',
      whereArgs: [st.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableTexts,
      where: '${SavedTextFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<List<SavedText>> readAllSavedTexts() async {
    final db = await instance.database;
    const orderBy = '${SavedTextFields.timecreated} DESC';
    final result = await db.query(tableTexts, orderBy: orderBy);
    return result.map((e) => SavedText.fromJson(e)).toList();
  }

  Future<void> closeDB() async {
    final db = await instance.database;
    db.close();
  }
}
