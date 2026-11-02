
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewCancelBooking extends StatefulWidget {
  const ViewCancelBooking({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ViewCancelBooking> createState() => _ViewCancelBooking();
}

class _ViewCancelBooking extends State<ViewCancelBooking> {
  int _counter = 0;

  _ViewCancelBooking() {
    view_cancel_booking();
  }

  List<String> id_ = <String>[];
  List<String> doctor_ = <String>[];
  List<String> fid_ = <String>[];
  List<String> tid_ = <String>[];
  List<String> date_ = <String>[];

  Future<void> view_cancel_booking() async {
    List<String> id = <String>[];
    List<String> doctor = <String>[];
    List<String> fid = <String>[];
    List<String> tid = <String>[];
    List<String> date = <String>[];

    try {
      final pref = await SharedPreferences.getInstance();
      String lid = pref.getString("lid").toString();
      String ip = pref.getString("url").toString();

      String url = ip + "view_userbooking";
      print(url);
      var data = await http.post(Uri.parse(url), body: {
        'lid': lid,
      });

      var jsondata = json.decode(data.body);
      String status = jsondata['status'];

      var arr = jsondata["data"];
      print(arr);

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id'].toString());
        doctor.add(arr[i]['doctor'].toString());
        fid.add(arr[i]['fid'].toString());
        tid.add(arr[i]['tid'].toString());
        date.add(arr[i]['date'].toString());
      }

      setState(() {
        id_ = id;
        doctor_ = doctor;
        fid_ = fid;
        tid_ = tid;
        date_ = date;
      });
    } catch (e) {
      print("Error ------------------- " + e.toString());
    }
  }

  Future<void> cancelAppointment(String bookingId) async {
    try {
      final pref = await SharedPreferences.getInstance();
      String ip = pref.getString("url").toString(); // Base API URL

      String url = ip + "cancel_booking"; // Cancel API endpoint
      var response = await http.post(Uri.parse(url), body: {
        'did': bookingId, // Sending booking ID to backend
      });

      var jsonResponse = json.decode(response.body);
      String status = jsonResponse['status'];

      if (status == 'success') {
        // Update UI
        setState(() {
          id_.remove(bookingId);
          int index = id_.indexOf(bookingId);
          doctor_.removeAt(index);
          fid_.removeAt(index);
          tid_.removeAt(index);
          date_.removeAt(index);
        });
        print("Appointment cancelled successfully.");
      } else {
        print("Failed to cancel appointment: ${jsonResponse['message']}");
      }
    } catch (e) {
      print("Error while cancelling appointment: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "View All Bookings",
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
                    _buildInfoRow(Icons.person, "Doctor", doctor_[index]),
                    SizedBox(height: 10),
                    _buildInfoRow(Icons.access_time, "From Time", fid_[index]),
                    SizedBox(height: 10),
                    _buildInfoRow(Icons.access_time, "To Time", tid_[index]),
                    SizedBox(height: 10),
                    _buildInfoRow(Icons.calendar_today, "Date", date_[index]),
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
                          cancelAppointment(id_[index]); // Pass the booking ID to cancel
                        },
                        child: Text("Cancel Appointment"),
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
