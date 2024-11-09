import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'layout/homeScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(Duration(microseconds: 1));
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:false ,
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   useMaterial3: true,
      // ),
      home: Homescreen(),
      initialRoute: Homescreen.routeName,
      routes: {
        Homescreen.routeName: (context) => Homescreen(), // Route setup
      },
    );
  }
}
