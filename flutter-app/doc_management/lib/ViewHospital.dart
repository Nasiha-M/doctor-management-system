import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ViewDoctor.dart';

class ViewHospital extends StatefulWidget {
  const ViewHospital({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ViewHospital> createState() => _ViewHospital();
}

class _ViewHospital extends State<ViewHospital> {
  _ViewHospital() {
    view_hospital();
  }

  List<String> id_ = <String>[];
  List<String> hospital_name_ = <String>[];
  List<String> place_ = <String>[];
  List<String> pin_ = <String>[];
  List<String> phone_ = <String>[];
  List<String> email_ = <String>[];
  List<String> image_url_ = <String>[]; // New list to store image URLs

  Future<void> view_hospital() async {
    List<String> id = <String>[];
    List<String> hospital_name = <String>[];
    List<String> place = <String>[];
    List<String> pin = <String>[];
    List<String> phone = <String>[];
    List<String> email = <String>[];
    List<String> image_url = <String>[]; // New list to store image URLs

    try {
      final pref = await SharedPreferences.getInstance();
      String lid = pref.getString("lid").toString();
      String ip = pref.getString("url").toString();

      String url = ip + "view_hospital";
      print(url);

      var data = await http.post(Uri.parse(url), body: {'lid': lid});
      var jsondata = json.decode(data.body);
      String status = jsondata['status'];

      var arr = jsondata["data"];
      print(arr);

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id'].toString());
        hospital_name.add(arr[i]['hospital_name'].toString());
        place.add(arr[i]['place'].toString());
        pin.add(arr[i]['pin'].toString());
        phone.add(arr[i]['phone'].toString());
        email.add(arr[i]['email'].toString());
        image_url.add(pref.getString("imgurl").toString()+arr[i]['image_url'].toString()); // Store image URL
      }

      setState(() {
        id_ = id;
        hospital_name_ = hospital_name;
        place_ = place;
        pin_ = pin;
        phone_ = phone;
        email_ = email;
        image_url_ = image_url; // Update image URL list
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
          "View All Hospitals",
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
                    image_url_[index].isNotEmpty
                        ? Image.network(
                      image_url_[index],
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                        : Container(), // Empty container if no image URL
                    SizedBox(height: 10),
                    _buildInfoRow(Icons.local_hospital, "Hospital Name", hospital_name_[index]),
                    SizedBox(height: 10),
                    _buildInfoRow(Icons.location_on, "Place", place_[index]),
                    SizedBox(height: 10),
                    _buildInfoRow(Icons.pin_drop, "Pin", pin_[index]),
                    SizedBox(height: 10),
                    _buildInfoRow(Icons.phone, "Phone", phone_[index]),
                    SizedBox(height: 10),
                    _buildInfoRow(Icons.email, "Email", email_[index]),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onPressed: () async {
                          final sh = await SharedPreferences.getInstance();
                          sh.setString("hosid", id_[index]);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewDoctor(title: ''),
                            ),
                          );
                          print("View Doctors for Hospital ID: ${id_[index]}");
                        },
                        child: Text("View Doctors"),
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
