import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'AuthenticationPage.dart';
import 'recentLogs.dart';

class DetailedNumPltSrn extends StatefulWidget {
  DetailedNumPltSrn(this.data);

  final Map data;

  @override
  _DetailedNumPltSrnState createState() => _DetailedNumPltSrnState();
}

class _DetailedNumPltSrnState extends State<DetailedNumPltSrn> {
  @override
  Widget build(BuildContext context) {
    print(widget.data);
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.data['numberPlateNumber']}'),
        backgroundColor: Colors.black,
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.white,
              ),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('number_plate')
                    .doc(user.id)
                    .collection("number_plate")
                    .doc(widget.data['numberPlateNumber'])
                    .delete();

                FirebaseFirestore.instance
                    .collection('logs')
                    .doc(user.id)
                    .collection("logs")
                    .doc('Q12w' + widget.data['numberPlateNumber'])
                    .delete();

                FirebaseFirestore.instance
                    .collection('logs')
                    .doc(user.id)
                    .collection(widget.data['numberPlateNumber'])
                    .get()
                    .then((snapshot) {
                  for (DocumentSnapshot ds in snapshot.docs) {
                    ds.reference.delete();
                  }
                });

                // final delNumPlate = FirebaseFirestore.instance
                //     .collection('logs')
                //     .doc(user.id)
                //     .collection(widget.data['numberPlateNumber'])
                //     .where("number_plate",
                //         isEqualTo: widget.data['numberPlateNumber'])
                //     .snapshots();
                // delNumPlate.forEach((ele) {
                //   print(ele.docs);
                //   ele.docs.forEach((element) {
                //     print(element.id);
                //     FirebaseFirestore.instance
                //         .collection('logs')
                //         .doc(user.id)
                //         .collection("logs")
                //         .doc(element.id)
                //         .delete();
                //   });
                // });
                Navigator.pop(context);
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                color: Colors.grey.shade200,
                height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.width,
                child: CachedNetworkImage(
                  imageUrl: widget.data['imageUrl'],
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Material(
                  elevation: 5.0,
                  color: Colors.grey[300],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 7,
                          width: 10.0,
                        ),
                        RichText(
                          text: TextSpan(
                            text: "Engine Number : ",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                            children: <TextSpan>[
                              TextSpan(
                                text: widget.data["engineNumber"],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 7,
                          width: 10.0,
                        ),
                        RichText(
                          text: TextSpan(
                            text: "Engine Size : ",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                            children: <TextSpan>[
                              TextSpan(
                                text: widget.data["engineSize"],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 7,
                          width: 10.0,
                        ),
                        RichText(
                          text: TextSpan(
                            text: "Fuel Type : ",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                            children: <TextSpan>[
                              TextSpan(
                                text: widget.data["fuelType"],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 7,
                          width: 10.0,
                        ),
                        (widget.data["ownername"] != "")
                            ? RichText(
                                text: TextSpan(
                                  text: "Owner Name : ",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: widget.data["ownername"],
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal),
                                    )
                                  ],
                                ),
                              )
                            : RichText(
                                text: TextSpan(
                                  text: "Owner Name : ",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: widget.data["username"],
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal),
                                    )
                                  ],
                                ),
                              ),
                        SizedBox(
                          height: 7,
                          width: 10.0,
                        ),
                        RichText(
                          text: TextSpan(
                            text: "Number of Seats : ",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                            children: <TextSpan>[
                              TextSpan(
                                text: widget.data["numberOfSeats"],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 7,
                          width: 10.0,
                        ),
                        RichText(
                          text: TextSpan(
                            text: "Vehicle Variant : ",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                            children: <TextSpan>[
                              TextSpan(
                                text: widget.data["variant"],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 7,
                          width: 10.0,
                        ),
                        RichText(
                          text: TextSpan(
                            text: "Vehicle Class : ",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                            children: <TextSpan>[
                              TextSpan(
                                text: widget.data["vehicleClass"],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 7,
                          width: 10.0,
                        ),
                        RichText(
                          text: TextSpan(
                            text: "Chassis Number : ",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                            children: <TextSpan>[
                              TextSpan(
                                text: widget.data["chassisNumber"],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 7,
                          width: 10.0,
                        ),
                        RichText(
                          text: TextSpan(
                            text: "Registration Date : ",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                            children: <TextSpan>[
                              TextSpan(
                                text: widget.data["regDate"],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 7,
                          width: 10.0,
                        ),
                        RichText(
                          text: TextSpan(
                            text: "Vehicle Class : ",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                            children: <TextSpan>[
                              TextSpan(
                                text: widget.data["vehicleClass"],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 7,
                          width: 10.0,
                        ),
                        RichText(
                          text: TextSpan(
                            text: "Insurance Expiry : ",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                            children: <TextSpan>[
                              TextSpan(
                                text: widget.data["insuranceExpiry"],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 7,
                          width: 10.0,
                        ),
                        RichText(
                          text: TextSpan(
                            text: "Registering Authority : ",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                            children: <TextSpan>[
                              TextSpan(
                                text: widget.data["registeringAuthority"],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 7,
                          width: 10.0,
                        ),
                        RichText(
                          text: TextSpan(
                            text: "Model : ",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                            children: <TextSpan>[
                              TextSpan(
                                text: widget.data["model"],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecentLogs(
                numberPlate: widget.data['numberPlateNumber'],
              ),
            ),
          );
        },
        child: Icon(Icons.update),
        backgroundColor: Colors.black,
      ),
    );
  }
}
