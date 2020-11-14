import 'package:ecommerce_app/screens/homepage.dart';
import 'package:ecommerce_app/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class LandingPage extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("error: ${snapshot.error}"),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, StreamSnapshot) {
              if (StreamSnapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("error: ${StreamSnapshot.error}"),
                  ),
                );
              }
              if (StreamSnapshot.connectionState == ConnectionState.active) {
                User user = StreamSnapshot.data;
                if (user == null) {
                  return LoginPage();
                } else {
                  return HomePage();
                }
              }
              return Scaffold(
                body: Center(
                  child: Text("initializing app..."),
                ),
              );
            },
          );
        }
        return Scaffold(
          body: Center(
            child: Text("initializing app..."),
          ),
        );
      },
      
    );
  }
}
