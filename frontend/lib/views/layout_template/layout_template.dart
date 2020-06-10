import 'package:flutter/material.dart';
import 'package:frontend/locator.dart';
import 'package:frontend/routing/route_names.dart';
import 'package:frontend/routing/router.dart';
import 'package:frontend/services/navigation_service.dart';
import 'package:frontend/widgets/centered_view/centered_view.dart';
import 'package:frontend/widgets/navigation_bar/navigation_bar.dart';
import 'package:frontend/widgets/navigation_drawer/navigation_drawer.dart';
import 'package:responsive_builder/responsive_builder.dart';

class LayoutTemplate extends StatelessWidget {
  const LayoutTemplate({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder:(context,sizingInformation) => Scaffold(
        drawer: sizingInformation.deviceScreenType == DeviceScreenType.mobile 
          ? NavigationDrawer()
          : null,

        backgroundColor: Colors.white,
        body: CenteredView(
          child:Column(
            children: <Widget>[
              NavigationBar(),
              Expanded(
                child: Navigator(
                  key: locator<NavigationService>().navigatorKey,
                  onGenerateRoute: generateRoute,
                  initialRoute: HomeRoute,
                ) 
              )
            ],
          ),
        ) 
      ),
    );
  }
}
