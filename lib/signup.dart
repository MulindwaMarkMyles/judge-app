import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:judge_app_2/database.dart';
import 'package:judge_app_2/homescreen.dart';
import 'package:judge_app_2/signin.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _passwordVisible = false;
  FirestoreService _fs = FirestoreService();

  String getUsernameFromEmail(String email) {
    if (email.contains('@')) {
      return email.split('@').first;
    } else {
      throw FormatException("Invalid email format");
    }
  }

  // Function to handle user registration
  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        String username = getUsernameFromEmail(_emailController.text.trim());

        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        //create categories
        String toto_id =
            await _fs.addCategory(userCredential.user!.uid, "Toto", 1);
        String mini_id =
            await _fs.addCategory(userCredential.user!.uid, "Mini", 2);
        String little_id =
            await _fs.addCategory(userCredential.user!.uid, "Little", 3);
        String teen_id =
            await _fs.addCategory(userCredential.user!.uid, "Teen", 4);

        //add student
        for (var i = 1; i < 101; i++) {
          await _fs.addStudent(userCredential.user!.uid, toto_id, i);
          await _fs.addStudent(userCredential.user!.uid, mini_id, i);
          await _fs.addStudent(userCredential.user!.uid, little_id, i);
          await _fs.addStudent(userCredential.user!.uid, teen_id, i);
        }

        print('User registered: ${userCredential.user!.email}');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Homescreen(username: username)),
        );
      } catch (e) {
        print('Error: $e');
        _showErrorDialog(e.toString());
      }
    }
  }

  // Error dialog function
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        // Background Design
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
        // Circular Decorations
        Positioned(
          top: -50,
          left: -50,
          child: CircleAvatar(
            radius: 100,
            backgroundColor: Colors.amber.withOpacity(0.3),
          ),
        ),
        Positioned(
          bottom: -60,
          right: -40,
          child: CircleAvatar(
            radius: 150,
            backgroundColor: Colors.amberAccent.withOpacity(0.2),
          ),
        ),
        // Form Content
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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

                // Email Field
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  isPassword: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$')
                        .hasMatch(value)) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),

                // Password Field with Eye Icon
                _buildTextField(
                  controller: _passwordController,
                  label: 'Password',
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),

                // Confirm Password Field
                _buildTextField(
                  controller: _confirmPasswordController,
                  label: 'Confirm Password',
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    } else if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30.0),

                // Sign-Up Button
                ElevatedButton(
                  onPressed: _registerUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50.0, vertical: 15.0),
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

                // Link to Sign-In
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignInScreen(),
                      ),
                    );
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
      ]),
    );
  }

  // Reusable TextField Widget with Eye Icon
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required bool isPassword,
    required String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1.0),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: TextFormField(
            controller: controller,
            obscureText: isPassword && !_passwordVisible,
            style: GoogleFonts.poppins(fontSize: 20.0, color: Colors.grey[600]),
            decoration: InputDecoration(
              border: InputBorder.none,
              labelText: label,
              labelStyle: TextStyle(color: Colors.grey[600]),
              suffixIcon: isPassword
                  ? IconButton(
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
                    )
                  : null,
            ),
            validator: validator,
          ),
        ),
      ),
    );
  }
}
