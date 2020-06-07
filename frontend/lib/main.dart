import 'package:flutter/material.dart';
import 'package:frontend/locator.dart';
import 'package:frontend/views/about/register_screen.dart';
import 'package:frontend/views/layout_template/layout_template.dart';
import 'package:frontend/views/login/login_screen.dart';


void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Software Traceability',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Open Sans')
      ),
      home: LayoutTemplate(),
      routes: <String, WidgetBuilder> {
        '/login_screen': (BuildContext context) => LoginScreen(),
        '/register_screen': (BuildContext context) => RegisterScreen(),
      },
    );
  }
}

