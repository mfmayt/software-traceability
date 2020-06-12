import 'package:flutter/material.dart';
import 'package:frontend/widgets/navigation_bar/navigation_bar_tablet_desktop.dart';
import 'package:frontend/widgets/navigation_bar/navigation_bar_mobile.dart';
import 'package:responsive_builder/responsive_builder.dart';

class NavigationBar extends StatelessWidget {
  final int type ;
  const NavigationBar({Key key, this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: NavigationBarMobile(),
      tablet: NavigationBarTabletDesktop(),
    );
  }
}