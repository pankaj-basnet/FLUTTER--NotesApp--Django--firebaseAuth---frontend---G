import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:trekkingmap/extensions/list/filter.dart';
import 'package:trekkingmap/services/crud/crud_exceptions.dart';

// ============
import 'package:http/http.dart' as http;


// =======================================================

// https://pub.dev/documentation/sqflite/latest/ {rsn= database query examples verified}

// =======================================================
//  self - note

// notes_servie.dart ----- code written in this order below
// "INITIALIZE" section

// trekkingmap/services/crud/crud_exceptions.dart

//  --- class DatabaseUser {
//  --- class DatabaseNote {

// "DATABASE" section
// Database _getDatabaseOrThrow() {
//  --- Future<void>-------------------- close    () async {
//  --- Future<void>-------------------- _ensureDbIsOpen    () async {
//  --- Future<void>-------------------- open   () async {
//=================================
//  --- Stream<List<DatabaseNote>> ----- get allNotes =>
//  --- Future<void>-------------------- _cacheNotes    () async {
//  --- Future<Iterable<DatabaseNote>>-- getAllNotes    () async {
//=================================
//  --- Future<DatabaseUser>------------ getUser    ({required String email}) async {
//  --- Future<DatabaseUser>------------ createUser   ({required String email}) async {
//  --- Future<void>-------------------- deleteUser   ({required String email}) async {

////  --- Future<DatabaseUser>------------ getOrCreateUser    ({}
//=================================
//  --- Future<DatabaseNote>----------- getNote     ({required int id}) async{
//  --- Future<int>-------------------- deleteAllNotes      () async {
//  --- Future<void>------------------- deleteNote      ({required int id}) async {
//  --- Future<DatabaseNote>----------- createNote      ({required DatabaseUser owner}) async {

//  --- Future<DatabaseNote>----------- updateNote      ({
//  --- Future<DatabaseUser>----------- getOrCreateUser ({



// =======================================================

class NotesService {
  // ------------    "INITIALIZE" section     ------------
  // ------------    "INITIALIZE" section     ------------

  Database? _db;

  List<DatabaseNote> _notes = [];

  DatabaseUser? _user; // .... optional _user //  mb-con= sn=

  static final NotesService _shared = NotesService._sharedInstance();

  NotesService._sharedInstance() {
    // curly brace "{}" instead of colon ":" mb-con= {sn= normal function even if constructor }
    _notesStreamController = StreamController<List<DatabaseNote>>.broadcast(
      onListen: () {
        _notesStreamController.sink.add(_notes);
      },
    );
  }

  factory NotesService() => _shared; // .... singleton {sn=  code pattern}

  late final StreamController<List<DatabaseNote>> _notesStreamController;

// ########################################################

  Stream<List<DatabaseNote>> get allNotes =>
      _notesStreamController.stream.filter((note) {
        final currentUser = _user;
        if (currentUser != null) {
          return note.userId == currentUser.id;
        } else {
          throw UserShouldBeSetBeforeReadingAllNotes();
        }
      });

// ########################################################

//. -----    put getOrCreateUser({  before "getUser()" // "USER" section     -----
//. -----    put getOrCreateUser({  before "getUser()" // "USER" section     -----

  Future<DatabaseUser> getOrCreateUser({
    required String email,
    bool setAsCurrentUser = true,
  })async{
    try {
              final user = await getUser(email: email);
      if (setAsCurrentUser){
        _user = user;
      }
      return user;
    } on CouldNotFindUser{
      final createdUser = await createUser(email: email);
      if (setAsCurrentUser == true){
        _user = createdUser;
      }
      return createdUser;
    } catch (e){
      rethrow;
    }


  }

// ########################################################
// ########################################################
// ########################################################

//. ------------    "NOTES" section     ------------
//. ------------    "NOTES" section     ------------

  Future<void> _cacheNotes() async {
    final allNotes = await getAllNotes();
    _notes = allNotes.toList();
    _notesStreamController.add(_notes);
  }

  // ------------------------------------
  // ------------------------------------

