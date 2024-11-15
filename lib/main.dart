import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth_screen.dart';
import 'profile_screen.dart';
import 'task_list_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(primarySwatch: Colors.teal),
      initialRoute: '/auth',
      routes: {
        '/auth': (context) => AuthScreen(),
        '/profile': (context) => ProfileScreen(),
        '/tasks': (context) => TaskListScreen(),
      },
    );
  }
}
