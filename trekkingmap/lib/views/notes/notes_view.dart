// import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trekkingmap/constants/routes.dart';
import 'package:trekkingmap/main.dart';
import 'package:trekkingmap/services/auth/auth_service.dart';
// import 'package:trekkingmap/services/cloud/cloud_note.dart';
// import 'package:trekkingmap/services/cloud/firebase_cloud_storage.dart';
import 'package:trekkingmap/services/crud/notes_service.dart'; // {sn=}
import 'package:trekkingmap/views/notes/notes_list.dart';
import 'package:trekkingmap/views/notes/notes_list_view.dart';

// #########################################
// #########################################
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:trekkingmap/extensions/list/filter.dart';
import 'package:trekkingmap/services/crud/crud_exceptions.dart';

// #########################################

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:trekkingmap/views/notes/fetch_notes_list.dart';
import 'package:trekkingmap/views/notes/note_notifier.dart';
import 'package:trekkingmap/views/notes/notes_view.dart';

// #########################################


// #########################################

class NotesView extends StatefulWidget {
  // const NotesView({super.key});
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final NotesService _notesService;
  String get userEmail => AuthService.firebase().currentUser!.email;


  @override
  void initState() {
    // _notesService = NotesService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

  
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Notes'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
              },
              icon: const Icon(Icons.add),
            ),
            PopupMenuButton<MenuAction>(
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logout:
                    final shouldLogout = await showLogOutDialog(context);
                    if (shouldLogout) {
                      await AuthService.firebase().logOut();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        loginRoute,
                        (_) => false,
                      );
                    }
                }
              },
              itemBuilder: (context) {
                return const [
                  PopupMenuItem<MenuAction>(
                    value: MenuAction.logout,
                    child: Text('Log out'),
                  ),
                ];
              },
            )
          ],
        ),

        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 4),
                  children:   [
                    Center(child: Text('getting your notes from django server...')),
                    Center(child: Text('-----------------------------------------')),
                    NotesList(),
                  ]     ),

        );
  }
}



List<DatabaseNote> databaseNoteFromJsonONE(String str) => List<DatabaseNote>.from(json.decode(str).map((x) => DatabaseNote.fromRow(x)));

// *********** convert one database note to List<DatabaseNote> ---before using
String databaseNoteToJsonONE(List<DatabaseNote> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// list of notes
List<DatabaseNote> databaseNotesFromJson(String str) 
{
             
              var jsonToNotes = json.decode(str);
              print(' ********* $jsonToNotes ************** ');

              var ListDatabase = List<DatabaseNote>.from(jsonToNotes.map((x) => DatabaseNote.fromRow(x)));
              print(' **  $ListDatabase  ** ');

return ListDatabase;
} 

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
            map[isSyncedWithCloudColumn] as bool;

   Map<String, dynamic> toJson() => {
        idColumn: id,
        userIdColumn: userId,
        isSyncedWithCloudColumn: isSyncedWithCloud,
    };


  @override
  String toString() =>
      'Note  text = $text';

  @override // override "operator ==" and "hashCode"
  bool operator ==(covariant DatabaseNote other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const idColumn = 'id';
const emailColumn = 'email';
const userIdColumn = 'user_id';
const textColumn = 'text';
const isSyncedWithCloudColumn = 'is_synced_with_cloud';



// ###############################################################
// ###############################################################

// class ExtraNote extends StatefulWidget {
//   const ExtraNote({super.key});

//   @override
//   State<ExtraNote> createState() => _ExtraNoteState();
// }


// // class Helper extends StatefulWidget {
// //   const Helper({super.key});

// //   @override
// //   State<Helper> createState() => _HelperState();
// // }

// // class _HelperState extends State<Helper> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return const Placeholder();
// //   }
// // }

// class _ExtraNoteState extends State<ExtraNote> {


//   // List<DatabaseNote> helper () async {
//   //    Uri url = Uri.parse('http://192.168.1.71:8000/api/notes/bcef1af4-23c2-49f8-a78e-6e390cf4fb1a');

//   //     final response = await http.get(url);

//   //     final listDatabaseNote = databaseNoteFromJsonONE(response.body);



//   //     return listDatabaseNote;
//       // return response;

//       // return Future(DatabaseNote(id: '9', userId: '9', text: '9', isSyncedWithCloud: true))?? Future.value(9); trying to return Future<DatabaseNote> 
//   }
//   @override
//   Widget build(BuildContext context) {

//     var extra = 1;
//     return helper();
//   }
// }

// ###############################################################
// ###############################################################

// class NotesList extends HookWidget {
//   const NotesList({super.key});

//   @override
//   Widget build(BuildContext context) {

//     print(' ********************* notes_list.dart build func ********************* ');
//     final results = fetchNotes();
//     final databaseNote = results.databaseNote;
//     print(' ********************* ${databaseNote} *************** notes_list.dart build func ****** ');
//     final isLoading = results.isLoading;
//     final error = results.error;
    
//     if (isLoading) {
//       return const Text('is loading... please wait');
//     }

//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 3),
//       child: SizedBox(
//         height: 80,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: List.generate(databaseNote.length, (i) {
//             final note = databaseNote[i];
//             return GestureDetector(
//               onTap: () {
//                 context
//                     .read<NoteNotifier>()
//                     .setNote(note.text, note.id);
//                 // context.push('/ooooooooooo');
//               },
//               child: SizedBox(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     Padding(
//                         padding: EdgeInsets.all(4),
//                         child: Text(note.text)
//                       ),
//                     // Text(note.userId),
//                     SizedBox(height: 20,),

//                   ],
//                 ),
//               ),
//             );
//           }),
//          //====================================================

//         ),
//       ),
//     );
//   }
// }