  Future<DatabaseNote> updateNote({
    required DatabaseNote note,
    required String text,
  }) async {
    // await _ensureDbIsOpen();
    // final db = _getDatabaseOrThrow();

    // make sure note exists
    await getNote(id: note.id);

    // update DB
    var updatesCount = 0;
    Uri url = Uri.parse('http://192.168.1.71:8000/api/notes/${note.id}/update');
    
    final response = await http.post(url);

     if (response.statusCode == 200) {
        var notes = databaseNoteFromJson(response.body);
        var updatesCount = 1;
      }
      var imp = {
        textColumn: text,
        isSyncedWithCloudColumn: 0,
      };

    if (updatesCount == 0) {
      throw CouldNotFindNote();
    } else {
      final updatedNote = await getNote(id: note.id);
      _notes.removeWhere((note) => note.id == updatedNote.id); // sn= {prac= arrow function dart -- class oop} #@@
      _notes.add(updatedNote);
      _notesStreamController.add(_notes);
      return updatedNote;
     
    }
  }

  // ------------------------------------
  // ------------------------------------

  Future<Iterable<DatabaseNote>> getAllNotes() async {
    // await _ensureDbIsOpen();

    // final db = _getDatabaseOrThrow();
    final notes = await db.query(noteTable);

    return notes.map((noteRow) => DatabaseNote.fromRow(noteRow));
  }

  // ------------------------------------
  // ------------------------------------

  Future<DatabaseNote> getNote({required String id}) async {
    // await _ensureDbIsOpen();
    // final db = _getDatabaseOrThrow();

    Uri url = Uri.parse('http://192.168.1.71:8000/api/notes/$id/');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      var responseBody = response.body;

      //.
      print('---- notes service --- getNOte --- ----------------');
      print('----     ${responseBody} -------');
      print('---- notes service --- getNOte --- ----------------');
      //.

        var notes = databaseNoteFromJsonONE((responseBody));
        var updatesCount = 1;
      }

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

  Future<int> deleteAllNotes() async {
    // await _ensureDbIsOpen();
    // final db = _getDatabaseOrThrow();

    final numberOfDeletions = await db.delete(noteTable);
    _notes = [];

    _notesStreamController.add(_notes);

    return numberOfDeletions;
  }

  Future<void> deleteNote({required int id}) async {
    // await _ensureDbIsOpen();
    // final db = _getDatabaseOrThrow();

    final deletedCount = await db.delete(
      noteTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (deletedCount == 0) {
      throw CouldNotDeleteNote();
    } else {
      _notes.removeWhere((note) => note.id == id);
      _notesStreamController.add(_notes);
    }
  }

  Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
    // await _ensureDbIsOpen();
    // final db = _getDatabaseOrThrow();

    // make sure the "owner" is the "owner of the note in database" with correct ID sn=
    // checking equality of DatabaseUser , not "email" { mb= ID equal } {mb=}

    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner) {
      throw CouldNotFindUser();
    }

    const text = '';
    // create the note
    final noteId = await db.insert(noteTable, {
      userIdColumn: owner.id,
      textColumn: text,
      isSyncedWithCloudColumn: 1,
    });

    final note = DatabaseNote(
      id: noteId,
      userId: owner.id,
      text: text,
      isSyncedWithCloud: true,
    );

    _notes.add(note);
    _notesStreamController.add(_notes);

    return note;
  }

// ########################################################
// ########################################################
// ########################################################

// #########################################################################

//. ------------    "USER" section     ------------
//. ------------    "USER" section     ------------

  // Future<DatabaseUser> getUser({required String email}) async {
  //   // await _ensureDbIsOpen();
  //   // final db = _getDatabaseOrThrow();

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
  // }

  // Future<DatabaseUser> createUser({required String email}) async {
  //   // await _ensureDbIsOpen();
  //   // final db = _getDatabaseOrThrow();
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
  //   // await _ensureDbIsOpen();
  //   // final db = _getDatabaseOrThrow();
  //   final deletedCount = await db.delete(
  //     userTable,
  //     where: 'email = ?',
  //     whereArgs: [email.toLowerCase()],
  //   );
  //   if (deletedCount != 1) {
  //     throw CouldNotDeleteUser();
  //   }
  // }

