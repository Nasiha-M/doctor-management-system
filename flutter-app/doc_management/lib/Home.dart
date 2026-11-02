
import 'dart:convert';

import 'package:doc_management/DiseasePrediction.dart';
import 'package:doc_management/login.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ViewCancelBooking.dart';
import 'ViewComplaintReply.dart';
import 'ViewHospital.dart';
import 'ViewPrescription.dart';

import 'package:http/http.dart' as http;

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  String userName = "John Doe";
  String userEmail = "john.doe@example.com";
  String profileImageUrl = "https://via.placeholder.com/150";
  _UserHomeState(){
    view_profile();
  }
  Future<void> view_profile() async {
    try {
      Fluttertoast.showToast(msg: "Login Successfull");
      final pref = await SharedPreferences.getInstance();
      String lid = pref.getString("lid").toString();
      String ip = pref.getString("url").toString();
      String url = ip + "user_view_profile";
      var data = await http.post(Uri.parse(url), body: {

        'lid': pref.getString("lid").toString()
      });

      var jsondata = json.decode(data.body);
      String status = jsondata['status'];
      String name = jsondata['name'];
      String email = jsondata['email'];
      String photo = pref.getString("imgurl").toString()+jsondata['photo'];

      setState(() {
        userName = name;
        userEmail = email;
        profileImageUrl = photo;
      });
    } catch (e) {
      print("Error ------------------- " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50], // Light background color
      appBar: AppBar(
        title: const Text('User Home'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        automaticallyImplyLeading: false, // Removes the back button
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Add your logout functionality here
              // For example, you might want to navigate to a login screen:
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align everything left
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(profileImageUrl),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      userEmail,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              'App Features:',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                padding: const EdgeInsets.all(10),
                children: [
                  _buildFeatureButton('View Hospital', Icons.local_hospital, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ViewHospital(title: '',)));
                  }),
                  _buildFeatureButton('View Booking', Icons.calendar_today, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ViewCancelBooking(title: '',)));
                  }),
                  _buildFeatureButton('View Prescription', Icons.receipt_long, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ViewPrescription(title: '',)));
                  }),
                  _buildFeatureButton('Complaints & Reply', Icons.feedback, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ViewComplaintReply(title: '',)));
                  }),
                  _buildFeatureButton('Upload Symptoms', Icons.upload_file, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AVSymptomsPage()));
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureButton(String title, IconData icon, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 5,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
