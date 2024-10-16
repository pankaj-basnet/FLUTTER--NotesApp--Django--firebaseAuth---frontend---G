import 'package:flutter/material.dart';
import 'package:trekkingmap/views/notes/notes_view.dart';

class FetchNotes {
  final List<DatabaseNote> databaseNote;
  final bool isLoading;
  final String? error;
  final VoidCallback refetch;

  FetchNotes({
    required this.databaseNote,
    required this.isLoading,
    required this.error,
    required this.refetch,
  });
}
