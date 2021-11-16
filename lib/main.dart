import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lms/authentication/Screens/login_screen.dart';
import 'package:provider/provider.dart';

import 'calendar/calendar.dart';
import 'models/provider_notifier.dart';
import 'widget/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProviderNotifier>(
          create: (context) => ProviderNotifier(),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                return WelcomeScreen();
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Unknown Error Occurred'),
                );
              } else {
                return SignIn();
              }
            },
          )),
    );
  }
}
