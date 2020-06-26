import 'package:flutter/material.dart';
class NavBarLogo extends StatelessWidget {
  const NavBarLogo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        height: 80,
        width: 150,
        child: FlatButton(
         onPressed: null,
         padding: EdgeInsets.all(0.0),
         child: Image.asset('assets/logo.png'))));
  }
}