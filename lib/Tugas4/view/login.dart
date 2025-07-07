import 'package:flutter/material.dart';
import '../controller/authservice.dart';
import 'artikel.dart';
import 'signup.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  final Color primaryColor = Color.fromRGBO(144, 202, 249, 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login', style: TextStyle(color: Colors.white)),
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
                  Icons.task_alt,
                  size: 80,
                  color: primaryColor,
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
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final user = await AuthService()
                        .login(_emailController.text, _passwordController.text);
                    if (user != null) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text("Login berhasil")));
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => ArtikelScreen(
                                user: user,
                              )));
                    } else {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text("Login gagal")));
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                  child: Text('Login', style: TextStyle(color: Colors.white)),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                    );
                  },
                  child: Text('Belum punya akun? Daftar', style: TextStyle(color: primaryColor)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}