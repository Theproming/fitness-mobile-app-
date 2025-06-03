import 'dart:convert';

import 'package:fitness_app/screens/loginScreen.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '', _email = '', _password = '';
  bool _passwordVisible = false;

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<void> insert_record() async {
    try {
      String uri = "http://10.0.2.2/fitness/register.php";
      var res = await http.post(Uri.parse(uri), body: {
        "name": name.text,
        "email": email.text,
        "password": password.text,
      });

      final responseData = json.decode(res.body);

      if (responseData['success']) {
        print("Registered Successfully!");
        Toast.show("Registered Successfully!",
            duration: Toast.lengthShort, gravity: Toast.top);

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const LoginScreen()));
      } else {
        print("Not Registered!");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.grey,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 50),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/img/Logo.jpg',
                  height: 150,
                  width: 150,
                ),

                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.grey[200], // Background color
                  ),
                  child: TextFormField(
                    controller: name,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                    onSaved: (value) => _name = value.toString(),
                  ),
                ),
                const SizedBox(height: 10), // Adjust spacing as needed
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.grey[200], // Background color
                  ),
                  child: TextFormField(
                    controller: email,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter an email';
                      } else if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    onSaved: (value) => _email = value.toString(),
                  ),
                ),
                const SizedBox(height: 10), // Adjust spacing as needed
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.grey[200], // Background color
                  ),
                  child: TextFormField(
                    controller: password,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20.0),
                      border: InputBorder.none,
                      prefixIcon:
                          const Icon(Icons.lock), // Remove default border
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                    obscureText: !_passwordVisible,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a password';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                    onSaved: (value) => _password = value.toString(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // Handle registration logic
                    }
                    insert_record();
                  },
                  child: const Text(
                    'Register',
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  },
                  child: const Text(
                    'Already registered? Login',
                    style: TextStyle(fontSize: 25, color: Colors.black54),
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
