// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'SendComplaint.dart';  // Import the SendComplaint page (this should be your SendComplaintPage).
//
// class ViewComplaintReply extends StatefulWidget {
//   const ViewComplaintReply({Key? key, required this.title}) : super(key: key);
//
//   final String title;
//
//   @override
//   State<ViewComplaintReply> createState() => _ViewComplaintReply();
// }
//
// class _ViewComplaintReply extends State<ViewComplaintReply> {
//   int _counter = 0;
//
//   _ViewComplaintReply() {
//     view_complaint_reply();
//   }
//
//   List<String> id_ = <String>[];
//   List<String> complaint_ = <String>[];
//   List<String> date_ = <String>[];
//   List<String> reply_ = <String>[];
//
//   Future<void> view_complaint_reply() async {
//     List<String> id = <String>[];
//     List<String> complaint = <String>[];
//     List<String> date = <String>[];
//     List<String> reply = <String>[];
//
//     try {
//       final pref = await SharedPreferences.getInstance();
//       String lid = pref.getString("lid").toString();
//       String ip = pref.getString("url").toString();
//
//       String url = ip + "viewcomplaint";
//       print(url);
//       var data = await http.post(Uri.parse(url), body: {
//         'lid': lid,
//       });
//
//       var jsondata = json.decode(data.body);
//       String status = jsondata['status'];
//
//       var arr = jsondata["data"];
//       print(arr);
//       print(arr.length);
//
//       for (int i = 0; i < arr.length; i++) {
//         id.add(arr[i]['id'].toString());
//         complaint.add(arr[i]['complaint'].toString());
//         date.add(arr[i]['date'].toString());
//         reply.add(arr[i]['reply'].toString());
//       }
//
//       setState(() {
//         id_ = id;
//         complaint_ = complaint;
//         date_ = date;
//         reply_ = reply;
//       });
//
//       print(id_.length);
//       print("+++++++++++++++++++++");
//       print(status);
//     } catch (e) {
//       print("Error ------------------- " + e.toString());
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "View All Complaints",
//           style: TextStyle(color: Colors.black),
//         ),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//             print("Back button pressed");
//           },
//         ),
//       ),
//       body: ListView.builder(
//         physics: BouncingScrollPhysics(),
//         itemCount: id_.length,
//         itemBuilder: (BuildContext context, int index) {
//           return ListTile(
//             onLongPress: () {
//               print("Long press on item $index");
//             },
//             title: Padding(
//               padding: const EdgeInsets.all(4.0),
//               child: Column(
//                 children: [
//                   Container(
//                     width: MediaQuery.of(context).size.width,
//                     child: Card(
//                       clipBehavior: Clip.antiAliasWithSaveLayer,
//                       child: Column(
//                         children: [
//                           SizedBox(height: 16),
//                           Row(
//                             children: [
//                               SizedBox(width: 10),
//                               Flexible(
//                                 flex: 2,
//                                 fit: FlexFit.loose,
//                                 child: Row(children: [Text("Complaint")]),
//                               ),
//                               Flexible(
//                                 flex: 3,
//                                 fit: FlexFit.loose,
//                                 child: Row(children: [Text(complaint_[index])]),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 16),
//                           Row(
//                             children: [
//                               SizedBox(width: 10),
//                               Flexible(
//                                 flex: 2,
//                                 fit: FlexFit.loose,
//                                 child: Row(children: [Text("date")]),
//                               ),
//                               Flexible(
//                                 flex: 3,
//                                 fit: FlexFit.loose,
//                                 child: Row(children: [Text(date_[index])]),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 16),
//                           Row(
//                             children: [
//                               SizedBox(width: 10),
//                               Flexible(
//                                 flex: 2,
//                                 fit: FlexFit.loose,
//                                 child: Row(children: [Text("reply")]),
//                               ),
//                               Flexible(
//                                 flex: 3,
//                                 fit: FlexFit.loose,
//                                 child: Row(children: [Text(reply_[index])]),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                       elevation: 5,
//                       margin: EdgeInsets.all(10),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Navigate to the SendComplaint page
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => SendComplaint()),
//           );
//         },
//         backgroundColor: Colors.blue,
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'SendComplaint.dart';  // Import the SendComplaint page.

class ViewComplaintReply extends StatefulWidget {
  const ViewComplaintReply({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ViewComplaintReply> createState() => _ViewComplaintReply();
}

class _ViewComplaintReply extends State<ViewComplaintReply> {
  bool isAppointmentCanceled = false;  // Flag to track cancellation

  _ViewComplaintReply() {
    view_complaint_reply();
  }

  List<String> id_ = <String>[];
  List<String> complaint_ = <String>[];
  List<String> date_ = <String>[];
  List<String> reply_ = <String>[];

  Future<void> view_complaint_reply() async {
    List<String> id = <String>[];
    List<String> complaint = <String>[];
    List<String> date = <String>[];
    List<String> reply = <String>[];

    try {
      final pref = await SharedPreferences.getInstance();
      String lid = pref.getString("lid").toString();
      String ip = pref.getString("url").toString();

      String url = ip + "viewcomplaint";
      print(url);
      var data = await http.post(Uri.parse(url), body: {
        'lid': lid,
      });

      var jsondata = json.decode(data.body);
      String status = jsondata['status'];

      var arr = jsondata["data"];
      print(arr);
      print(arr.length);

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id'].toString());
        complaint.add(arr[i]['complaint'].toString());
        date.add(arr[i]['date'].toString());
        reply.add(arr[i]['reply'].toString());
      }

      setState(() {
        id_ = id;
        complaint_ = complaint;
        date_ = date;
        reply_ = reply;
      });

      // If the status is appointment canceled, show the message
      if (status == 'appointment_canceled') {
        // Show a SnackBar to notify the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Appointment Canceled')),
        );

        // Alternatively, show a BottomSheet
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                color: Colors.redAccent,
                height: 80,
                child: Center(
                  child: Text(
                    'Appointment Canceled',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }

    } catch (e) {
      print("Error ------------------- " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "View All Complaints",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: id_.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(Icons.warning, "Complaint", complaint_[index]),
                    SizedBox(height: 10),
                    _buildInfoRow(Icons.date_range, "Date", date_[index]),
                    SizedBox(height: 10),
                    _buildInfoRow(Icons.reply, "Reply", reply_[index]),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the SendComplaint page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SendComplaint()),
          );
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.blue),
        SizedBox(width: 10),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              SizedBox(height: 5),
              Text(
                value,
                style: TextStyle(fontSize: 14, color: Colors.black87),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
