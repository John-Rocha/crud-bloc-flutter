import 'package:crud_flutter_bloc/models/note.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseProvider {
  static final DatabaseProvider instance = DatabaseProvider._init();
  static Database? _db;

  DatabaseProvider._init();

  // retorna instancia do banco de dados
  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }

    _db = await _useDatabe('notes.db');
    return _db!;
  }

  // cria o banco de dados
  Future<Database> _useDatabe(String dbName) async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, dbName);

    // descomente para deletar o banco de dados
    // await deleteDatabase(path);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE notes(id INTEGER PRIMARY KEY, title TEXT, content TEXT)');
      },
    );
  }

  // buscar notas
  Future<List<Note>> getNotes() async {
    final db = await instance.db;
    final result = await db.rawQuery('select * from notes order by id');
    debugPrint(result.toString());

    return result.map((json) => Note.fromJson(json)).toList();
  }

  // salvar nota
  Future<Note> saveNote(Note note) async {
    final db = await instance.db;
    final id = await db.rawInsert(
        'insert into notes (title, content) values (?, ?)',
        [note.title, note.content]);
    return note.copy(id: id);
  }

  // atualizar nota
  Future<Note> updateNote(Note note) async {
    final db = await instance.db;
    await db.rawUpdate('update notes set title = ?, content = ? where id = ?',
        [note.title, note.content, note.id]);
    return note;
  }

  // deletar nota
  Future<int> deleteNote(int id) async {
    final db = await instance.db;
    return await db.rawDelete('delete from notes where id = ?', [id]);
  }

  // deletar todas as notas
  Future<int> deleteAllNotes() async {
    final db = await instance.db;
    return await db.rawDelete('delete from notes');
  }

  // fechar banco de dados
  Future close() async {
    final db = await instance.db;
    return db.close();
  }
}
