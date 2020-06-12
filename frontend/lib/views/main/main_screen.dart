import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/constants/url_constants.dart';
import 'package:frontend/widgets/navigation_bar/navigation_bar_projects_screen.dart';
import 'package:frontend/widgets/project/project.dart';
import 'package:frontend/widgets/user/user.dart';
import 'package:http/http.dart' as http;

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Future<Project>> _futureUserProjects;
  final myNavigator = new Navigator();
  
  Future<Project> getUserProjects(userId)async{
    final http.Response response = await http.get(
      baseUrl + '/users/$userId/projects'
    );
    
    if (response.statusCode == 200) {
      return Project.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to login');
    }
    
  }
  
  @override
  Widget build(BuildContext context) {
  final Future<User> myUser = ModalRoute.of(context).settings.arguments;
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FutureBuilder<User>(
            future: myUser,
            builder: (context, userInfo) {
              if (userInfo.hasData) {
                return Column(children:<Widget>[
                  NavigationBarProjectsScreen(),
                  Text(userInfo.data.id)
                  ]
                );
              } else if (userInfo.hasError) {
                return Column(children:<Widget>[
                  
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: (){
                      Navigator.pop(context);
                      //locator<NavigationService>().goBack();
                    },
                  ),  
                  
                  Text("Login failed \n ${userInfo.error}")  
                  ]
                );
              }

              return CircularProgressIndicator();
            },
          ),  
        ],
      ),
    );
  }
}