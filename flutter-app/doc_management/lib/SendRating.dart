//
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
// import 'home.dart';
//
// class Rating extends StatefulWidget {
//   @override
//   _RatingState createState() => _RatingState();
// }
//
// class _RatingState extends State<Rating> {
//   final TextEditingController reviewController = TextEditingController();
//   double _rating = 0;
//
// // Function to send rating to a backend (replace with your implementation)
//   void _sendRating() {
// // Simulate sending rating to a backend
//     print("Rating: $_rating");
//
// // You can make API calls or store the rating data as needed.
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//
//       appBar:  AppBar(backgroundColor: Colors.black,
//         title: Text(
//           "Rating",
//           style: TextStyle(color: Colors.white),
//         ),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back,color: Colors.white,
//           ),
//           onPressed: () {
//             Navigator.pop(context, UserHome());
//           },
//         ),
//       ),
//       body: WillPopScope(
//         child: Center( //
// // Center content both vertically and horizontally
//           child:
//
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center, // Center content horizontally
//               mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
//               children: <Widget>[
//                 Text(
//                   "Rate the Doctor:",
//                   style: TextStyle(fontSize: 18),
//                 ),
//                 SizedBox(height: 10),
//                 RatingBar(
//                   initialRating: _rating,
//                   onRatingChanged: (newRating) {
//                     setState(() {
//                       _rating = newRating;
//                       print(_rating);
//                       print("oppppp");
//                     });
//                   },
//                 ),
//
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     _sendRating();
//                     showDialog(
//                       context: context,
//                       builder: (BuildContext context) {
//                         return AlertDialog(
//                           title: Text("Rating Submitted"),
//                           content: Text("Thank"
//                               "you for your rating!"),
//                           actions: [
//                             TextButton(
//                               onPressed: ()async {
//                                 final sh = await SharedPreferences.getInstance();
//                                 String url = sh.getString("url").toString();
//                                 String lid = sh.getString("lid").toString();
//                                 String did = sh.getString("did").toString();
//                                 // String review=reviewController.text.toString();
//                                 var data = await http.post(
//                                     Uri.parse(url+"send_rating"),
//                                     body: {'rating':_rating.toString(),
//                                       'lid':lid,
//                                       // 'did':did,
//                                       'did':sh.getString("doctor_id").toString(),
//
//                                     });
//                                 var jasondata = json.decode(data.body);
//                                 String status=jasondata['task'].toString();
//                                 if(status=="ok")
//                                 {
//
//                                   Navigator.push(context,
//                                       MaterialPageRoute(builder: (context) => UserHome()));
//
//                                 }
//                                 else{
//                                   print("error");
//
//                                 }
//                               },
//                               child: Text("OK"),
//                             ),
//                           ],
//                         );
//                       },
//                     );
//                   },
//                   child: Text("Submit Rating"),
//                 ),
//               ],
//             ),
//           ),
//         ),onWillPop: () async{
//         Navigator.push(context,
//             MaterialPageRoute(builder: (context) => UserHome()));
//         return true;
//       },
//       ),
//     );
//   }
// }
//
// class RatingBar extends StatelessWidget {
//   final double initialRating;
//   final ValueChanged<double> onRatingChanged;
//
//   RatingBar({required this.initialRating, required this.onRatingChanged});
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center, // Center the RatingBar horizontally
//       children: List.generate(5, (index) {
//         final filled = index < initialRating;
//         return GestureDetector(
//           onTap: () => onRatingChanged(index + 1.0),
//           child: Icon(
//             filled ? Icons.star : Icons.star_border,
//             size: 40,
//             color: Colors.amber,
//           ),
//         );
//       }),
//     );
//   }
// }
//

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';

class Rating extends StatefulWidget {
  @override
  _RatingState createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  final TextEditingController reviewController = TextEditingController();
  double _rating = 0;

  // Function to send rating to a backend (replace with your implementation)
  void _sendRating() {
    // Simulate sending rating to a backend
    print("Rating: $_rating");

    // You can make API calls or store the rating data as needed.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Rate the Doctor",
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
      body: WillPopScope(
        onWillPop: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserHome()),
          );
          return true;
        },
        child: Center( // Center the entire body content
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Vertically center
              crossAxisAlignment: CrossAxisAlignment.center, // Horizontally center
              children: [
                Text(
                  "Rate the Doctor:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                RatingBar(
                  initialRating: _rating,
                  onRatingChanged: (newRating) {
                    setState(() {
                      _rating = newRating;
                      print(_rating);
                    });
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    _sendRating();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Rating Submitted"),
                          content: Text("Thank you for your rating!"),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                final sh = await SharedPreferences.getInstance();
                                String url = sh.getString("url").toString();
                                String lid = sh.getString("lid").toString();
                                String did = sh.getString("did").toString();
                                var data = await http.post(
                                  Uri.parse(url + "send_rating"),
                                  body: {
                                    'rating': _rating.toString(),
                                    'lid': lid,
                                    'did': sh.getString("doctor_id").toString(),
                                  },
                                );
                                var jsonData = json.decode(data.body);
                                String status = jsonData['task'].toString();
                                if (status == "ok") {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UserHome()),
                                  );
                                } else {
                                  print("Error: Unable to submit rating");
                                }
                              },
                              child: Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text("Submit Rating"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RatingBar extends StatelessWidget {
  final double initialRating;
  final ValueChanged<double> onRatingChanged;

  RatingBar({required this.initialRating, required this.onRatingChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final filled = index < initialRating;
        return GestureDetector(
          onTap: () => onRatingChanged(index + 1.0),
          child: Icon(
            filled ? Icons.star : Icons.star_border,
            size: 40,
            color: Colors.amber,
          ),
        );
      }),
    );
  }
}
