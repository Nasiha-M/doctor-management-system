import 'package:doc_management/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ippage extends StatefulWidget {
  const ippage({super.key});

  @override
  State<ippage> createState() => _ippageState();
}

class _ippageState extends State<ippage> {
  final TextEditingController ipController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text('Ippage'),),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(2),
                child: TextField(

                  controller: ipController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "IP Address",
                      hintText: "Enter a valid ip address"),


                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () async{

                    String ip=ipController.text.toString();
                    final sh = await SharedPreferences.getInstance();
                    sh.setString("url", "http://"+ip+":8000/");
                    sh.setString("imgurl", "http://"+ip+":8000");
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                  },
                  child: const Icon(Icons.key),

                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.amber, // Use a proper color value (e.g., Hex or RGB)
                    ),
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}