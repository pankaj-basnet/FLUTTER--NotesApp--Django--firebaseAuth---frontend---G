// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:trekkingmap/views/notes/notes_results.dart';
import 'package:trekkingmap/views/notes/notes_view.dart';
import 'package:http/http.dart' as http;

FetchNotes fetchNotes() {
  final databaseNote = useState<List<DatabaseNote>>([]);

  // final databaseNote = useState<DatabaseNote>(DatabaseNote(
  //id: '1111', userId: '111aaa', text: 'Default note text', isSyncedWithCloud: true));

  final isLoading = useState(false);
  final error = useState<String?>(null);

  print(
      ' ********************* FetchNotes fetchNotes() { ********************* ');
  print(' ********************* ${databaseNote.value}********************* ');

  void fetchData() async {
    isLoading.value = true;

    print(
        ' ********************* fetchData()--- fetchNotes() { ********************* ');

    try {
      Uri url = Uri.parse('http://192.168.1.71:8000/api/notes/');

      final response = await http.get(url);

      print(' ******    try {   *************http://192.168.1.71:8000/api/notes/5a2d2d8c-7e64-480c-b5a9-40f3db59a6b7******************* ');
      print(' ******    try {   *************** ${databaseNote.value}********************* ');
      print(' ******    try {   *************** ${response.statusCode} ********************* ');
      print(' ******    try {   ****************************************************************** ');
      print(' ******    try {   ****************************************************************** ');
      print(' ******    try {   ****************************************************************** ');

      print(' ******    try {   ***** ${response.body} ***** ');
      print(' ******    try {   ****************************************************************** ');
      print(' ******    try {   ****************************************************************** ');
      print(' ******    try {   ****************************************************************** ');

      print(' ******    try {   ****************************************************************** ');

      if (response.statusCode == 200) {
           var jsonDecoded = response.body; 
        databaseNote.value = databaseNotesFromJson(jsonDecoded);

        print(' ******    try {   ****************************************************************** ');
        print(' ******    try {   *************** ${databaseNote.value}********************* ');

        print(' ******    try {   *************** ${databaseNotesFromJson(response.body)} ********************* ');
        print(' ******    try {   *************** ${response.body} ********************* ');
        print(' ******    try {   ****************************************************************** ');
      }
    } catch (e) {
      error.value = e.toString();
      print(' ******  error  **** ');

      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  useEffect(() {
    // useEffect will run whenever "categories page" will run isn=
    fetchData();

    print(' ********************* useEffect(()  ********************* ');
    print(
        ' *********************useEffect(()  ${databaseNote.value}********************* ');

    return;
  }, const []);

  void refetch() {
    isLoading.value = true;
    fetchData();

    print(' *********************  refetch()  ********************* ');
  }

  return FetchNotes(
    databaseNote: databaseNote.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}
