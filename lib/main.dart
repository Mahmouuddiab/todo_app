import 'package:add_task/auth/login.dart';
import 'package:add_task/auth/register.dart';
import 'package:add_task/home/home.dart';
import 'package:add_task/provider/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(
    create: (context)=>UserProvider(),
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Login.routeName,

      routes: {
        Home.routeName:(_)=>Home(),
        Register.routeName:(_)=>Register(),
        Login.routeName:(_)=>Login()
      },
    );
  }
}
