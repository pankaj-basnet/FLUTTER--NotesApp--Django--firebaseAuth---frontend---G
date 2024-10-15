import 'package:flutter/material.dart';
// import 'package:trekkingmap/services/cloud/cloud_note.dart';
import 'package:trekkingmap/services/crud/notes_service.dart';  // until ch-36--st-19
import 'package:trekkingmap/utilities/dialogs/delete_dialog.dart';


// typedef NoteCallback = void Function(DatabaseNote note); // pac--crud/notes_service.dart'  // until ch-36--st-19
typedef NoteCallback = void Function(DatabaseNote note); 

class NotesListView extends StatelessWidget {
  // final List<DatabaseNote> notes; // until ch-36--st-19
  final List<DatabaseNote> notes;
  final NoteCallback onDeleteNote;
  final NoteCallback onTap;


  // const NotesListView({super.key}); // dart-ext---> convert 'key' to a super parameter
  const NotesListView( 
   { Key? key, //  {sn= instructor doesnot prefer this because this is not useful code though "dart extension suggestion"}
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,}
  ) :super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length, itemBuilder: (context, index){
        final note = notes.elementAt(index);
        return ListTile(
          onTap: (){
            onTap(note);
          },
          title: Text(note.text,
          maxLines: 1,
          softWrap: true,
          overflow: TextOverflow.ellipsis,),
          trailing: IconButton(onPressed: ()async{
            final shouldDelete = await showDeleteDialog(context);
            if (shouldDelete){
              onDeleteNote(note);
            }
          }, icon: const Icon(Icons.delete)),
        );



    });
  }
}