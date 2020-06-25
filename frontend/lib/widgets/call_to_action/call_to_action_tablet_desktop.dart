import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/locator.dart';
import 'package:frontend/routing/route_names.dart';
import 'package:frontend/services/navigation_service.dart';

class CallToActionTabletDesktop extends StatelessWidget {
  final String title;
  const CallToActionTabletDesktop(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal:60, vertical: 15),
      child: FlatButton(
        color: primaryColor,
        onPressed: () {
          locator<NavigationService>().navigateTo(LoginRoute);
        },
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18, 
            fontWeight:FontWeight.w800,
            color: Colors.white
          )
        ),
      ),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(5)
      ),
    );
  }
}