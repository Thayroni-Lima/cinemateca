import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/filme.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    String path = join(await getDatabasesPath(), 'cinemateca.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE filmes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        imagemUrl TEXT,
        titulo TEXT,
        genero TEXT,
        faixaEtaria TEXT,
        duracao INTEGER,
        pontuacao REAL,
        descricao TEXT,
        ano INTEGER
      )
    ''');
  }

  Future<int> inserirFilme(Filme filme) async {
    final banco = await db;
    return await banco.insert('filmes', filme.toMap());
  }

  Future<List<Filme>> listarFilmes() async {
    final banco = await db;
    final List<Map<String, dynamic>> maps = await banco.query('filmes');
    return List.generate(maps.length, (i) => Filme.fromMap(maps[i]));
  }

  Future<int> atualizarFilme(Filme filme) async {
    final banco = await db;
    return await banco.update(
      'filmes',
      filme.toMap(),
      where: 'id = ?',
      whereArgs: [filme.id],
    );
  }

  Future<int> deletarFilme(int id) async {
    final banco = await db;
    return await banco.delete(
      'filmes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
