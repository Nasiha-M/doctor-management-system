import 'dart:convert';
import 'package:doc_management/Home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'Registration.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50], // Light background color
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Welcome Back!",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: "Username",
                        prefixIcon: const Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: "Password",
                        prefixIcon: const Icon(Icons.lock),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpForm()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text("Register", style: TextStyle(color: Colors.white)),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final sh = await SharedPreferences.getInstance();
                            String Uname = usernameController.text.trim();
                            String Passwd = passwordController.text.trim();
                            String url = sh.getString("url").toString();

                            var data = await http.post(
                              Uri.parse(url + "logincode"),
                              body: {
                                'username': Uname,
                                "password": Passwd,
                              },
                            );

                            var jsonData = json.decode(data.body);
                            String status = jsonData['task'].toString();
                            String type = jsonData['type'].toString();

                            if (status == "valid") {
                              if (type == 'user') {
                                String lid = jsonData['lid'].toString();
                                sh.setString("lid", lid);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => UserHome()),
                                );
                              } else {
                                print("Invalid user type");
                              }
                            } else {
                              print("Invalid credentials");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text("Login", style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
