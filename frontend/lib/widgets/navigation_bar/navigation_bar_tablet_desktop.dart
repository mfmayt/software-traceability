import 'package:flutter/material.dart';
import 'package:frontend/routing/route_names.dart';
import 'package:frontend/widgets/navigation_bar/navbar_item.dart';
import 'package:frontend/widgets/navigation_bar/navbar_logo.dart';

class NavigationBarTabletDesktop extends StatelessWidget {
  const NavigationBarTabletDesktop({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          NavBarLogo(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              //NavBarItem('Start',LoginRoute),
              SizedBox(width: 60,),
              NavBarItem('About',AboutRoute),
            ],
          )
        ],
      ),
    );
  }
}