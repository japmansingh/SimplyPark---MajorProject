import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minor_project/Pages/AuthenticationPage.dart';
import 'package:minor_project/Pages/addNumberPlate.dart';
import 'package:minor_project/Pages/detailedNumberPlate.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

class Parking extends StatefulWidget {
  @override
  _ParkingState createState() => _ParkingState();
}

class _ParkingState extends State<Parking> {
  final numberPlateRef = FirebaseFirestore.instance
      .collection('number_plate')
      .doc(user.id)
      .collection("number_plate");
  String numberPlate;

  Widget listItem(BuildContext context, DocumentSnapshot document) {
    return Padding(
      padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          height: 130,
          width: MediaQuery.of(context).size.width / 2,
          color: Colors.grey[200],
          child: InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailedNumPltSrn(document.data())),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 15.0, right: 15.0, bottom: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width / 3,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: Text(
                              '${document["numberPlateNumber"]}',
                              style: TextStyle(color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 1.4,
                          child: Text(
                            "Owner: ${document["ownername"]}",
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.18,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Text(
                            'Car Model: ${document["model"]}',
                            style: TextStyle(color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  newLogTile(BuildContext context, DocumentSnapshot document) {
    if (document["imageUrl"] != null)
      return InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailedNumPltSrn(document.data())),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200]),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10)),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10)),
                      color: Colors.black,
                    ),
                    width: 150,
                    height: 100,
                    child: CachedNetworkImage(
                      imageUrl: document["imageUrl"] ?? "",
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 7,
                      horizontal: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 38,
                          // width: MediaQuery.of(context).size.width / 3,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            '${document["numberPlateNumber"]}',
                            style:
                                TextStyle(color: Colors.white, fontSize: 19.0),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        (document["ownername"] != "")
                            ? Text(
                                "Owner: ${document["ownername"]}",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                  // fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                              )
                            : Text(
                                "Owner: ${document["username"]}".toUpperCase(),
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                  // fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                              ),
                        SizedBox(
                          height: 2.0,
                        ),
                        Text(
                          "Model: ${document["model"]}",
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                            // fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          numberPlate = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddNumberPlate()));
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0XFF003051),
      ),
      body: StreamBuilder(
        stream:
            numberPlateRef.orderBy('timestamp', descending: false).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text("Loading....."),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data.documents.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return newLogTile(context, snapshot.data.documents[index]);
              });
        },
      ),
    );
  }
}
