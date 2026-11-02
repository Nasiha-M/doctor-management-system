// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'SendRating.dart';
// import 'ViewSchedule.dart';
//
// class ViewDoctor extends StatefulWidget {
//   const ViewDoctor({Key? key, required this.title}) : super(key: key);
//
//   final String title;
//
//   @override
//   State<ViewDoctor> createState() => _ViewDoctor();
// }
//
// class _ViewDoctor extends State<ViewDoctor> {
//   int _counter = 0;
//
//   _ViewDoctor() {
//     view_doctor();
//   }
//
//   List<String> id_ = <String>[];
//   List<String> name_ = <String>[];
//   List<String> age_ = <String>[];
//   List<String> department_ = <String>[];
//   List<String> experience_ = <String>[];
//   List<String> phone_ = <String>[];
//   List<String> email_ = <String>[];
//
//   Future<void> view_doctor() async {
//     List<String> id = <String>[];
//     List<String> name = <String>[];
//     List<String> age = <String>[];
//     List<String> department = <String>[];
//     List<String> experience = <String>[];
//     List<String> phone = <String>[];
//     List<String> email = <String>[];
//
//     try {
//       final pref = await SharedPreferences.getInstance();
//       String lid = pref.getString("lid").toString();
//       String ip = pref.getString("url").toString();
//       String url = ip + "userview_doctor";
//       print(url);
//       var data = await http.post(Uri.parse(url), body: {
//         'lid': lid,
//         'hosid': pref.getString("hosid").toString()
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
//         name.add(arr[i]['name'].toString());
//         age.add(arr[i]['age'].toString());
//         department.add(arr[i]['department'].toString());
//         experience.add(arr[i]['experience'].toString());
//         phone.add(arr[i]['phone'].toString());
//         email.add(arr[i]['email'].toString());
//       }
//
//       setState(() {
//         id_ = id;
//         name_ = name;
//         age_ = age;
//         department_ = department;
//         experience_ = experience;
//         phone_ = phone;
//         email_ = email;
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
//           "View All Doctors",
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
//                                 child: Row(children: [Text("Doctor Name")]),
//                               ),
//                               Flexible(
//                                 flex: 3,
//                                 fit: FlexFit.loose,
//                                 child: Row(children: [Text(name_[index])]),
//                               )
//                             ],
//                           ),
//                           SizedBox(height: 16),
//                           Row(
//                             children: [
//                               SizedBox(width: 10),
//                               Flexible(
//                                 flex: 2,
//                                 fit: FlexFit.loose,
//                                 child: Row(children: [Text("Age")]),
//                               ),
//                               Flexible(
//                                 flex: 3,
//                                 fit: FlexFit.loose,
//                                 child: Row(children: [Text(age_[index])]),
//                               )
//                             ],
//                           ),
//                           SizedBox(height: 16),
//                           Row(
//                             children: [
//                               SizedBox(width: 10),
//                               Flexible(
//                                 flex: 2,
//                                 fit: FlexFit.loose,
//                                 child: Row(children: [Text("Department")]),
//                               ),
//                               Flexible(
//                                 flex: 3,
//                                 fit: FlexFit.loose,
//                                 child: Row(children: [Text(department_[index])]),
//                               )
//                             ],
//                           ),
//                           SizedBox(height: 16),
//                           Row(
//                             children: [
//                               SizedBox(width: 10),
//                               Flexible(
//                                 flex: 2,
//                                 fit: FlexFit.loose,
//                                 child: Row(children: [Text("Experience")]),
//                               ),
//                               Flexible(
//                                 flex: 3,
//                                 fit: FlexFit.loose,
//                                 child: Row(children: [Text(experience_[index])]),
//                               )
//                             ],
//                           ),
//                           SizedBox(height: 16),
//                           Row(
//                             children: [
//                               SizedBox(width: 10),
//                               Flexible(
//                                 flex: 2,
//                                 fit: FlexFit.loose,
//                                 child: Row(children: [Text("Phone")]),
//                               ),
//                               Flexible(
//                                 flex: 3,
//                                 fit: FlexFit.loose,
//                                 child: Row(children: [Text(phone_[index])]),
//                               )
//                             ],
//                           ),
//                           SizedBox(height: 16),
//                           Row(
//                             children: [
//                               SizedBox(width: 10),
//                               Flexible(
//                                 flex: 2,
//                                 fit: FlexFit.loose,
//                                 child: Row(children: [Text("Email")]),
//                               ),
//                               Flexible(
//                                 flex: 3,
//                                 fit: FlexFit.loose,
//                                 child: Row(children: [Text(email_[index])]),
//                               )
//                             ],
//                           ),
//                           SizedBox(height: 16),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: [
//                                 ElevatedButton(
//                                   onPressed: () async {
//                                     final sh = await SharedPreferences.getInstance();
//                                     sh.setString("doctor_id", id_[index].toString());
//
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) =>
//                                             ViewSchedules(title: ''),
//                                       ),
//                                     );
//                                   },
//                                   child: Text("View Schedule"),
//                                 ),
//                                 ElevatedButton(
//                                   onPressed: () async {
//                                     final sh = await SharedPreferences.getInstance();
//                                     sh.setString("doctor_id", id_[index].toString());
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(builder: (context) => Rating()),
//                                     );
//                                   },
//                                   child: Text("Send Rating"),
//                                 ),
//                               ],
//                             ),
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
//     );
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ViewSchedule.dart';
import 'SendRating.dart';

