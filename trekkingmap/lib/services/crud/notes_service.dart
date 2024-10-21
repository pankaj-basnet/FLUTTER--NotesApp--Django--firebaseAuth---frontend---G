import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:trekkingmap/extensions/list/filter.dart';
import 'package:trekkingmap/services/crud/crud_exceptions.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;
import 'package:http/http.dart' as http;

class NotesService {
  Database? _db;

  List<DatabaseNote> _notes = [];

  DatabaseUser? _user;

  static final NotesService _shared = NotesService._sharedInstance();
  NotesService._sharedInstance() {
    _notesStreamController = StreamController<List<DatabaseNote>>.broadcast(
      onListen: () {
        _notesStreamController.sink.add(_notes);
      },
    );
  }
  factory NotesService() => _shared;

  late final StreamController<List<DatabaseNote>> _notesStreamController;

  Stream<List<DatabaseNote>> get allNotes =>
      _notesStreamController.stream.filter((note) {
        return true;
      });

  Future<void> getOrCreateUser({
    required String email,
    bool setAsCurrentUser = true,
  }) async {
    try {
      final user = await getUser();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _cacheNotes() async {
    final allNotes = await getAllNotes();
    _notes = allNotes.toList();
    _notesStreamController.add(_notes);
  }

  // ########################################################################

  Future<DatabaseNote> updateNote({
    required DatabaseNote note,
    required String text,
  }) async {
    final note = await getNoteEmptyNew();
    final noteId = note.id;
    final noteUserId = note.userId;

    var databaseNote = DatabaseNote(
        id: ' foobaro ',
        userId: ' foobaro ',
        text: ' foobaro ',
        isSyncedWithCloud: false);

    try {
      Uri url =
          Uri.parse('http://192.168.61.237:8000/api/notes/$noteId/update/');

      var data = jsonEncode({
        "user_id": noteUserId,
        "text": text,
        isSyncedWithCloudColumn: false
      });

      final response = await http.put(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: data);

      if (response.statusCode != 200) {}
    } catch (e) {}
    _notes.removeWhere((note) => note.id == noteId);

    final updatedNote = await getNoteEmptyNew();
    final noteId2 = note.id;

    _notes.add(updatedNote);

    _notesStreamController.add(_notes);
    return updatedNote;
    // }
  }

  // ########################################################################

  Future<Iterable<DatabaseNote>> getAllNotes() async {
    var databaseNote = [
      DatabaseNote(
          id: '99', userId: '99', text: 'text', isSyncedWithCloud: false),
      DatabaseNote(
          id: '99', userId: '99', text: 'text', isSyncedWithCloud: false)
    ];

    try {
      Uri url = Uri.parse('http://192.168.61.237:8000/api/notes/');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        var jsonDecoded = response.body;
        databaseNote = databaseNotesFromJson(jsonDecoded);
      }
    } catch (e) {}

    return databaseNote;
  }

  // ------------------------------------------------------

  Future<DatabaseNote> getNote({required String id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final notes = await db.query(
      noteTable,
      limit: 1,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (notes.isEmpty) {
      throw CouldNotFindNote();
    } else {
      final note = DatabaseNote.fromRow(notes.first);
      _notes.removeWhere((note) => note.id == id);
      _notes.add(note);
      _notesStreamController.add(_notes);
      return note;
    }
  }

  // --------------------------------

  Future<DatabaseNote> getNoteEmptyNew() async {
    var databaseNote = [
      DatabaseNote(
          id: ' foobazo ',
          userId: ' foobazo ',
          text: ' foobazo ',
          isSyncedWithCloud: false),
      DatabaseNote(
          id: ' foobazo ',
          userId: ' foobazo ',
          text: ' foobazo ',
          isSyncedWithCloud: false),
    ];

    try {
      Uri url = Uri.parse('http://192.168.61.237:8000/api/notes/');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        var jsonDecoded = response.body;
        databaseNote = databaseNotesFromJson(jsonDecoded);
      }
    } catch (e) {}

    final firstNote = databaseNote.last;

    return firstNote;
  }

  // -----------------------------------------------------------

  Future<int> deleteAllNotes() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final numberOfDeletions = await db.delete(noteTable);
    _notes = [];
    _notesStreamController.add(_notes);
    return numberOfDeletions;
  }

  Future<void> deleteNote({required String id}) async {
    try {
      Uri url = Uri.parse('http://192.168.61.237:8000/api/notes/$id/delete/');

      final response = await http.delete(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 204) {
        var jsonDecoded = response.body;
      }

      _notes.removeWhere((note) => note.id == id);
      _notesStreamController.add(_notes);
    } catch (e) {}
  }

// #########################################################################

  var mynote = 100;

  Future<DatabaseNote> createNote() async {
    var text = 'New note $mynote';

    var note = DatabaseNote(
        id: ' foobazoo ',
        userId: ' foobazoo ',
        text: text,
        isSyncedWithCloud: false);

    var data = jsonEncode({
      "user_id": "ac3672ae-c01c-4cb0-a588-8720b2a39b38",
      "text": text,
      isSyncedWithCloudColumn: false
    });

    try {
      Uri url = Uri.parse('http://192.168.61.237:8000/api/notes/');

      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: data);

      mynote += 1;
    } catch (e) {}

    return note;
  }

