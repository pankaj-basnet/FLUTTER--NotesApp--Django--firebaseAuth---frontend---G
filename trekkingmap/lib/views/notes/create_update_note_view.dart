import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:share_plus/share_plus.dart';
import 'package:trekkingmap/services/auth/auth_service.dart';
// import 'package:trekkingmap/services/cloud/cloud_note.dart';
// import 'package:trekkingmap/services/cloud/firebase_cloud_storage.dart';
import 'package:trekkingmap/utilities/dialogs/cannot_share_empty_note_dialog.dart';
import 'package:trekkingmap/services/crud/notes_service.dart'; // until ch-36--st-19
import 'package:trekkingmap/utilities/generics/get_argument.dart'; // class DatabaseNote

class CreateUpdateNoteView extends StatefulWidget {
  //sn= //  {{dart extension suggestion ---> Convert 'key' to a super parameter. sn=}}

  const CreateUpdateNoteView({Key? key}) : super(key: key); //  isn=

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  // DatabaseNote? _note;
  DatabaseNote? _note;
  late final NotesService _notesService;
  late final TextEditingController _textController;

  @override
  void initState() {
    _notesService = NotesService();
    _textController = TextEditingController();
    super.initState();
  }

  void _textControllerListner() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    // await _notesService.updateNote(
    //   note: note,
    //   text: text,
    // );
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListner);
    _textController.addListener(_textControllerListner);
  }

// #######################################################
// #######################################################

  // Future<DatabaseNote> createOrGetExistingNote(BuildContext context) async {
  Future<void> createOrGetExistingNote(BuildContext context) async {
    final widgetNote = context.getArgument<DatabaseNote>();

    // updating note (not creating note sn=)
    if (widgetNote != null) {
      _note = widgetNote;
      _textController.text = widgetNote.text;
      // return widgetNote;
    }

    // mb- { wrong code or incorrect or mistake by isn= vanda}
    // mb- {if creating new note, following four lines of code do not get executed sn=}
    final existingNote = _note;
    if (existingNote != null) {
      // return existingNote;
    }

    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;

    final email = currentUser.email; // until ch-36--st-19

    // final owner = AuthService.firebase().currentUser!; // mod=  // until ch-36--st-19
    // final newNote = await _notesService.createNewNote(ownerUserId: userId);

  // //-------------------------------------
  // //-------------------------------------
  //     // final owner = await _notesService.getUser(email: email);  // until ch-36--st-19
  //     final newNote = await _notesService.createNote(owner: owner); // until ch-36--st-19
  // //-------------------------------------
  // //-------------------------------------
  //     _note = newNote;
  //     return newNote;
  // //-------------------------------------
  // //-------------------------------------

  print('createOrGetExistingNote');
  _notesService.createNote();
  print('createOrGetExistingNote---done--------------------------------');


  }

// #######################################################
// #######################################################

  // void _deleteNoteIfTextIsEmpty() {
  //   // {isn didnot explain in detail sn=}
  //   final note = _note;
  //   if (_textController.text.isEmpty && _note != null) {

  //     // _notesService.deleteNote(documentId: note!.documentId);

  //     //---------------------------------- // until ch-36--st-19
  //     // _notesService.deleteNote(id: note.id); // error // no error in isn {sn=}
  //     _notesService.deleteNote(
  //         id: note!
  //             .id); // sn= "!" this solves the error // ""The property 'id' can't be unconditionally accessed because the receiver can be 'null' ---""
  //     //---------------------------------- // until ch-36--st-19
  //   }
  // }

  void _saveNoteIfTextNotEmpty() async {
    // no "async" in _deleteNoteIfTextIsEmpty sn=
    // final note = _note;
    // final text = _textController.text;
    // if (text.isNotEmpty && note != null) {
    //   // await _notesService.updateNote(documentId: note.documentId, text: text,);
    //   await _notesService.updateNote(
    //     note: note,
    //     text: text,
    //   );

      print('createOrGetExistingNote');
  _notesService.createNote();
  print('createOrGetExistingNote---done--------------------------------');



    }
  

// #######################################################
// #######################################################

  @override
  void dispose() {
    // -------------------------------------
    // -------------------------------------
    // _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    // -------------------------------------
    // -------------------------------------
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Note'),
        // actions: [
        //   IconButton(onPressed: () async {
        //     final text = _textController.text;
        //     if (_note == null || text.isEmpty){
        //       await showCannotShareEmptyNoteDialog(context);

        //     }else{
        //       Share.share(text);
        //     }
        //   }, icon: const Icon(Icons.share))
        // ],
      ),

      // ####################################
      // ####################################

      body: TextField(
                controller: _textController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Start typing your notes...',
                ),
              ),


      // ####################################
      // ####################################
      // body: FutureBuilder(
      //   future: createOrGetExistingNote(context),
      //   builder: (context, snapshot) {
      //     switch (snapshot.connectionState) {
      //       case ConnectionState.done:
      //         _setupTextControllerListener();
      //         return TextField(
      //           controller: _textController,
      //           keyboardType: TextInputType.multiline,
      //           maxLines: null,
      //           decoration: const InputDecoration(
      //             hintText: 'Start typing your notes...',
      //           ),
      //         );
      //       default:
      //         return const CircularProgressIndicator();
      //     }
      //   },
      // ),
    );
  }
}

// // #########################################################
// // #########################################################
// // #########################################################
// // #########################################################

// ###########################################################
// ###########################################################
// ###########################################################
// ###########################################################
// ###########################################################
// ###########################################################

// ###########################################################
// ###########################################################
// ###########################################################
// ###########################################################
// ###########################################################
// ###########################################################

