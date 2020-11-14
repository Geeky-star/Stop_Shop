import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/constants.dart';
import 'package:ecommerce_app/widgets/customactionbar.dart';
import 'package:ecommerce_app/widgets/product_size.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/widgets/products_size.dart';

class ProductPage extends StatefulWidget {
  final String productId;

  ProductPage({Key key, this.productId});
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final CollectionReference _productsRef =
      FirebaseFirestore.instance.collection("Products");

  final CollectionReference _usersRef =
      FirebaseFirestore.instance.collection("Users");

  User _user = FirebaseAuth.instance.currentUser;

  Future _addToCart() {
    return _usersRef
        .doc(_user.uid)
        .collection("Cart")
        .doc(widget.productId)
        .set({"size": "S"});
  }

  final SnackBar _snackBar = SnackBar(
    content: Text("Product added To Cart"),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        FutureBuilder(
          future: _productsRef.doc(widget.productId).get(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Text("error: ${snapshot.error}"),
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> documentData = snapshot.data.data();
              List imageList = documentData['images'];

              List productsSizes = documentData['size'];

              return ListView(
                children: [
                  Container(
                    height: 400,
                    child: PageView(
                      children: [
                        for (var i = 0; i < imageList.length; i++)
                          Container(
                            child: Image.network(
                              "${imageList[i]}",
                              fit: BoxFit.cover,
                            ),
                          )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 24, left: 24, right: 24, bottom: 4),
                    child: Text(
                      "${documentData['name']}" ?? "Product Name",
                      style: Constants.boldHeading,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4, horizontal: 24.0),
                    child: Text(
                      "\$${documentData['price']}" ?? "Price",
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                    child: Text(
                      "${documentData['desc']}",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                    child: Text(
                      "Select Size: ",
                      style: Constants.regularDarkText,
                    ),
                  ),
                  ProductSize(productSizes: productsSizes),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 65,
                          height: 65,
                          decoration: BoxDecoration(
                              color: Color(0xFFDCDCDC),
                              borderRadius: BorderRadius.circular(12)),
                          child: Image(
                            image: AssetImage("assets/images/tab_saved.png"),
                            height: 22,
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              await Scaffold.of(context)
                                  .showSnackBar(_snackBar);
                            },
                            child: Container(
                              height: 65,
                              margin: EdgeInsets.only(left: 16),
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(12)),
                              child: Text(
                                "Add To Cart",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              );
            }
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
        CustomActionBar(
          hasBackArrow: true,
          hastitle: false,
        )
      ],
    ));
  }
}
