import 'package:flutter/material.dart';
import '../controller/authservice.dart';
import 'login.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  final Color primaryColor = Color.fromRGBO(144, 202, 249, 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.person_add,
                  size: 80,
                  color: primaryColor,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    floatingLabelStyle: TextStyle(color: primaryColor),
                    border: OutlineInputBorder(borderSide: BorderSide(color: primaryColor)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryColor)),
                  ),
                  cursorColor: primaryColor,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    floatingLabelStyle: TextStyle(color: primaryColor),
                    border: OutlineInputBorder(borderSide: BorderSide(color: primaryColor)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryColor)),
                  ),
                  cursorColor: primaryColor,
                  validator: (value) {
                    if (value == null || value.isEmpty || !value.contains('@')) {
                      return 'Masukkan email yang valid';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    floatingLabelStyle: TextStyle(color: primaryColor),
                    border: OutlineInputBorder(borderSide: BorderSide(color: primaryColor)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryColor)),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                  cursorColor: primaryColor,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 6) {
                      return 'Password minimal 6 karakter';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final user = await AuthService().signUp(_usernameController.text,_emailController.text, _passwordController.text);
                    if (user != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Sign Up berhasil")));
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => LoginScreen()));
                    } else {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text("Sign Up Gagal")));
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                  child: Text('Daftar', style: TextStyle(color: Colors.white)),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Text('Sudah punya akun? Login', style: TextStyle(color: primaryColor)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}