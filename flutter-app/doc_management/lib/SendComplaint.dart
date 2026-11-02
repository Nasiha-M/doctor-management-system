// import 'dart:convert';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// class SendComplaint extends StatefulWidget {
//   const SendComplaint({super.key});
//
//   @override
//   State<SendComplaint> createState() => _SendComplaintState();
// }
//
// class _SendComplaintState extends State<SendComplaint> {
//   final TextEditingController _descriptionController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//
//   Future<void> _submitComplaint() async {
//     if (_formKey.currentState?.validate() ?? false) {
//       try {
//         final sh = await SharedPreferences.getInstance();
//         String? url = sh.getString("url");
//         String? lid = sh.getString("lid");
//
//         if (url == null || lid == null) {
//           Fluttertoast.showToast(
//               msg: "Error: Missing server URL or login ID.",
//               backgroundColor: Colors.red);
//           return;
//         }
//
//         String complaint = _descriptionController.text.trim();
//         // var response = await http.post(
//         //   Uri.parse('$url'+'sendcomplaint'),
//         //   body: {'complaint': complaint, 'lid': lid},
//         // );
//         var response = await http.post(
//           Uri.parse('$url'+'sendcomplaint'),
//           body: {
//             'complaint': complaint,
//             'lid': lid,
//           },
//         );
//
//         if (response.statusCode == 200) {
//           var jsonData = json.decode(response.body);
//           String status = jsonData['task'].toString();
//
//           if (status == "ok") {
//             Fluttertoast.showToast(
//                 msg: "Complaint submitted successfully!",
//                 backgroundColor: Colors.green);
//           } else {
//             Fluttertoast.showToast(
//                 msg: "Failed to submit complaint. Try again.",
//                 backgroundColor: Colors.red);
//           }
//         } else {
//           Fluttertoast.showToast(
//               msg: "Server error: ${response.statusCode}",
//               backgroundColor: Colors.red);
//         }
//       } catch (e) {
//         Fluttertoast.showToast(
//             msg: "An error occurred: $e", backgroundColor: Colors.red);
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Send Complaint'),
//         backgroundColor: Colors.blue,
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 TextFormField(
//                   controller: _descriptionController,
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     labelText: "Complaint",
//                     hintText: "Enter your complaint",
//                   ),
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return "Please enter a valid complaint.";
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton.icon(
//                   onPressed: _submitComplaint,
//                   icon: const Icon(Icons.send),
//                   label: const Text("Submit"),
//                   style: ElevatedButton.styleFrom(
//                     primary: Colors.amber,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }




import 'dart:convert';
import 'package:doc_management/ViewComplaintReply.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SendComplaint extends StatefulWidget {
  const SendComplaint({super.key});

  @override
  State<SendComplaint> createState() => _SendComplaintState();
}

class _SendComplaintState extends State<SendComplaint> {
  final TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _submitComplaint() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final sh = await SharedPreferences.getInstance();
        String? url = sh.getString("url");
        String? lid = sh.getString("lid");

        if (url == null || lid == null) {
          Fluttertoast.showToast(
              msg: "Error: Missing server URL or login ID.",
              backgroundColor: Colors.red);
          return;
        }

        String complaint = _descriptionController.text.trim();
        var response = await http.post(
          Uri.parse('$url' + 'sendcomplaint'),
          body: {
            'complaint': complaint,
            'lid': lid,
          },
        );

        if (response.statusCode == 200) {
          var jsonData = json.decode(response.body);
          String status = jsonData['task'].toString();

          if (status == "ok") {
            Fluttertoast.showToast(
                msg: "Complaint submitted successfully!",
                backgroundColor: Colors.green);
            Navigator.push(context, MaterialPageRoute(builder: (context) => ViewComplaintReply(title: '',)));

          } else {
            Fluttertoast.showToast(
                msg: "Failed to submit complaint. Try again.",
                backgroundColor: Colors.red);
          }
        } else {
          Fluttertoast.showToast(
              msg: "Server error: ${response.statusCode}",
              backgroundColor: Colors.red);
        }
      } catch (e) {
        Fluttertoast.showToast(
            msg: "An error occurred: $e", backgroundColor: Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Send Complaint',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 5,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Submit your complaint below:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    labelText: "Complaint",
                    hintText: "Enter your complaint",
                    contentPadding: EdgeInsets.all(16),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter a valid complaint.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _submitComplaint,
                  icon: const Icon(Icons.send, size: 20),
                  label: const Text("Submit"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.amberAccent,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
