
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:trekkingmap/views/notes/fetch_notes_list.dart';
import 'package:trekkingmap/views/notes/note_notifier.dart';
import 'package:trekkingmap/views/notes/notes_view.dart';

class NotesList extends HookWidget {
  const NotesList({super.key});

  @override
  Widget build(BuildContext context) {

    print(' ********************* notes_list.dart build func ********************* ');
    final results = fetchNotes();
    final databaseNote = results.databaseNote;
    print(' ********************* ${databaseNote} *************** notes_list.dart build func ****** ');
    final isLoading = results.isLoading;
    final error = results.error;
    
    if (isLoading) {
      return const Text('is loading... please wait');
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3),
      child: SizedBox(
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(databaseNote.length, (i) {
            final note = databaseNote[i];
            return GestureDetector(
              onTap: () {
                context
                    .read<NoteNotifier>()
                    .setNote(note.text, note.id);
                // context.push('/ooooooooooo');
              },
              child: SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                        padding: EdgeInsets.all(4),
                        child: Text(note.text)
                      ),
                    // Text(note.userId),
                    SizedBox(height: 20,),

                  ],
                ),
              ),
            );
          }),
         //====================================================

        ),
      ),
    );
  }
}
