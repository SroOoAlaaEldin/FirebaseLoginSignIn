import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_google_signin/home_page.dart';
import 'package:firebase_google_signin/login_page.dart';
import 'package:firebase_google_signin/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  try {
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
    await Firebase.initializeApp();
    runApp(MyApp());
  } catch (e) {
    print('$e');
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase',
      // home: LoginPage(),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        'signup': (context) => SignupPage(),
      },
    );
  }
}
