// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ViewSchedules extends StatefulWidget {
//   const ViewSchedules({Key? key, required this.title}) : super(key: key);
//
//   final String title;
//
//   @override
//   State<ViewSchedules> createState() => _ViewSchedules();
// }
//
// class _ViewSchedules extends State<ViewSchedules> {
//   int _counter = 0;
//
//   _ViewSchedules() {
//     view_schedule();
//   }
//
//   List<String> id_ = <String>[]; // Schedule ID
//   List<String> fid_ = <String>[]; // From Time
//   List<String> tid_ = <String>[]; // To Time
//   List<String> date_ = <String>[]; // Date
//
//   Future<void> view_schedule() async {
//     List<String> id = <String>[];
//     List<String> fid = <String>[];
//     List<String> tid = <String>[];
//     List<String> date = <String>[];
//
//     try {
//       final pref = await SharedPreferences.getInstance();
//       String ip = pref.getString("url") ?? ''; // Default to empty string if null
//       String doctorId = pref.getString("doctor_id") ?? ''; // Get the doctor_id from SharedPreferences
//
//       String url = ip + "view_schedule";
//       print(url);
//       var data = await http.post(Uri.parse(url), body: {
//         'doctor_id': doctorId, // Pass the doctor_id in the request
//       });
//
//       var jsondata = json.decode(data.body);
//       String status = jsondata['status'] ?? 'error'; // Default to 'error' if 'status' is missing
//       var arr = jsondata['data'] ?? [];
//
//       print(arr);
//       print(arr.length);
//
//       for (int i = 0; i < arr.length; i++) {
//         id.add(arr[i]['id'].toString());
//         fid.add(arr[i]['fid'].toString());
//         tid.add(arr[i]['tid'].toString());
//         date.add(arr[i]['date'].toString());
//       }
//
//       setState(() {
//         id_ = id;
//         fid_ = fid;
//         tid_ = tid;
//         date_ = date;
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
//
//
//   Future<void> bookAppointment(String scheduleId) async {
//     final pref = await SharedPreferences.getInstance();
//     String ip = pref.getString("url") ?? ''; // Get the base URL
//     String lid = pref.getString("lid") ?? '';
//
//     String url = ip + "user_booking";
//
//     try {
//       var response = await http.post(Uri.parse(url), body: {
//         'lid': lid,
//         'sid': scheduleId,
//       });
//
//       var responseData = json.decode(response.body);
//       String status = responseData['status'] ?? 'error';
//
//       if (status == "ok") {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Appointment booked successfully!")),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Already booked.")),
//         );
//       }
//     } catch (e) {
//       print("Error while booking appointment: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: Could not book appointment.")),
//       );
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "View All Schedules",
//           style: TextStyle(color: Colors.black),
//         ),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: ListView.builder(
//         physics: BouncingScrollPhysics(),
//         itemCount: id_.length,
//         itemBuilder: (BuildContext context, int index) {
//           return ListTile(
//             onLongPress: () {
//               print("long press" + index.toString());
//             },
//             title: Padding(
//               padding: const EdgeInsets.all(4.0),
//               child: Column(
//                 children: [
//                   Container(
//                     width: MediaQuery.of(context).size.width,
//                     height: 200, // Increased height for the button
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
//                                 child: Row(children: [Text("From Time")]),
//                               ),
//                               Flexible(
//                                 flex: 3,
//                                 fit: FlexFit.loose,
//                                 child: Row(children: [Text(fid_[index])]),
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
//                                 child: Row(children: [Text("To Time")]),
//                               ),
//                               Flexible(
//                                 flex: 3,
//                                 fit: FlexFit.loose,
//                                 child: Row(children: [Text(tid_[index])]),
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
//                                 child: Row(children: [Text("Date")]),
//                               ),
//                               Flexible(
//                                 flex: 3,
//                                 fit: FlexFit.loose,
//                                 child: Row(children: [Text(date_[index])]),
//                               ),
//                             ],
//                           ),
//                           Spacer(),
//                           ElevatedButton(
//                             onPressed: () {
//                               bookAppointment(id_[index]);
//                             },
//                             child: Text("Book Appointment"),
//                           ),
//
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
//     );
//   }
// }


import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewSchedules extends StatefulWidget {
  const ViewSchedules({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ViewSchedules> createState() => _ViewSchedules();
}

class _ViewSchedules extends State<ViewSchedules> {
  List<String> id_ = <String>[]; // Schedule ID
  List<String> fid_ = <String>[]; // From Time
  List<String> tid_ = <String>[]; // To Time
  List<String> date_ = <String>[]; // Date

  @override
  void initState() {
    super.initState();
    view_schedule();
  }

  Future<void> view_schedule() async {
    List<String> id = <String>[];
    List<String> fid = <String>[];
    List<String> tid = <String>[];
    List<String> date = <String>[];

    try {
      final pref = await SharedPreferences.getInstance();
      String ip = pref.getString("url") ?? ''; // Default to empty string if null
      String doctorId = pref.getString("doctor_id") ?? ''; // Get the doctor_id from SharedPreferences

      String url = ip + "view_schedule";
      var data = await http.post(Uri.parse(url), body: {
        'doctor_id': doctorId, // Pass the doctor_id in the request
      });

      var jsondata = json.decode(data.body);
      var arr = jsondata['data'] ?? [];

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id'].toString());
        fid.add(arr[i]['fid'].toString());
        tid.add(arr[i]['tid'].toString());
        date.add(arr[i]['date'].toString());
      }

      setState(() {
        id_ = id;
        fid_ = fid;
        tid_ = tid;
        date_ = date;
      });
    } catch (e) {
      print("Error ------------------- " + e.toString());
    }
  }

  Future<void> bookAppointment(String scheduleId) async {
    final pref = await SharedPreferences.getInstance();
    String ip = pref.getString("url") ?? ''; // Get the base URL
    String lid = pref.getString("lid") ?? '';

    String url = ip + "user_booking";

    try {
      var response = await http.post(Uri.parse(url), body: {
        'lid': lid,
        'sid': scheduleId,
      });

      var responseData = json.decode(response.body);
      String status = responseData['status'] ?? 'error';

      if (status == "ok") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Appointment booked successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Already booked.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: Could not book appointment.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
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
                    _buildInfoRow(Icons.access_time, "From Time", fid_[index]),
                    SizedBox(height: 10),
                    _buildInfoRow(Icons.access_time, "To Time", tid_[index]),
                    SizedBox(height: 10),
                    _buildInfoRow(Icons.date_range, "Date", date_[index]),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onPressed: () {
                          bookAppointment(id_[index]);
                        },
                        child: Text("Book Appointment"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
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
