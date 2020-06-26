import 'package:flutter/material.dart';
import 'package:frontend/locator.dart';
import 'package:frontend/routing/route_names.dart';
import 'package:frontend/routing/router.dart';
import 'package:frontend/services/navigation_service.dart';
import 'package:frontend/views/layout_template/layout_template.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Software Traceability',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Open Sans')
      ),
      builder: (context , child) => LayoutTemplate(child: child,),//The child is the view returned from the route.
    
      navigatorKey: locator<NavigationService>().navigatorKey,
      onGenerateRoute: generateRoute,
      initialRoute: HomeRoute,
    
    );
  }
}

