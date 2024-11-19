import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Providers/img_Providers.dart';
import 'layout/homeScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Initialize once
  await Firebase.initializeApp();

  runApp(
    const MyApp(),
  );
  // runApp(
  //   MultiProvider(
  //     providers: [
  //       ChangeNotifierProvider(create: (_) => ImageProviderNotifier()),
  //     ],
  //     child: const MyApp(),
  //   ),
  // );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: Homescreen(),
      initialRoute: Homescreen.routeName,
      routes: {
        Homescreen.routeName: (context) => Homescreen(),
      },
    );
  }
}
