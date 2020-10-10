import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:student/Dashboard.dart';

import 'package:student/services/auth_provider.dart';
import 'package:student/sign/login.dart';
import 'package:student/sign/register.dart';
import 'package:student/status.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Login(),
      routes: {
        '/dashboard': (ctx) => DashBoard(),
        '/login': (ctx) => Login(),
        '/register': (ctx) => Register(),
        '/status': (ctx) => Status(),
      },
    );
  }
}
