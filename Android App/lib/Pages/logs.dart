import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minor_project/Pages/AuthenticationPage.dart';
import 'package:minor_project/widgets/log_tile.dart';

class Logs extends StatefulWidget {
  @override
  _LogsState createState() => _LogsState();
}

class _LogsState extends State<Logs> {
  // int _payRate = 30;
  // double calChg = 0;
  // bool _notParked = true;
  final logsRef = FirebaseFirestore.instance
      .collection('logs')
      .doc(user.id)
      .collection("logs");

  // Widget listItem(BuildContext context, DocumentSnapshot document) {
  //   // String entry =
  //   //     DateTime.parse(document["entry_timestamp"].toDate().toString())
  //   //         .toString()
  //   //         .substring(0, 19);
  //   // String exit = "";
  //   // try {
  //   //   exit = DateTime.parse(document["exit_timestamp"]?.toDate().toString())
  //   //       .toString()
  //   //       .substring(0, 19);
  //   //   _notParked = true;
  //   // } catch (e) {
  //   //   print("false false******************");
  //   //   exit = "Vehicle in Parking";
  //   //   _notParked = false;
  //   // }
  //   // print("*******************$entry");
  //   String entry = document["entry_timestamp"];
  //   print("*******************$entry");
  //
  //   int entryHr = int.parse(entry.substring(11, 13));
  //   int entryMn = int.parse(entry.substring(14, 16));
  //   String exit = "";
  //   int exitHr = 0;
  //   int exitMn = 0;
  //   try {
  //     exit = document["exit_timestamp"];
  //     exitHr = int.parse(exit.substring(11, 13));
  //     exitMn = int.parse(exit.substring(14, 16));
  //     calChg = (exitHr - entryHr) * _payRate +
  //         ((exitMn - entryMn) * (_payRate / 60));
  //     print("Charge : $calChg");
  //     _notParked = true;
  //   } catch (e) {
  //     print(e);
  //     exit = "Vehicle in Parking";
  //     _notParked = false;
  //   }
  //   return GestureDetector(
  //     onTap: () {
  //       if (_notParked) {
  //         Navigator.push(context,
  //             MaterialPageRoute(builder: (context) => CreditCardPage(calChg)));
  //       }
  //     },
  //     child: Padding(
  //       padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
  //       child: ClipRRect(
  //         borderRadius: BorderRadius.circular(20.0),
  //         child: Container(
  //           height: 200,
  //           width: MediaQuery.of(context).size.width / 2,
  //           color: Colors.grey[200],
  //           child: Padding(
  //             padding: const EdgeInsets.only(
  //                 top: 15.0, right: 15.0, bottom: 15.0, left: 5.0),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   mainAxisSize: MainAxisSize.max,
  //                   children: [
  //                     Container(
  //                       height: 40,
  //                       width: MediaQuery.of(context).size.width / 3,
  //                       padding: const EdgeInsets.all(10),
  //                       decoration: BoxDecoration(
  //                           color: Colors.black,
  //                           borderRadius: BorderRadius.circular(20)),
  //                       child: Center(
  //                         child: Text(
  //                           '${document["number_plate"]}',
  //                           // '${document["place"]}',
  //                           style: TextStyle(color: Colors.white),
  //                           overflow: TextOverflow.ellipsis,
  //                           maxLines: 1,
  //                         ),
  //                       ),
  //                     ),
  //                     _notParked
  //                         ? Row(
  //                             children: [
  //                               Text(
  //                                 '₹',
  //                                 style: TextStyle(
  //                                   color: Colors.green,
  //                                   fontSize: 15,
  //                                   fontWeight: FontWeight.bold,
  //                                 ),
  //                               ),
  //                               Text(
  //                                 "$calChg",
  //                                 style: TextStyle(
  //                                   color: Colors.green,
  //                                   fontSize: 15,
  //                                   fontWeight: FontWeight.bold,
  //                                 ),
  //                               )
  //                             ],
  //                           )
  //                         : Container(
  //                             height: 0.0,
  //                             width: 0.0,
  //                           ),
  //                   ],
  //                 ),
  //                 SizedBox(
  //                   height: 5,
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.only(left: 5.0),
  //                   child: SizedBox(
  //                     width: MediaQuery.of(context).size.width / 1.2,
  //                     child: Text(
  //                       'Place: ${document["place"]}',
  //                       style: TextStyle(
  //                         fontSize: 15,
  //                         color: Colors.black,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                       maxLines: 1,
  //                       softWrap: false,
  //                       overflow: TextOverflow.ellipsis,
  //                     ),
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   height: 5,
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.only(left: 5.0),
  //                   child: SizedBox(
  //                     width: MediaQuery.of(context).size.width / 1.2,
  //                     child: Text(
  //                       "Entry Timestamp:",
  //                       style: TextStyle(
  //                         fontSize: 15,
  //                         color: Colors.black,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                       maxLines: 1,
  //                       softWrap: false,
  //                       overflow: TextOverflow.ellipsis,
  //                     ),
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   height: 3,
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.only(left: 5.0),
  //                   child: SizedBox(
  //                     width: MediaQuery.of(context).size.width / 1.2,
  //                     child: Text(
  //                       "Date: ${entry.substring(0, 10)}    Time: ${entry.substring(11, 19)}",
  //                       style: TextStyle(
  //                         fontSize: 15,
  //                         color: Colors.black,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                       maxLines: 1,
  //                       softWrap: false,
  //                       overflow: TextOverflow.ellipsis,
  //                     ),
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   height: 5,
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.only(left: 5.0),
  //                   child: Text(
  //                     'Exit Timestamp:',
  //                     style: TextStyle(
  //                       fontSize: 15,
  //                       color: Colors.black,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                     overflow: TextOverflow.ellipsis,
  //                     softWrap: false,
  //                     maxLines: 1,
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   height: 3,
  //                 ),
  //                 _notParked
  //                     ? Padding(
  //                         padding: const EdgeInsets.only(left: 5.0),
  //                         child: SizedBox(
  //                           width: MediaQuery.of(context).size.width / 1.2,
  //                           child: Text(
  //                             "Date: ${exit?.substring(0, 10)}    Time: ${exit?.substring(11, 19)}",
  //                             style: TextStyle(
  //                               fontSize: 15,
  //                               color: Colors.black,
  //                               fontWeight: FontWeight.bold,
  //                             ),
  //                             maxLines: 1,
  //                             softWrap: false,
  //                             overflow: TextOverflow.ellipsis,
  //                           ),
  //                         ),
  //                       )
  //                     : Padding(
  //                         padding: const EdgeInsets.only(left: 5.0),
  //                         child: SizedBox(
  //                           width: MediaQuery.of(context).size.width / 1.2,
  //                           child: Text(
  //                             exit,
  //                             style: TextStyle(
  //                               fontSize: 15,
  //                               color: Colors.black,
  //                               fontWeight: FontWeight.bold,
  //                             ),
  //                             maxLines: 1,
  //                             softWrap: false,
  //                             overflow: TextOverflow.ellipsis,
  //                           ),
  //                         ),
  //                       ),
  //                 _notParked
  //                     ? Padding(
  //                         padding: const EdgeInsets.only(left: 5.0),
  //                         child: Text(
  //                           "Parked for: ${exitHr - entryHr} hr. and ${exitMn - entryMn} min.",
  //                           style: TextStyle(
  //                             color: Colors.green.shade900,
  //                             fontSize: 15,
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                       )
  //                     : Container(
  //                         height: 0.0,
  //                         width: 0.0,
  //                       ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream: logsRef.orderBy('entry_timestamp', descending: true)?.snapshots(),
      builder: (context, snapshot) {
        print(
            "***************************************entered snapshot $snapshot");
        if (!snapshot.hasData) {
          return Center(
            child: Text("Loading Logs....."),
          );
        }
        return ListView.builder(
            itemCount: snapshot.data.documents.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              DocumentSnapshot document = snapshot.data.documents[index];
              return LogTile(
                entryTimestamp: document["entry_timestamp"],
                exitTimestamp: document['exit_timestamp'],
                numberPlate: document["number_plate"],
                place: document['place'],
                paid: document['paid'] ?? '',
              );
            });
      },
    ));
  }
}
