import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/Tugas4/view/login.dart';
import 'package:flutter_firebase/firebase_options.dart';
import 'package:provider/provider.dart';

import 'Tugas4/model/artikelModel.dart';
import 'Tugas4/model/createArtikelModel.dart';
import 'Tugas4/model/updateArtikelModel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    runApp(
      MultiProvider(providers: [ChangeNotifierProvider(create: (context) => ArtikelProvider()),
      ChangeNotifierProvider(create: (context) => CreateArtikelProvider()),
      ChangeNotifierProvider(create: (context) => UpdateArtikelProvider()),
      ], child: const MyApp())
    );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromRGBO(144, 202, 249, 1)),
        useMaterial3: true,
      ),
      home: LoginScreen(),
    );
  }
}