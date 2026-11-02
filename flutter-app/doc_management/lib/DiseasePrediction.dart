// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// class AVSymptomsPage extends StatefulWidget {
//   @override
//   _AVSymptomsPageState createState() => _AVSymptomsPageState();
// }
//
// class _AVSymptomsPageState extends State<AVSymptomsPage> {
//   late SharedPreferences _prefs;
//   String ip = "";
//   List<String> symptoms = [];
//   List<String> selectedSymptoms = [];
//   String symptomString = "";
//   String disease = ""; // Store the predicted disease here
//
//   final _spinnerController = TextEditingController();
//   late Future<void> _fetchSymptoms;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchSymptoms = _loadData();
//   }
//
//   // Load shared preferences and get the IP address
//   Future<void> _loadData() async {
//     _prefs = await SharedPreferences.getInstance();
//     setState(() {
//       ip = _prefs.getString("url") ?? "";
//     });
//
//     await fetchSymptoms();
//   }
//
//   // Fetch symptoms from API
//   Future<void> fetchSymptoms() async {
//     final url = ip + "AV_symptoms";
//     try {
//       final response = await http.post(Uri.parse(url));
//       if (response.statusCode == 200) {
//         List<dynamic> data = json.decode(response.body);
//         setState(() {
//           symptoms = List<String>.from(data.map((item) => item['symptom']));
//         });
//       } else {
//         print("Error: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("Failed to load symptoms: $e");
//     }
//   }
//
//   // Submit the selected symptoms to the API
//   Future<void> submitSymptoms() async {
//     symptomString = selectedSymptoms.join('#');
//     final url = ip + "AV_symptoms1";
//
//     try {
//       final response = await http.post(Uri.parse(url), body: {'sym': symptomString});
//       if (response.statusCode == 200) {
//         var data = json.decode(response.body);
//         // Save disease information to shared preferences
//         _prefs.setString('disease', data['task']);
//         _prefs.setString('depid', data['did']);
//
//         // Update the disease on the same page
//         setState(() {
//           disease = data['task']; // Store the predicted disease
//         });
//       } else {
//         print("Error: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("Failed to submit symptoms: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Symptoms Selection")),
//       body: FutureBuilder<void>(
//         future: _fetchSymptoms,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//
//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Dropdown for selecting symptoms
//                 DropdownButton<String>(
//                   isExpanded: true,
//                   value: null,
//                   hint: Text('Select Symptom'),
//                   items: symptoms
//                       .map((symptom) => DropdownMenuItem(
//                     value: symptom,
//                     child: Text(symptom),
//                   ))
//                       .toList(),
//                   onChanged: (value) {
//                     if (value != null) {
//                       setState(() {
//                         selectedSymptoms.add(value);
//                       });
//                     }
//                   },
//                 ),
//                 SizedBox(height: 20),
//
//                 // List of selected symptoms
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: selectedSymptoms.length,
//                     itemBuilder: (context, index) {
//                       return ListTile(
//                         title: Text(selectedSymptoms[index]),
//                       );
//                     },
//                   ),
//                 ),
//                 SizedBox(height: 20),
//
//                 // Submit button
//                 ElevatedButton(
//                   onPressed: submitSymptoms,
//                   child: Text('Submit Symptoms'),
//                 ),
//
//                 SizedBox(height: 20),
//
//                 // Display the predicted disease
//                 if (disease.isNotEmpty)
//                   Text(
//                     "Predicted Disease: $disease",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
//                   ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AVSymptomsPage extends StatefulWidget {
  @override
  _AVSymptomsPageState createState() => _AVSymptomsPageState();
}

class _AVSymptomsPageState extends State<AVSymptomsPage> {
  late SharedPreferences _prefs;
  String ip = "";
  List<String> symptoms = [];
  List<String> selectedSymptoms = [];
  String symptomString = "";
  String disease = ""; // Store the predicted disease here

  final _spinnerController = TextEditingController();
  late Future<void> _fetchSymptoms;

  @override
  void initState() {
    super.initState();
    _fetchSymptoms = _loadData();
  }

  // Load shared preferences and get the IP address
  Future<void> _loadData() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      ip = _prefs.getString("url") ?? "";
    });

    await fetchSymptoms();
  }

  // Fetch symptoms from API
  Future<void> fetchSymptoms() async {
    final url = ip + "AV_symptoms";
    try {
      final response = await http.post(Uri.parse(url));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          symptoms = List<String>.from(data.map((item) => item['symptom']));
        });
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Failed to load symptoms: $e");
    }
  }

  // Submit the selected symptoms to the API
  Future<void> submitSymptoms() async {
    symptomString = selectedSymptoms.join('#');
    final url = ip + "AV_symptoms1";

    try {
      final response = await http.post(Uri.parse(url), body: {'sym': symptomString});
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        // Save disease information to shared preferences
        _prefs.setString('disease', data['task']);
        _prefs.setString('depid', data['did']);

        // Update the disease on the same page
        setState(() {
          disease = data['task']; // Store the predicted disease
        });
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Failed to submit symptoms: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Symptoms Selection",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<void>(
        future: _fetchSymptoms,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dropdown for selecting symptoms
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blueAccent, width: 1),
                  ),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: null,
                    hint: Text('Select Symptom'),
                    underline: SizedBox(),
                    items: symptoms
                        .map((symptom) => DropdownMenuItem(
                      value: symptom,
                      child: Text(symptom),
                    ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null && !selectedSymptoms.contains(value)) {
                        setState(() {
                          selectedSymptoms.add(value);
                        });
                      }
                    },
                  ),
                ),
                SizedBox(height: 20),

                // List of selected symptoms
                Expanded(
                  child: selectedSymptoms.isEmpty
                      ? Center(child: Text("No symptoms selected", style: TextStyle(color: Colors.grey)))
                      : ListView.builder(
                    itemCount: selectedSymptoms.length,
                    itemBuilder: (context, index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 3,
                        child: ListTile(
                          title: Text(
                            selectedSymptoms[index],
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                selectedSymptoms.removeAt(index);
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),

                // Submit button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: submitSymptoms,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      'Submit Symptoms',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Display the predicted disease
                if (disease.isNotEmpty)
                  Center(
                    child: Text(
                      "Predicted Disease: $disease",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
