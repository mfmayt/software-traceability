import 'package:flutter/material.dart';
import 'package:frontend/locator.dart';
import 'package:frontend/services/navigation_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome",
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.bold, 
              ),
            ),
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: (){
                locator<NavigationService>().goBack();
              },
            ),
          ],
        ),
      ),
    );
  }
}