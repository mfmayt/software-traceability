import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/views/archviews/arch_views.dart';
import 'package:frontend/views/development/development_view.dart';
import 'package:frontend/views/functional_view/functional_view.dart';
import 'package:frontend/views/home/home_view.dart';
import 'package:frontend/views/login/login_view.dart';

class ProjectScreen extends StatefulWidget {
  ProjectScreen({Key key}) : super(key: key);

  @override
  _ProjectScreenState createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  @override
  Widget build(BuildContext context) {
    final String projectName = ModalRoute.of(context).settings.arguments;
    print(projectName);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        actions: <Widget>[
          IconButton(
            tooltip: "Return to Home",
            icon: Icon(Icons.home), 
            onPressed: (){
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => HomeView(),
                ),
              );
            }
          ),
          IconButton(
            tooltip: "Logout",
            icon: Icon(Icons.exit_to_app), 
            onPressed: (){
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => LoginView(),
                ),
              );
            })
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$projectName",
              style: TextStyle(
                fontSize: 50,
                color:Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              
              children: [
                Container(
                  child: RaisedButton(
                    color: primaryColor,
                    textColor: Colors.white,
                    child: Text("Architectural View"),
                    onPressed: () {
                      Navigator.push(
                         context, 
                         MaterialPageRoute(
                           builder: (context) => ArchViewList(),
                           settings: RouteSettings(arguments: projectName)
                         ),
                       );
                     },
                   ),
                ),
                Container(
                  child: RaisedButton(
                    color: primaryColor,
                    textColor: Colors.white,
                    child: Text("Funcional View"),
                    onPressed: () {
                      Navigator.push(
                         context, 
                         MaterialPageRoute(
                           builder: (context) => FunctionalView(projectName: projectName,),
                           settings: RouteSettings(arguments: projectName)
                         ),
                       );
                     },
                   ),
                ),
                Container(
                  child: RaisedButton(
                    color: primaryColor,
                    textColor: Colors.white,
                    child: Text("Development View"),
                    onPressed: () {
                      Navigator.push(
                         context, 
                         MaterialPageRoute(
                           builder: (context) => DevelopmentView(projectName: projectName,),
                           settings: RouteSettings(arguments: projectName)
                         ),
                       );
                     },
                   ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}