import 'package:flutter/material.dart';
import 'package:frontend/routing/route_names.dart';
import 'package:frontend/widgets/navigation_bar/navbar_item.dart';
class NavigationBarProjectsScreen extends StatelessWidget {
  const NavigationBarProjectsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.purple,
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          NavBarItem('Logout', LoginRoute),
          IconButton(icon: Icon(Icons.home), onPressed: (){
            Navigator.pushNamed(context, HomeRoute);
          })
        ],
      )
    );
  }
}