import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/routing/route_names.dart';
import 'package:frontend/views/about/about_view.dart';
import 'package:frontend/views/about/register_screen.dart';
import 'package:frontend/views/home/home_view.dart';
import 'package:frontend/views/login/login_screen.dart';
import 'package:frontend/views/login/login_view.dart';

Route<dynamic> generateRoute(RouteSettings settings){
  switch (settings.name) {
    case HomeRoute:
      return _getPageRoute(HomeView());
    case AboutRoute:
      return _getPageRoute(AboutView());
    case LoginRoute:
      return _getPageRoute(LoginView());
    case LoginScreenRoute:
      return _getPageRoute(LoginScreen());
    case RegisterScreenRoute:
      return _getPageRoute(RegisterScreen());
    
    //case MainScreenRoute:
    //  return _getPageRoute(MainScreen());
    default:
      
  }
}

PageRoute _getPageRoute(Widget child){
  return _FadeRoute(child: child);
}

class _FadeRoute extends PageRouteBuilder {
  final Widget child;
  _FadeRoute({this.child}):
  super(
    pageBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
    ) => child,
    
    transitionsBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) => FadeTransition(opacity: animation, child: child,)
  
  );
}