  // $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
  // $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
  // $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

  // Future<DatabaseUser> getUser({required String email}) async {
  Future<void> getUser() async {
    await _ensureDbIsOpen();
    //   final db = _getDatabaseOrThrow();

    //   final results = await db.query(
    //     userTable,
    //     limit: 1,
    //     where: 'email = ?',
    //     whereArgs: [email.toLowerCase()],
    //   );

    //   if (results.isEmpty) {
    //     throw CouldNotFindUser();
    //   } else {
    //     return DatabaseUser.fromRow(results.first);
    //   }
  }

  // Future<DatabaseUser> createUser({required String email}) async {
  //   await _ensureDbIsOpen();
  //   final db = _getDatabaseOrThrow();
  //   final results = await db.query(
  //     userTable,
  //     limit: 1,
  //     where: 'email = ?',
  //     whereArgs: [email.toLowerCase()],
  //   );
  //   if (results.isNotEmpty) {
  //     throw UserAlreadyExists();
  //   }

  //   final userId = await db.insert(userTable, {
  //     emailColumn: email.toLowerCase(),
  //   });

  //   return DatabaseUser(
  //     id: userId,
  //     email: email,
  //   );
  // }

  // Future<void> deleteUser({required String email}) async {
  //   await _ensureDbIsOpen();
  //   final db = _getDatabaseOrThrow();
  //   final deletedCount = await db.delete(
  //     userTable,
  //     where: 'email = ?',
  //     whereArgs: [email.toLowerCase()],
  //   );
  //   if (deletedCount != 1) {
  //     throw CouldNotDeleteUser();
  //   }
  // }

  // $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
  // $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
  // $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      return db;
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      await db.close();
      _db = null;
    }
  }

  Future<void> _ensureDbIsOpen() async {
    try {
      await open();
    } on DatabaseAlreadyOpenException {
      // empty
    }
  }

  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;
      // create the user table
      await db.execute(createUserTable);
      // create note table
      await db.execute(createNoteTable);
      await _cacheNotes();
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    }
  }
}

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

@immutable
class DatabaseUser {
  final int id;
  final String email;
  const DatabaseUser({
    required this.id,
    required this.email,
  });

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;

  @override
  String toString() => 'Person, ID = $id, email = $email';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

//.

// ####################################################################
// ####################################################################
// ####################################################################
// ####################################################################

List<DatabaseNote> databaseNoteFromJsonONE(String str) =>
    List<DatabaseNote>.from(
        json.decode(str).map((x) => DatabaseNote.fromRow(x)));

String databaseNoteToJsonONE(List<DatabaseNote> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

List<DatabaseNote> databaseNotesFromJson(String str) {
  var jsonToNotes = json.decode(str);

  var ListDatabase =
      List<DatabaseNote>.from(jsonToNotes.map((x) => DatabaseNote.fromRow(x)));

  return ListDatabase;
}

String databaseNotesToJson(List<DatabaseNote> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DatabaseNote {
  final String id;
  final String userId;
  final String text;
  final bool isSyncedWithCloud;

  DatabaseNote({
    required this.id,
    required this.userId,
    required this.text,
    required this.isSyncedWithCloud,
  });

  DatabaseNote.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as String,
        userId = map[userIdColumn] as String,
        text = map[textColumn] as String,
        isSyncedWithCloud = map[isSyncedWithCloudColumn] as bool;

  Map<String, dynamic> toJson() => {
        idColumn: id,
        userIdColumn: userId,
        isSyncedWithCloudColumn: isSyncedWithCloud,
      };

  @override
  String toString() => 'Note  text = $text';

  @override // override "operator ==" and "hashCode"
  bool operator ==(covariant DatabaseNote other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

// ####################################################################
// ####################################################################

const dbName = 'notes.db';
const noteTable = 'note';
const userTable = 'user';
const idColumn = 'id';
const emailColumn = 'email';
const userIdColumn = 'user_id';
const textColumn = 'text';
const isSyncedWithCloudColumn = 'is_synced_with_cloud';
const createUserTable = '''CREATE TABLE IF NOT EXISTS "user" (
        "id"	INTEGER NOT NULL,
        "email"	TEXT NOT NULL UNIQUE,
        PRIMARY KEY("id" AUTOINCREMENT)
      );''';
const createNoteTable = '''CREATE TABLE IF NOT EXISTS "note" (
        "id"	INTEGER NOT NULL,
        "user_id"	INTEGER NOT NULL,
        "text"	TEXT,
        "is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY("user_id") REFERENCES "user"("id"),
        PRIMARY KEY("id" AUTOINCREMENT)
      );''';
