import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/constants.dart';
import 'package:ecommerce_app/screens/product_page.dart';
import 'package:ecommerce_app/widgets/customactionbar.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  final CollectionReference _productsRef =
      FirebaseFirestore.instance.collection("Products");

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
            future: _productsRef.get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("error: ${snapshot.error}"),
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                return ListView(
                  padding: EdgeInsets.only(
                    top: 108.0,
                  ),
                  children: snapshot.data.docs.map((document) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ProductPage(productId: document.id)));
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 24.0),
                        height: 350.0,
                        child: Stack(children: [
                          Container(
                            height: 350,
                            width: 400,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Image.network(
                                  "${document.data()['images'][0]}",
                                  fit: BoxFit.cover),
                            ),
                          ),
                          Positioned(
                            top: 300,
                            left: 0,
                            right: 0,
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    document.data()['name'] ?? "Product Name",
                                    style: Constants.regularDarkText,
                                  ),
                                  Text(
                                    "\$${document.data()['price']}" ?? "Price",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Theme.of(context).accentColor,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                            ),
                          )
                        ]),
                      ),
                    );
                  }).toList(),
                );
              }
            },
          ),
          CustomActionBar(
            title: "Home",
            hasBackArrow: false,
          )
        ],
      ),
    );
  }
}
