# Experiment 8 – Data Persistence using SQLite and Firebase

**Course:** 24CS2016 – Building Applications using Flutter  
**Name:** Jomi W  
**Register No.:** URK23CS1299

## Aim

To implement data persistence using a local SQLite database and cloud Firebase database.

## Description

This experiment introduces data persistence in Flutter using local and cloud storage. Student records are stored locally in an SQLite database using the sqflite package with CRUD operations. Student data is also stored in and retrieved from a Firebase cloud collection.

## Source files

- `pubspec.yaml`
- `lib/database_helper.dart`
- `lib/main.dart`
- `lib/firebase_page.dart`

## Running on the web

SQLite on the web needs its WASM files once:

```bash
dart run sqflite_common_ffi_web:setup
```

## How to run

The repository contains the Dart source and `pubspec.yaml`. Generate the platform folders once, then run:

```bash
flutter create .
flutter pub get
flutter run
```

## Firebase setup (Part B)

`lib/firebase_options.dart` contains placeholder values. Connect your own Firebase project before running:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

This overwrites `lib/firebase_options.dart` with your project's settings. Then create a Firestore database in the Firebase Console; the app uses a `students` collection with `name` and `course` fields.

## Result

A Flutter application demonstrating data persistence was developed successfully. Student records were stored in a local SQLite database using CREATE, READ, UPDATE and DELETE. The stored data remained available after the application was closed and run again. Student information was sent to a Firebase collection and retrieved and displayed in the application.
