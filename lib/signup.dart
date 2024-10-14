import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:judge_app_2/homescreen.dart';
import 'package:judge_app_2/main.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Function to validate and sign in the user
  void _validateAndSignIn() {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      // You can add your Firebase authentication logic here
      if (email.isNotEmpty && password.isNotEmpty) {
        print('Email: $email');
        print('Password: $password');
        // Handle actual sign-in logic here (Firebase auth, etc.)
      } else {
        print("Fields cannot be empty");
      }
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Homescreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background design
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.amber.withOpacity(0.1),
                  Colors.amberAccent.withOpacity(0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.amber.withOpacity(0.3),
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            right: -40,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.amberAccent.withOpacity(0.2),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "SIGN UP",
                    style: GoogleFonts.poppins(
                      fontSize: 40.0,
                      fontWeight: FontWeight.w800,
                      color: Colors.amber,
                    ),
                  ),
                  const SizedBox(height: 40.0),

                  // Name TextField
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.black, width: 1.0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextFormField(
                          controller: _emailController,
                          style: GoogleFonts.poppins(
                            fontSize: 20.0,
                            color: Colors.grey[600],
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Email',
                            labelStyle: TextStyle(color: Colors.grey[600]),
                          ),
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Please enter your email';
                          //   }
                          //   return null;
                          // },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  // Password TextField
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.black, width: 1.0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          style: GoogleFonts.poppins(
                            fontSize: 20.0,
                            color: Colors.grey[600],
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.grey[600]),
                          ),
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Please enter your password';
                          //   }
                          //   return null;
                          // },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30.0),

                  // Sign-In Button
                  ElevatedButton(
                    onPressed: _validateAndSignIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      shadowColor: Colors.black38,
                      elevation: 5,
                    ),
                    child: Text(
                      'SIGN UP',
                      style: GoogleFonts.poppins(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20.0),

                  // Sign-Up Link
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignInScreen()));
                    },
                    child: Text(
                      "Have an account? Sign in here.",
                      style: GoogleFonts.poppins(
                        fontSize: 16.0,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
