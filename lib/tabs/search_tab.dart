import 'package:ecommerce_app/constants.dart';
import 'package:ecommerce_app/widgets/customactionbar.dart';
import 'package:flutter/material.dart';

class SearchTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Center(
            child: Text(
              "Search",
              style: Constants.boldHeading,
            ),
          ),
          CustomActionBar(
            title: "Search",
            hasBackArrow: false,
          )
        ],
      ),
    );
  }
}
