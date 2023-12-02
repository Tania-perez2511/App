import 'package:path/path.dart';
import 'package:planets/models/sistem.dart';
import 'package:sqflite/sqflite.dart';
import 'package:planets/models/cuerpo_celeste.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    return await openDatabase(
      join(dbPath, 'registro_cuerpos_celestes.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE cuerpos_celestes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT,
            foto TEXT,
            descripcion TEXT,
            tipo TEXT,
            naturaleza TEXT,
            tamano REAL,
            distancia REAL,
            sistemaId INTEGER
          );
        ''');
        await db.execute('''
          CREATE TABLE sistemas(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT,
            foto TEXT,
            descripcion TEXT,
            tamano REAL,
            distancia REAL
          );
        ''');
      },
      version: 1,
    );
  }

  // Método para insertar un CuerpoCeleste
  Future<int> insertCuerpoCeleste(CuerpoCeleste cuerpoCeleste) async {
    Database db = await database;
    return await db.insert('cuerpos_celestes', cuerpoCeleste.toMap());
  }

  // Método para insertar un Sistema
  Future<int> insertSistema(Sistema sistema) async {
    Database db = await database;
    return await db.insert('sistemas', sistema.toMap());
  }

  // Método para obtener todos los cuerpos celestes
  Future<List<CuerpoCeleste>> getCuerposCelestes() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('cuerpos_celestes');
    return List.generate(maps.length, (i) {
      return CuerpoCeleste.fromMap(maps[i]);
    });
  }

// Método para obtener todos los sistemas
  Future<List<Sistema>> getSistemas() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('sistemas');
    return List.generate(maps.length, (i) {
      return Sistema.fromMap(maps[i]);
    });
  }

  Future<Sistema> getSistemaPorId(int id) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'sistemas',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Sistema.fromMap(maps.first);
    } else {
      throw Exception('Sistema no encontrado');
    }
  }

  // Aquí puedes añadir más métodos según necesites
}