class ViewDoctor extends StatefulWidget {
  const ViewDoctor({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ViewDoctor> createState() => _ViewDoctor();
}

class _ViewDoctor extends State<ViewDoctor> {
  List<String> id_ = <String>[];
  List<String> name_ = <String>[];
  List<String> age_ = <String>[];
  List<String> department_ = <String>[];
  List<String> experience_ = <String>[];
  List<String> phone_ = <String>[];
  List<String> email_ = <String>[];
  List<String> image_url_ = <String>[]; // List to store image URLs

  Future<void> view_doctor() async {
    List<String> id = <String>[];
    List<String> name = <String>[];
    List<String> age = <String>[];
    List<String> department = <String>[];
    List<String> experience = <String>[];
    List<String> phone = <String>[];
    List<String> email = <String>[];
    List<String> image_url = <String>[]; // List to store image URLs

    try {
      final pref = await SharedPreferences.getInstance();
      String lid = pref.getString("lid").toString();
      String ip = pref.getString("url").toString();
      String url = ip + "userview_doctor";
      var data = await http.post(Uri.parse(url), body: {
        'lid': lid,
        'hosid': pref.getString("hosid").toString()
      });

      var jsondata = json.decode(data.body);
      String status = jsondata['status'];
      var arr = jsondata["data"];

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id'].toString());
        name.add(arr[i]['name'].toString());
        age.add(arr[i]['age'].toString());
        department.add(arr[i]['department'].toString());
        experience.add(arr[i]['experience'].toString());
        phone.add(arr[i]['phone'].toString());
        email.add(arr[i]['email'].toString());
        image_url.add(pref.getString("imgurl").toString() + arr[i]['image_url'].toString()); // Store image URL
      }

      setState(() {
        id_ = id;
        name_ = name;
        age_ = age;
        department_ = department;
        experience_ = experience;
        phone_ = phone;
        email_ = email;
        image_url_ = image_url; // Update image URL list
      });
    } catch (e) {
      print("Error ------------------- " + e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    view_doctor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "View All Doctors",
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
                    // Display the doctor's image
                    Center(
                      child: image_url_[index] != ''
                          ? ClipOval(
                        child: Image.network(
                          image_url_[index],
                          height: 120, // Image height
                          width: 120,  // Image width
                          fit: BoxFit.cover, // Ensures the image fits within the circular bounds
                        ),
                      )
                          : ClipOval(
                        child: Icon(Icons.person, size: 120), // Default icon if no image
                      ),
                    ),
                    SizedBox(height: 10),
                    _buildInfoRow(Icons.person, "Doctor Name", name_[index]),
                    SizedBox(height: 10),
                    _buildInfoRow(Icons.cake, "Age", age_[index]),
                    SizedBox(height: 10),
                    _buildInfoRow(Icons.medical_services, "Department", department_[index]),
                    SizedBox(height: 10),
                    _buildInfoRow(Icons.access_time, "Experience", experience_[index]),
                    SizedBox(height: 10),
                    _buildInfoRow(Icons.phone, "Phone", phone_[index]),
                    SizedBox(height: 10),
                    _buildInfoRow(Icons.email, "Email", email_[index]),
                    SizedBox(height: 20),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildButton("View Schedule", Colors.blue, () async {
                            final sh = await SharedPreferences.getInstance();
                            sh.setString("doctor_id", id_[index]);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewSchedules(title: ''),
                              ),
                            );
                          }),
                          _buildButton("Send Rating", Colors.orangeAccent, () async {
                            final sh = await SharedPreferences.getInstance();
                            sh.setString("doctor_id", id_[index]);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Rating()),
                            );
                          }),
                        ],
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

  Widget _buildButton(String label, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: color,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onPressed,
      child: Text(label, style: TextStyle(fontSize: 16)),
    );
  }
}
