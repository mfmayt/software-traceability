import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/locator.dart';
import 'package:frontend/routing/route_names.dart';
import 'package:frontend/services/navigation_service.dart';

class CallToActionMobile extends StatelessWidget {
  final String title;
  const CallToActionMobile(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      alignment: Alignment.center,
      child: RaisedButton(
        color: primaryColor,
        onPressed: () {
          locator<NavigationService>().navigateTo(LoginRoute);
        },
        child: Text(
          title,
          style:TextStyle(
            fontSize: 18, 
            fontWeight:FontWeight.w800,
            color: Colors.white
          ),
        ),
      ),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(5)
      ),
    );
  }
}
