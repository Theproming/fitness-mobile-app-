import 'dart:convert';

import 'package:fitness_app/screens/dashboardScreen.dart';
import 'package:fitness_app/screens/registerScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '', _password = '';
  bool _passwordVisible = false;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<void> login(email, password) async {
    const url = "http://10.0.2.2/fitness/login.php";

    try {
      final response = await http.post(Uri.parse(url), body: {
        'email': email,
        'password': password,
      });

      final responseData = json.decode(response.body);

      if(responseData["success"]){
        final String name = responseData["name"];
        final String email = responseData["email"];

        Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboardscreen(name:name, email:email)));
      }else {
        final String errorMassage = responseData["message"];
        Toast.show(errorMassage,
            duration: Toast.lengthShort, gravity: Toast.top);

      }



    } catch (e) {
      Toast.show("An error accured, please try agian later",
          duration: Toast.lengthShort, gravity: Toast.top);
    }
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: Colors.grey[600],
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
                    color: Colors.grey[200],
                  ),
                  child: TextFormField(
                    controller: email,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                      border: InputBorder.none,
                      prefixIcon: const Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'please enter an email';
                      } else if (!value.contains('@')) {
                        return 'please enter a valid email address';
                      }
                      return null;
                    },
                    onSaved: (value) => _email = value.toString(),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.grey[200],
                  ),
                  child: TextFormField(
                    controller: password,
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20.0),
                      border: InputBorder.none,
                      prefixIcon: const Icon(Icons.lock),
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
                      // Handle login logic
                    }
                    login(_email, _password);
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Not registered? Register",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
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
