import 'package:flutter/material.dart';
import 'package:frontend/widgets/user/user.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  
  @override
  Widget build(BuildContext context) {
  final Future<User> myUser = ModalRoute.of(context).settings.arguments;
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<User>(
              future: myUser,
              builder: (context, userInfo) {
                if (userInfo.hasData) {
                  print(userInfo.data.accessToken);
                  return Text(userInfo.data.name);
                } else if (userInfo.hasError) {
                  return Text("${userInfo.error}");
                }

                return CircularProgressIndicator();
              },
            ),
            
          ],
        ),
      ),
    );
  }
}