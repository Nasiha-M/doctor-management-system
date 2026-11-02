import 'dart:convert';

import 'package:doc_management/login.dart';
import 'package:flutter/material.dart';


import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  TextEditingController firstnameController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController postController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  // String gender = 'male';
  bool _obscurePassword = true;




  final RegExp nameRegExp = RegExp(r'^[A-Za-z ]{2,25}$');
  final RegExp placeRegExp = RegExp(r'^[A-Za-z0-9 ]{2,25}$');
  final RegExp postRegExp = RegExp(r'^[A-Za-z0-9 ]{2,25}$');
  final RegExp pinRegExp = RegExp(r'^[0-9]{6}$');
  final RegExp emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,25}$');
  final RegExp _phoneReguser = RegExp(r'^[6789]\d{9}$');
  final RegExp UnameRegExp = RegExp(r'^[A-Za-z]{3,25}$');
  final RegExp passwordRegExp =RegExp(r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}$');

  XFile? _image;

  _imgFromCamera() async {
    XFile? image = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  _imgFromGallery() async {
    XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                  leading: new Icon(Icons.photo_library),
                  title: new Text('Photo Library'),
                  onTap: () {
                    _imgFromGallery();
                    Navigator.of(context).pop();
                  },
                ),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text('Camera'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      title: Text("User Registration"),
    ),
      body: Form(
        // key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Center(
              //   child: Image.asset(
              //     'assets/img1.png', // Add your image asset path here
              //     height: 100,
              //     fit: BoxFit.cover,
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      _showPicker(context);
                    },
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: Color(0xffdbd8cd),
                      child: _image != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.file(
                          File(_image!.path),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      )
                          : Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(50),
                        ),
                        width: 100,
                        height: 100,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildTitle("Personal Information"),
              const SizedBox(height: 20),
              _buildTextField(
                  controller: firstnameController,
                  label: "Full Name",
                  icon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    } else if (!nameRegExp.hasMatch(value)) {
                      return 'Name must be between 2 and 25 characters, including uppercase and lowercase letters';
                    }
                    return null;
                  }

              ),


              // const SizedBox(height: 20),
              // _buildGenderSelector(),
              const SizedBox(height: 20),
              _buildTextField(
                  controller: emailController,
                  label: "Email",
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your firstname';
                    } else if (!emailRegExp.hasMatch(value)) {
                      return 'Name must be between 2 and 25 characters, including uppercase and lowercase letters';
                    }
                    return null;
                  }
              ),
              const SizedBox(height: 20),
              _buildTextField(
                  controller: phoneNumberController,
                  label: "Phone",
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your firstname';
                    } else if (!_phoneReguser.hasMatch(value)) {
                      return 'Name must be between 10 number, starts with 6789';
                    }
                    return null;
                  }
              ),

              const SizedBox(height: 20),
              _buildTextField(
                  controller: placeController,
                  label: "Place",
                  icon: Icons.place,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your firstname';
                    } else if (!placeRegExp.hasMatch(value)) {
                      return 'Name must be between 2 and 25 characters, including uppercase and lowercase letters';
                    }
                    return null;
                  }
              ),
              const SizedBox(height: 20),
              _buildTextField(
                  controller: postController,
                  label: "Post",
                  icon: Icons.date_range,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your firstname';
                    } else if (!postRegExp.hasMatch(value)) {
                      return 'Name must be between 2 and 25 characters, including uppercase and lowercase letters';
                    }
                    return null;
                  }
              ),
              const SizedBox(height: 20),
              _buildTextField(
                  controller: pinController,
                  label: "Pin",
                  icon: Icons.pin_drop,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your firstname';
                    } else if (!pinRegExp.hasMatch(value)) {
                      return 'Name must be between 6 numbers';
                    }
                    return null;
                  }
              ),
              // const SizedBox(height: 20),
              // _buildTextField(
              //     controller: districtController,
              //     label: "District",
              //     icon: Icons.person_outline,
              //     validator: (value) {
              //       if (value == null || value.isEmpty) {
              //         return 'Please enter your firstname';
              //       } else if (!placeRegExp.hasMatch(value)) {
              //         return 'Name must be between 2 and 25 characters, including uppercase and lowercase letters';
              //       }
              //       return null;
              //     }
              // ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: usernameController,
                label: "Username As email",
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: passwordController,
                label: "Password",
                icon: Icons.password_outlined,
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: () async{
                    final sh = await SharedPreferences.getInstance();
                    String firstname = firstnameController.text;
                    // String district = districtController.text;
                    String place = placeController.text;
                    String post = postController.text;
                    String pin = pinController.text;
                    String email = emailController.text;
                    String phoneNumber = phoneNumberController.text;
                    String username = usernameController.text;
                    String password = passwordController.text;
                    String url = sh.getString("url").toString();
                    print(url);
                    try {

                      var uri = Uri.parse(url+'user_registration');  // Replace with your Express server URL
                      var request = http.MultipartRequest('POST', uri);

                      request.files.add(await http.MultipartFile.fromPath('image', _image!.path));
                      request.fields['name'] = firstname;
                      request.fields['email'] = email;
                      request.fields['place'] = place;
                      request.fields['post'] = post;
                      request.fields['pin'] = pin;
                      // request.fields['district'] = district;
                      request.fields['phone'] = phoneNumber;
                      request.fields['username'] = username;
                      request.fields['password'] = password;
                      var response = await request.send();

                      if (response.statusCode == 200) {
                        print('Image uploaded successfully');
                        // } else {
                        //   print('Image upload failed');
                        // }
                        // if (status == "ok") {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Successfully Registered'),
                            duration: Duration(seconds: 4),
                          ),
                        );
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Login()));
                      }
                      else{
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Invalid User.......'),
                            duration: Duration(seconds: 4),
                          ),
                        );
                      }



                    }
                    catch(e)
                    {
                      print(e);
                    }






                  },

                  // onPressed: _register,
                  child: const Text("Sign Up"),
                ),
              ),
            ],
          ),
        ),
      ),
    );




  }

  Widget _buildTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
      ),
      validator: validator,



    );
  }
// Widget _buildGenderSelector() {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.start,
//     children: [
//       Radio<String>(
//         value: "male",
//         groupValue: gender,
//         onChanged: (value) {
//           setState(() {
//             gender = value!;
//           });
//         },
//       ),
//       const Text("Male"),
//       Radio<String>(
//         value: "female",
//         groupValue: gender,
//         onChanged: (value) {
//           setState(() {
//             gender = value!;
//           });
//         },
//       ),
//       const Text("Female"),
//     ],
//   );
// }

}
