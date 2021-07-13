import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minor_project/Pages/AuthenticationPage.dart';
import 'package:minor_project/Pages/detailedNumberPlate.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:toast/toast.dart';
import 'package:uuid/uuid.dart';

class NumberPlateSelector extends StatefulWidget {
  final String title;
  final String price;
  final String imageUrl;

  const NumberPlateSelector({Key key, this.title, this.price, this.imageUrl})
      : super(key: key);

  @override
  _NumberPlateSelectorState createState() => _NumberPlateSelectorState();
}

class _NumberPlateSelectorState extends State<NumberPlateSelector> {
  final numberPlateRef = FirebaseFirestore.instance
      .collection('number_plate')
      .doc(user.id)
      .collection("number_plate");

  List<DocumentSnapshot> documents = [];

  int counter = 0;

  Razorpay razorpay;

  @override
  void initState() {
    // TODO: implement initState
    getNumberPlateDocs();
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // razorpay.clear();
  }

  void handlerPaymentSuccess() {
    print("Pament success");
    // FirebaseFirestore.instance
    //     .collection('logs')
    //     .doc(user.id)
    //     .collection("logs")
    //     .doc('Q12w' + widget.numberPlate)
    //     .update({'paid': 'paid'});
    // Toast.show("Pament success", context);
  }

  void handlerErrorFailure() {
    print("Pament error");
    Toast.show("Pament error", context);
  }

  void handlerExternalWallet() {
    print("External Wallet");
    Toast.show("External Wallet", context);
  }

  void openPaymentGateway(double amountCharge, String numberPlate,
      String place) {
    var options = {
      "key": "rzp_test_blz8Zlo4PPZtB3",
      "amount": amountCharge * 100,
      "name": "Complete Your ${widget.title} Payment",
      "description": "$numberPlate, $place",
      "prefill": {"contact": "8860037713", "email": "${user.email}"},
      "external": {
        "wallets": ["paytm"]
      }
    };

    try {
      razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  getNumberPlateDocs() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('number_plate')
        .doc(user.id)
        .collection("number_plate")
        .getDocuments();
    documents = result.documents;
    setState(() {
      documents.forEach((data) => counter++);
    });
    print("cccccooouuunnnttteeerrrrrrrr $counter");
  }

  Widget listItem(BuildContext context, DocumentSnapshot document) {
    return Padding(
      padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          height: 50,
          width: MediaQuery
              .of(context)
              .size
              .width / 2,
          color: Colors.grey[200],
          child: InkWell(
            onTap: () async {
              final DateTime timestampChat = DateTime.now();
              String messageId = Uuid().v4();
              var _price = (widget.price).replaceAll("RS.","");
              await FirebaseFirestore.instance
                  .collection('admin_panel')
                  .doc('central_park')
                  .collection('services')
                  .doc(messageId)
                  .set({
                "timestamp": timestampChat,
                "price": widget.price,
                "image_url": widget.imageUrl,
                "title": widget.title,
                "number_plate": document.id,
                "place": "central_park",
              }).whenComplete((){
                var d = double.parse(_price);
                print(d);
                openPaymentGateway(
                    double.parse(_price), document.id, "Central Park");
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Container(
                height: 40,
                width: MediaQuery
                    .of(context)
                    .size
                    .width / 3,
                padding: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    '${document.id}',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Services"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {},
                child: Text(
                  "CHOOSE YOUR CAR",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
              ),
              // Text(
              //   "$counter Cars added",
              //   style: TextStyle(color: Colors.grey),
              // ),
              // Text(
              //   "${user.email}",
              //   style: TextStyle(color: Colors.grey),
              // ),
              // shimmeringLoadingCards(),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Added Number plates:",
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(
                height: 10.0,
              ),
              StreamBuilder(
                stream: numberPlateRef
                    .orderBy('timestamp', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Text("Loading....."),
                    );
                  }
                  return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.documents.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return listItem(
                            context, snapshot.data.documents[index]);
                      });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
