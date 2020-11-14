import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomActionBar extends StatelessWidget {
  final String title;
  final bool hasBackArrow;
  final bool hastitle;
  CustomActionBar({this.hasBackArrow, this.title, this.hastitle});

  @override
  Widget build(BuildContext context) {
    bool _hasBackArrow = hasBackArrow ?? false;
    bool _hasTitle = hastitle ?? false;

    final CollectionReference _usersRef =
        FirebaseFirestore.instance.collection("Users");

    User _user = FirebaseAuth.instance.currentUser;

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        Colors.white,
        Colors.white.withOpacity(0),
      ], begin: Alignment(0, 0), end: Alignment(0, 1))),
      padding: EdgeInsets.only(top: 56.0, left: 24, right: 24, bottom: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_hasBackArrow)
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Image(
                image: AssetImage("assets/images/back_arrow.png"),
                width: 16.0,
                height: 16.0,
              ),
            ),
          if (_hasTitle)
            Text(
              "Home",
              style: Constants.boldHeading,
            ),
          Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8.0),
              ),
              alignment: Alignment.center,
              child: StreamBuilder(
                stream: _usersRef.doc(_user.uid).collection("Cart").snapshots(),
                builder: (context, snapshot) {
                  int _totalItems = 0;
                  if (snapshot.connectionState == ConnectionState.done) {
                    List _documents = snapshot.data.docs;
                    _totalItems = _documents.length;
                  }
                  return Text(
                    "$_totalItems" ?? "0",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  );
                },
              ))
        ],
      ),
    );
  }
}
