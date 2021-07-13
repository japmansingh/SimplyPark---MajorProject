import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minor_project/Pages/AuthenticationPage.dart';
import 'package:minor_project/Pages/detailedNumberPlate.dart';
import 'package:shimmer/shimmer.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // Widget shimmeringLoadingCards() {
  //   return SingleChildScrollView(
  //     child: Shimmer.fromColors(
  //       highlightColor: Colors.white,
  //       baseColor: Colors.grey[300],
  //       child: Padding(
  //         padding: const EdgeInsets.all(20.0),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Container(
  //               height: 20,
  //               width: 200,
  //               color: Colors.grey,
  //             ),
  //             SizedBox(
  //               height: 20.0,
  //             ),
  //             ClipRRect(
  //               borderRadius: BorderRadius.circular(20.0),
  //               child: Container(
  //                 height: MediaQuery.of(context).size.height / 4,
  //                 width: MediaQuery.of(context).size.width,
  //                 color: Colors.grey,
  //               ),
  //             ),
  //             SizedBox(
  //               height: 20.0,
  //             ),
  //             Container(
  //               height: 20,
  //               width: 275,
  //               color: Colors.grey,
  //             ),
  //             SizedBox(
  //               height: 10.0,
  //             ),
  //             Container(
  //               height: 20,
  //               width: 300,
  //               color: Colors.grey,
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  final numberPlateRef = FirebaseFirestore.instance
      .collection('number_plate')
      .doc(user.id)
      .collection("number_plate");

  List<DocumentSnapshot> documents = [];

  int counter = 0;

  @override
  void initState() {
    // TODO: implement initState
    getNumberPlateDocs();
    super.initState();
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
          width: MediaQuery.of(context).size.width / 2,
          color: Colors.grey[200],
          child: InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailedNumPltSrn(document.data())),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width / 3,
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
        title: Text("Profile"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Container(
                height: 100,
                child: Center(
                  child: ClipOval(
                    child: Image.network(
                      user.photoUrl,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {},
                child: Text(
                  user.displayName.toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
              ),
              Text(
                "$counter Cars added",
                style: TextStyle(color: Colors.grey),
              ),
              Text(
                "${user.email}",
                style: TextStyle(color: Colors.grey),
              ),
              // shimmeringLoadingCards(),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Added Number plates:",
                style: TextStyle(color: Colors.grey),
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