// // #########################################################
// // #########################################################
// // #########################################################
// // #########################################################

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// // import 'package:share_plus/share_plus.dart';
// import 'package:trekkingmap/services/auth/auth_service.dart';
// // import 'package:trekkingmap/services/cloud/cloud_note.dart';
// // import 'package:trekkingmap/services/cloud/firebase_cloud_storage.dart';
// import 'package:trekkingmap/utilities/dialogs/cannot_share_empty_note_dialog.dart';
// import 'package:trekkingmap/services/crud/notes_service.dart';  // until ch-36--st-19
// import 'package:trekkingmap/utilities/generics/get_argument.dart'; // class DatabaseNote

// class CreateUpdateNoteView extends StatefulWidget {
//   //sn= //  {{dart extension suggestion ---> Convert 'key' to a super parameter. sn=}}

//   const CreateUpdateNoteView({Key? key}) : super(key: key); //  isn=

//   @override
//   State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
// }

// class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
//   // DatabaseNote? _note;
//   DatabaseNote? _note;
//   late final NotesService _notesService;
//   late final TextEditingController _textController;

//   @override
//   void initState() {
//     _notesService = NotesService();
//     _textController = TextEditingController();
//     super.initState();
//   }

//   void _textControllerListner() async {
//     final note = _note;
//     if (note == null) {
//       return;
//     }
//     final text = _textController.text;
//     // await _notesService.updateNote(
//     //   note: note,
//     //   text: text,
//     // );
//   }

//   void _setupTextControllerListener() {
//     _textController.removeListener(_textControllerListner);
//     _textController.addListener(_textControllerListner);
//   }

// // #######################################################
// // #######################################################

// //   Future<DatabaseNote> createOrGetExistingNote(BuildContext context) async {
// //     final widgetNote = context.getArgument<DatabaseNote>();

// //     // updating note (not creating note sn=)
// //     if (widgetNote != null) {
// //       _note = widgetNote;
// //       _textController.text = widgetNote.text;
// //       return widgetNote;
// //     }

// //     // mb- { wrong code or incorrect or mistake by isn= vanda}
// //     // mb- {if creating new note, following four lines of code do not get executed sn=}
// //     final existingNote = _note;
// //     if (existingNote != null) {
// //       return existingNote;
// //     }

// //     final currentUser = AuthService.firebase().currentUser!;
// //     final userId = currentUser.id;

// //     final email = currentUser.email;  // until ch-36--st-19

// //     // final owner = AuthService.firebase().currentUser!; // mod=  // until ch-36--st-19
// //     // final newNote = await _notesService.createNewNote(ownerUserId: userId);

// // //-------------------------------------
// // //-------------------------------------
// //     final owner = await _notesService.getUser(email: email);  // until ch-36--st-19
// //     final newNote = await _notesService.createNote(owner: owner); // until ch-36--st-19
// // //-------------------------------------
// // //-------------------------------------
// //     _note = newNote;
// //     return newNote;
// //   }

// // #######################################################
// // #######################################################

//   // void _deleteNoteIfTextIsEmpty() {
//   //   // {isn didnot explain in detail sn=}
//   //   final note = _note;
//   //   if (_textController.text.isEmpty && _note != null) {

//   //     // _notesService.deleteNote(documentId: note!.documentId);

//   //     //---------------------------------- // until ch-36--st-19
//   //     // _notesService.deleteNote(id: note.id); // error // no error in isn {sn=}
//   //     _notesService.deleteNote(
//   //         id: note!
//   //             .id); // sn= "!" this solves the error // ""The property 'id' can't be unconditionally accessed because the receiver can be 'null' ---""
//   //     //---------------------------------- // until ch-36--st-19
//   //   }
//   // }

//   // void _saveNoteIfTextNotEmpty() async {
//   //   // no "async" in _deleteNoteIfTextIsEmpty sn=
//   //   final note = _note;
//   //   final text = _textController.text;
//   //   if (text.isNotEmpty && note != null) {
//   //     // await _notesService.updateNote(documentId: note.documentId, text: text,);
//   //     await _notesService.updateNote(
//   //       note: note,
//   //       text: text,
//   //     );

//   //   }
//   // }

// // #######################################################
// // #######################################################

//   @override
//   void dispose() {
//     // -------------------------------------
//     // -------------------------------------
//     // _deleteNoteIfTextIsEmpty();
//     // _saveNoteIfTextNotEmpty();
//     // -------------------------------------
//     // -------------------------------------
//     _textController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('New Note'),
//         // actions: [
//         //   IconButton(onPressed: () async {
//         //     final text = _textController.text;
//         //     if (_note == null || text.isEmpty){
//         //       await showCannotShareEmptyNoteDialog(context);

//         //     }else{
//         //       Share.share(text);
//         //     }
//         //   }, icon: const Icon(Icons.share))
//         // ],
//       ),

//       // ####################################
//       // ####################################
//       // body: FutureBuilder(
//       //   future: createOrGetExistingNote(context),
//       //   builder: (context, snapshot) {
//       //     switch (snapshot.connectionState) {
//       //       case ConnectionState.done:
//       //         _setupTextControllerListener();
//       //         return TextField(
//       //           controller: _textController,
//       //           keyboardType: TextInputType.multiline,
//       //           maxLines: null,
//       //           decoration: const InputDecoration(
//       //             hintText: 'Start typing your notes...',
//       //           ),
//       //         );
//       //       default:
//       //         return const CircularProgressIndicator();
//       //     }
//       //   },
//       // ),
//     );
//   }
// }

// // #########################################################
// // #########################################################
// // #########################################################
// // #########################################################

// ###########################################################
// ###########################################################
// ###########################################################
// ###########################################################
// ###########################################################
// ###########################################################
