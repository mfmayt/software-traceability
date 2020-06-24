import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/constants/url_constants.dart';
import 'package:frontend/views/home/home_view.dart';
import 'package:frontend/views/project_page/project_screen.dart';
import 'package:frontend/widgets/project/project.dart';
import 'package:frontend/widgets/user/user.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;
class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  //List<Future<Project>> _futureUserProjects;
  //final myNavigator = new Navigator();
  

  Future<List<Project>> getUserProjects(userId,userToken) async{
    print(userToken);
    final response = await http.get(
      baseUrl+'/users/5c140e91-eff1-485f-b71e-4680a20136b1',
      headers: {
        "Authorization":"Bearer $userToken"
      }
      //headers: {HttpHeaders.authorizationHeader: "Bearer " + userToken },
    );
    
    print("HERE");
    if (response.statusCode == 200) {
      List<Project> projects = [];
      print("USER HAS PROJECTS");
      print(response.body);
      Project.fromJson(json.decode(response.body));
      return projects;
    } else {
      throw Exception('Failed to get Projects');
    }
  }
  /*
  dynamic buildProject(Future<Project> myProjects){
    return FutureBuilder<Project>(
      future: myProjects,
      builder: (context,projectInfo){
        if(projectInfo.hasData){
          return List;
        }
        else if(projectInfo.hasError){
          return Text("No Projects");
        }
        return CircularProgressIndicator();
      },
    );
  }
  */
  dynamic buildUser(Future<User>myUser){
    return FutureBuilder<User>(
      future: myUser,
      builder: (context, userInfo) {
        if (userInfo.hasData) {
          getUserProjects(userInfo.data.id,userInfo.data.accessToken);
          return Text(userInfo.data.name);
        }
        else if (userInfo.hasError) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:<Widget>[
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
    );
  }
  
  final List<String> projects = ["Software Tracker"];
  final List<String> projects2 = [];

  dynamic createProject(String projectName){
    setState(() {
      if(projects.length<=3){
        projects.insert(0, projectName);
      }else{
        projects2.insert(0, projectName);
      }    
    });
  }

  
  var projectNameController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    final Future<User> myUser = ModalRoute.of(context).settings.arguments;
    /*return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        NavigationBarProjectsScreen(),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children:<Widget>[
            Container(
              alignment: Alignment.center,
              constraints: BoxConstraints(),
              width: 600,
              height: 600,
              color:Colors.blue,
              child: Text("Projects"),
            ),
            Container(
              alignment: Alignment.center,
              constraints: BoxConstraints(),
              width: 600,
              height: 600,
              color:Colors.blue,
              child:buildUser(myUser),
            )
          ])
      ], 
    );*/
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add), 
            onPressed: () {
              // Creates a pop up.
              showDialog(
                context: context,
                builder: (_)=> AlertDialog(
                    title: Text("Enter a name for your project"),
                    content: TextField(
                      maxLength: 30,
                      controller: projectNameController,
                    ),
                    actions: [
                      FlatButton(
                        child: Text("Confirm"),
                        onPressed: () {
                          createProject(projectNameController.text);
                          Navigator.of(context, rootNavigator: true).pop('dialog');
                        },
                      ),
                    ],
                    elevation: 24.0,
                    
                ),
                barrierDismissible: false,
              );
            },
            ),
          IconButton(
            icon: Icon(Icons.home), 
            onPressed: (){
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => HomeView(),
                  //settings: RouteSettings(arguments: _futureUser)
                ),
              );
            }
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app), 
            onPressed: (){
              Navigator.pop(context);
            })
        ],
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 800,
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(10),
                  itemCount: projects.length,
                  itemBuilder: (BuildContext context,int index){
                    return Container(
                      padding: EdgeInsets.fromLTRB(10,10,10,10),
                      height:220,
                      width:200,
                      child: Card(
                        color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
                        elevation: 5,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                "${projects[index]}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize:20,
                                  fontWeight: FontWeight.bold
                                )
                              ),
                            ),
                            IconButton(
                              alignment: Alignment.bottomRight,
                              icon: Icon(Icons.search),
                              onPressed: () {
                                Navigator.push(
                                  context, 
                                  MaterialPageRoute(
                                    builder: (context) => ProjectScreen(),
                                    settings: RouteSettings(arguments: "${projects[index]}"),
                                  ),
                                );
                              },
                            )
                          ],
                        )
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10,10,10,0),
                height:180,
                width:600,
                child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            text: "Add New Project",
                            style: TextStyle(
                              color: Colors.black
                            )
                          )
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            // Creates a pop up.
                            showDialog(
                              context: context,
                              builder: (_)=> AlertDialog(
                                  title: Text("Enter a name for your project"),
                                  content: TextField(
                                    maxLength: 30,
                                    controller: projectNameController,
                                  ),
                                  actions: [
                                    FlatButton(
                                      child: Text("Confirm"),
                                      onPressed: () {
                                        createProject(projectNameController.text);
                                        Navigator.of(context, rootNavigator: true).pop('dialog');
                                      },
                                    ),
                                  ],
                                  elevation: 24.0,
                                  
                              ),
                              barrierDismissible: false,
                            );
                          },
                        ),
                      ]
                    ),
                  ),
                ),
              ),
            ]
          ),
          Row(
            children: <Widget>[
              Container(
                width: 800,
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(10),
                  itemCount: projects2.length,
                  itemBuilder: (BuildContext context,int index2){
                    return Container(
                      padding: EdgeInsets.fromLTRB(10,10,10,10),
                      height:220,
                      width:200,
                      child: Card(
                        color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
                        elevation: 5,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                "${projects2[index2]}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize:20,
                                  fontWeight: FontWeight.bold
                                )
                              ),
                            ),
                            IconButton(
                              alignment: Alignment.bottomRight,
                              icon: Icon(Icons.search),
                              onPressed: () {
                              },
                            )
                          ],
                        )
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10,10,10,0),
                height:180,
                width:600,
                child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            text: "Add New Project",
                            style: TextStyle(
                              color: Colors.black
                            )
                          )
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            // Creates a pop up.
                            showDialog(
                              context: context,
                              builder: (_)=> AlertDialog(
                                  title: Text("Enter a name for your project"),
                                  content: TextField(
                                    controller: projectNameController,
                                  ),
                                  actions: [
                                    FlatButton(
                                      child: Text("Confirm"),
                                      onPressed: () {
                                        createProject(projectNameController.text);
                                        Navigator.of(context, rootNavigator: true).pop('dialog');
                                      },
                                    ),
                                  ],
                                  elevation: 24.0,
                              ),
                              barrierDismissible: false,
                            );
                          },
                        ),
                      ]
                    ),
                  ),
                ),
              ),
            ]
          ),
        ]
      ),
    );
  }
}