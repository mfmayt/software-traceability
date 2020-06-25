import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/views/functional_view/functional_view.dart';

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
    return Center(
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
            ],
          ),
        ],
      ),
    );
  }
}