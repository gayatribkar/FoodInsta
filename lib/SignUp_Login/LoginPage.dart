

// import 'package:flutter/material.dart';
// import 'package:flutter_foodinsta_app/Screens/landingPage.dart';
// import 'package:flutter_foodinsta_app/SignUp_Login/SignUpPage.dart';

// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   void _validateAndLogin() {
//   if (_formKey.currentState!.validate()) {
//     // Perform login logic here
//     print('Login Successful');
    
//     // Navigate to LandingPage after successful login
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => LandingPage()),
//     );
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Background image for the top half of the screen
//           Container(
//             height: MediaQuery.of(context).size.height * 0.4,
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('assets/login.jpeg'), // Replace with your background image
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           // White container for form fields with rounded corners
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               height: MediaQuery.of(context).size.height * 0.7,
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.vertical(
//                   top: Radius.circular(50), // Apply border radius at the top
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 50,
//                     offset: Offset(0, -20),
//                   ),
//                 ],
//               ),
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     Text(
//                       'Sign In',
//                       style: TextStyle(
//                         fontSize: 34,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.green[700], // Adjusted to match theme
//                       ),
//                     ),
//                     const SizedBox(height: 60),
                
//                     Form(
//                       key: _formKey,
//                       child: Column(
//                         children: [
//                           // Email Field
//                           TextFormField(
//                             controller: _emailController,
//                             decoration: InputDecoration(
//                               labelText: 'Email',
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               prefixIcon: const Icon(Icons.email),
//                               filled: true,
//                               fillColor: Colors.grey[100],
//                             ),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter an email';
//                               } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//                                 return 'Please enter a valid email';
//                               }
//                               return null;
//                             },
//                           ),
//                           const SizedBox(height: 25),
//                           // Password Field
//                           TextFormField(
//                             controller: _passwordController,
//                             decoration: InputDecoration(
//                               labelText: 'Password',
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               prefixIcon: const Icon(Icons.lock),
//                               filled: true,
//                               fillColor: Colors.grey[100],
//                             ),
//                             obscureText: true,
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter your password';
//                               }
//                               return null;
//                             },
//                           ),
//                           const SizedBox(height: 40),
//                           // Sign In Button
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               ElevatedButton(
//                                 onPressed: _validateAndLogin,
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.green,
//                                   padding: const EdgeInsets.all(20),
//                                   shape: const CircleBorder(),
//                                   elevation: 5,
//                                 ),
//                                 child: const Icon(Icons.arrow_forward, color: Colors.white),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 10),
//                           // Forgot password and signup options
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               TextButton(
//                                 onPressed: () {
//                                   // Forgot password logic
//                                 },
//                                 child: const Text('Forgot Password?'),
//                               ),
//                               TextButton(
//                                 onPressed: () {
//                                      Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => SignupPage()), // Navigate to SignupPage
//     );
//                                 },
//                                 child: const Text(
//                                   'Sign up',
//                                   style: TextStyle(fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_foodinsta_app/Screens/landingPage.dart';
import 'package:flutter_foodinsta_app/SignUp_Login/SignUpPage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _validateAndLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;  // Show loading indicator
      });

      try {
        // Call the login API
        var response = await _login(
          _emailController.text,
          _passwordController.text,
        );

        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          // Handle success
          print('Login Successful');
          
          // Navigate to LandingPage after successful login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LandingPage()),
          );
        } else {
          // Handle error response
          print('Login Failed: ${response.body}');
          _showErrorDialog('Invalid email or password');
        }
      } catch (e) {
        print('Login error: $e');
        _showErrorDialog('An error occurred. Please try again.');
      }

      setState(() {
        _isLoading = false;  // Hide loading indicator
      });
    }
  }

  Future<http.Response> _login(String email, String password) {
    return http.post(
      Uri.parse('https://adiboy6-service1--3000.prod1.defang.dev/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image for the top half of the screen
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/login.jpeg'), // Replace with your background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // White container for form fields with rounded corners
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(50), // Apply border radius at the top
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 50,
                    offset: Offset(0, -20),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700], // Adjusted to match theme
                      ),
                    ),
                    const SizedBox(height: 60),

                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Email Field
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefixIcon: const Icon(Icons.email),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an email';
                              } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 25),
                          // Password Field
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefixIcon: const Icon(Icons.lock),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 40),
                          // Sign In Button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: _isLoading ? null : _validateAndLogin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: const EdgeInsets.all(20),
                                  shape: const CircleBorder(),
                                  elevation: 5,
                                ),
                                child: _isLoading
                                    ? const CircularProgressIndicator(color: Colors.white)
                                    : const Icon(Icons.arrow_forward, color: Colors.white),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Forgot password and signup options
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  // Forgot password logic
                                },
                                child: const Text('Forgot Password?'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => SignupPage()),
                                  );
                                },
                                child: const Text(
                                  'Sign up',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