// #########################################################################


// ########################################################
// ########################################################

//------------------------------ 241014 ----------------------

//. ------------    "DATABASE" section     ------------
//. ------------    "DATABASE" section     ------------

  // Database _getDatabaseOrThrow() {
  //   final db = _db;
  //   if (db == null) {
  //     throw DatabaseIsNotOpen(); // crud/crud_exceptions.dart
  //   } else {
  //     return db;
  //   }
  // }

  // Future<void> close() async {
  //   final db = _db;
  //   if (db == null) {
  //     throw DatabaseIsNotOpen();
  //   } else {
  //     await db.close();
  //     _db = null;
  //   }
  // }

  // Future<void> _ensureDbIsOpen() async {
  //   try {
  //     await open();
  //   } on DatabaseAlreadyOpenException {
  //     // empty
  //   }
  // }

  // Future<void> open() async {
  //   if (_db != null) {
  //     throw DatabaseAlreadyOpenException();
  //   }

  //   try {
  //     final docsPath =
  //         await getApplicationDocumentsDirectory(); // package:path_provider.dart
  //     final dbPath = join(docsPath.path, dbName); // package:path
  //     final db = await openDatabase(dbPath);
  //     _db = db;

  //     //create the user table
  //     await db.execute(createUserTable);

  //     //create note table
  //     await db.execute(createNoteTable);
  //     await _cacheNotes();
  //   } on MissingPlatformDirectoryException {
  //     throw UnableToGetDocumentsDirectory();
  //   }
  // }
//------------------------------ 241014 ----------------------//>>

// ########################################################
// ########################################################
}

// ########################################################
// ########################################################

// @immutable // class DatabaseUser --- services\crud\notes_service.dart // mb-con= sn=

@immutable // import material.dart ---> docs == package:meta/meta.dart
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
  String toString() => 'Person, ID = $id, Email = $email';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

//.

// one note
List<DatabaseNote> databaseNoteFromJsonONE(String str) => List<DatabaseNote>.from(json.decode(str).map((x) => DatabaseNote.fromRow(x)));

// *********** convert one database note to List<DatabaseNote> ---before using
String databaseNoteToJsonONE(List<DatabaseNote> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// list of notes
List<DatabaseNote> databaseNotesFromJson(String str) => List<DatabaseNote>.from(json.decode(str).map((x) => DatabaseNote.fromRow(x)));

String databaseNotesToJson(List<DatabaseNote> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


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
        isSyncedWithCloud =
            (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;

   Map<String, dynamic> toJson() => {
        idColumn: id,
        userIdColumn: userId,
        isSyncedWithCloudColumn: isSyncedWithCloud,
    };


  @override
  String toString() =>
      'Note, ID = $id, userID = $userId, isSyncedWithCloud = $isSyncedWithCloud, text = $text';

  @override // override "operator ==" and "hashCode"
  bool operator ==(covariant DatabaseNote other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

// ########################################################
// ########################################################
// ------------    "CONST" section     ------------
// ------------    "CONST" section     ------------

// const dbName = 'notes.db';

//------------------------------ 241014 ----
// const dbName = 'trekkingmap.db';
// const noteTable = 'note';
// const userTable = 'user';
const idColumn = 'id';
const emailColumn = 'email';
const userIdColumn = 'user_id';
const textColumn = 'text';
const isSyncedWithCloudColumn = 'is_synced_with_cloud';
// const createUserTable = '''CREATE TABLE IF NOT EXISTS "user" (
//         "id"	INTEGER NOT NULL,
//         "email"	TEXT NOT NULL UNIQUE,
//         PRIMARY KEY("id" AUTOINCREMENT)
//       );''';
// const createNoteTable = '''CREATE TABLE IF NOT EXISTS "note" (
//         "id"	INTEGER NOT NULL,
//         "user_id"	INTEGER NOT NULL,
//         "text"	TEXT,
//         "is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
//         FOREIGN KEY("user_id") REFERENCES "user"("id"),
//         PRIMARY KEY("id" AUTOINCREMENT)
//       );''';

//------------------------------ 241014 ----//>>