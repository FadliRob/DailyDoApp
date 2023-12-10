import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_uas/screens/splash.dart';
import 'package:flutter_todo_uas/screens/splash_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      appId: '1:93797852967:android:efe198cb0c1ac3e0766b02',
      apiKey: 'AIzaSyBqn33DjdpzKrX2yH6z3AyghbNKftQux7Q',
      messagingSenderId: '93797852967',
      projectId: 'my-todo-app-54e32',
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DailyDo App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Splash(),
    );
  }
}
