import 'package:flutter/material.dart';

import 'src/auth_page.dart';

void main() => runApp(AuthApp());

class AuthApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: AuthPage(),
    );
  }
}
