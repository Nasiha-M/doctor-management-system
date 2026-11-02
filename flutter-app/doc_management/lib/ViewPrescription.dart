// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ViewPrescription extends StatefulWidget {
//   const ViewPrescription({Key? key, required this.title}) : super(key: key);
//
//   final String title;
//
//   @override
//   State<ViewPrescription> createState() => _ViewPrescription();
// }
//
// class _ViewPrescription extends State<ViewPrescription> {
//   _ViewPrescription() {
//     view_userprescription();
//   }
//
//   List<String> id_ = <String>[];
//   List<String> doctor_ = <String>[];
//   List<String> date_ = <String>[];
//   List<String> prescription_ = <String>[];
//   List<String> report_ = <String>[];
//   List<String> file_ = <String>[]; // New list to store image URLs
//
//   Future<void> view_userprescription() async {
//     List<String> id = <String>[];
//     List<String> doctor = <String>[];
//     List<String> date = <String>[];
//     List<String> prescription = <String>[];
//     List<String> report = <String>[];
//     List<String> file = <String>[]; // New list to store image URLs
//
//     try {
//       final pref = await SharedPreferences.getInstance();
//       String lid = pref.getString("lid").toString();
//       String ip = pref.getString("url").toString();
//
//       String url = ip + "view_userprescription";
//       print(url);
//
//       var data = await http.post(Uri.parse(url), body: {'lid': lid});
//       var jsondata = json.decode(data.body);
//       String status = jsondata['status'];
//
//       var arr = jsondata["data"];
//       print(arr);
//
//       for (int i = 0; i < arr.length; i++) {
//         id.add(arr[i]['id'].toString());
//         doctor.add(arr[i]['doctor'].toString());
//         date.add(arr[i]['date'].toString());
//         prescription.add(arr[i]['prescription'].toString());
//         report.add(arr[i]['report'].toString());
//         file.add(pref.getString("imgurl").toString()+arr[i]['file'].toString()); // Store image URL
//       }
//
//       setState(() {
//         id_ = id;
//         doctor_ = doctor;
//         date_ = date;
//         prescription_ = prescription;
//         report_ = report;
//         file_ = file; // Update image URL list
//       });
//
//       print("Loaded ${id_.length} hospitals.");
//       print("Status: $status");
//     } catch (e) {
//       print("Error: ${e.toString()}");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "View All Prescriptions",
//           style: TextStyle(color: Colors.white),
//         ),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () {
//             Navigator.pop(context);
//             print("Back button pressed");
//           },
//         ),
//         backgroundColor: Colors.blue,
//       ),
//       body: ListView.builder(
//         physics: BouncingScrollPhysics(),
//         itemCount: id_.length,
//         itemBuilder: (BuildContext context, int index) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//             child: Card(
//               elevation: 6,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(15.0),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(15.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Image display
//                     file_[index].isNotEmpty
//                         ? Image.network(
//                       file_[index],
//                       height: 150,
//                       width: double.infinity,
//                       fit: BoxFit.cover,
//                     )
//                         : Container(), // Empty container if no image URL
//                     SizedBox(height: 10),
//                     _buildInfoRow(Icons.local_hospital, "Doctor Name", doctor_[index]),
//                     SizedBox(height: 10),
//                     _buildInfoRow(Icons.location_on, "Date", date_[index]),
//                     SizedBox(height: 10),
//                     _buildInfoRow(Icons.pin_drop, "Prescription", prescription_[index]),
//                     SizedBox(height: 10),
//                     _buildInfoRow(Icons.report, "Report", report_[index]),
//                     SizedBox(height: 20),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildInfoRow(IconData icon, String label, String value) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Icon(icon, color: Colors.blue),
//         SizedBox(width: 10),
//         Flexible(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//               ),
//               SizedBox(height: 5),
//               Text(
//                 value,
//                 style: TextStyle(fontSize: 14, color: Colors.black87),
//                 overflow: TextOverflow.ellipsis,
//                 maxLines: 2,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }


import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewPrescription extends StatefulWidget {
  const ViewPrescription({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ViewPrescription> createState() => _ViewPrescription();
}

class _ViewPrescription extends State<ViewPrescription> {
  _ViewPrescription() {
    view_userprescription();
  }

  List<String> id_ = <String>[];
  List<String> doctor_ = <String>[];
  List<String> date_ = <String>[];
  List<String> prescription_ = <String>[];
  List<String> report_ = <String>[];
  List<String> file_ = <String>[]; // New list to store image URLs

  Future<void> view_userprescription() async {
    List<String> id = <String>[];
    List<String> doctor = <String>[];
    List<String> date = <String>[];
    List<String> prescription = <String>[];
    List<String> report = <String>[];
    List<String> file = <String>[]; // New list to store image URLs

    try {
      final pref = await SharedPreferences.getInstance();
      String lid = pref.getString("lid").toString();
      String ip = pref.getString("url").toString();

      String url = ip + "view_userprescription";
      print(url);

      var data = await http.post(Uri.parse(url), body: {'lid': lid});
      var jsondata = json.decode(data.body);
      String status = jsondata['status'];

      var arr = jsondata["data"];
      print(arr);

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id'].toString());
        doctor.add(arr[i]['doctor'].toString());
        date.add(arr[i]['date'].toString());
        prescription.add(arr[i]['prescription'].toString());
        report.add(arr[i]['report'].toString());
        file.add(pref.getString("imgurl").toString() + arr[i]['file'].toString()); // Store image URL
      }

      setState(() {
        id_ = id;
        doctor_ = doctor;
        date_ = date;
        prescription_ = prescription;
        report_ = report;
        file_ = file; // Update image URL list
      });

      print("Loaded ${id_.length} hospitals.");
      print("Status: $status");
    } catch (e) {
      print("Error: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "View All Prescriptions",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
            print("Back button pressed");
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
                    // Image display
                    file_[index].isNotEmpty
                        ? Image.network(
                      file_[index],
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                        : Container(), // Empty container if no image URL
                    SizedBox(height: 10),
                    _buildInfoRow(Icons.person, "Doctor Name", doctor_[index]),
                    SizedBox(height: 10),
                    _buildInfoRow(Icons.calendar_today, "Date", date_[index]),
                    SizedBox(height: 10),
                    _buildInfoRow(Icons.description, "Prescription", prescription_[index]),
                    SizedBox(height: 10),
                    _buildInfoRow(Icons.assignment, "Report", report_[index]),
                    SizedBox(height: 20),
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
