import 'package:ecommerce_app/constants.dart';
import 'package:ecommerce_app/widgets/customactionbar.dart';
import 'package:flutter/material.dart';

class SavedTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Center(
            child: Text(
              "Saved",
              style: Constants.boldHeading,
            ),
          ),
          CustomActionBar(
            title: "Saved",
            hasBackArrow: false,
          )
        ],
      ),
    );
  }
}
