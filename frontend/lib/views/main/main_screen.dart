import 'dart:convert';
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/constants/url_constants.dart';
import 'package:frontend/views/home/home_view.dart';
import 'package:frontend/views/login/login_view.dart';
import 'package:frontend/views/project_page/project_item.dart';
import 'package:frontend/widgets/project/project.dart';
import 'package:frontend/widgets/user/user.dart';
import 'package:http/http.dart' as http;

class MainScreen extends StatefulWidget {
  final User myUser ;
  const MainScreen({Key key, this.myUser}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState(myUser);
}

class _MainScreenState extends State<MainScreen> {
  final User myUser ;
  _MainScreenState(this.myUser);

  @override
  void initState() {
    super.initState();
    this.getUserProjects(myUser.id, myUser.accessToken);
  }

  List<List<Project>> userProjects = [[]];
  getUserProjects(userId,userToken) async{
    final response = await http.get(
      baseUrl+'/users/'+userId+'/projects',
      headers: {
        "Authorization":"Bearer "+userToken
      } 
    );
    if (response.statusCode == 200) {
      setState(() {
        var projectList = (json.decode(response.body) as List).map((project) => Project.fromJson(project)).toList();
        for(int i=0;i<projectList.length;i++){
          if(userProjects.last.length<4){
            userProjects.last.add(projectList[i]);
          }else{
            userProjects.add([projectList[i]]);
          }
        }
        return null;
      });
    }else{
      throw Exception('Failed to get Projects');
    }
  }
  
  Future<Project>postProject(String projectName,userToken) async{
    final response = await http.post(
      baseUrl+'/projects',
      headers: {
        "Authorization":"Bearer "+userToken
      },
      body: jsonEncode(<String, String>{
        'name':projectName
      })
    );

    if (response.statusCode == 200) {
      return Project.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to login');
    }
  }

  dynamic createProject(Project a){
    setState(() {
      if(userProjects.last.length<4){
        userProjects.last.add(a);
      }else{
        userProjects.add([a]);
      }
    });
  }
  
  var projectNameController = new TextEditingController();
  Future<Project> _futureProject;
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        actions: <Widget>[
          /*
          Tooltip(
            verticalOffset: 0,
            message: "Add Project",
            child: IconButton(
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
          ),
          */
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
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    //Welcome Card
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(10,10,10,0),
                        height:190,
                        child: Card(
                          elevation: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: RichText(
                                text: TextSpan(
                                  text: "Welcome "+ myUser.name,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize:20,
                                    fontWeight: FontWeight.bold 
                                  )
                                )
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    //Text(myUser.name),
                    // Add project Card
                    Container(
                      padding: EdgeInsets.fromLTRB(10,10,10,0),
                      height:190,
                      width: 200,
                      child: Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: "Add Project",
                                  style: TextStyle(
                                    
                                    color: Colors.blue,
                                    fontSize:20,
                                    fontWeight: FontWeight.bold
                                  )
                                )
                              ),
                              IconButton(
                                icon: Icon(Icons.add,color: Colors.blue,size: 35,),
                                onPressed: () {
                                  // Creates a pop up.
                                  setState(() {
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (_)=> AlertDialog(
                                        elevation: 24.0,
                                        actions: [
                                          FlatButton(
                                            child: Text("Confirm"),
                                            onPressed: () {
                                              _futureProject = postProject(projectNameController.text, myUser.accessToken);
                                              projectNameController.clear();
                                              Navigator.of(context, rootNavigator: true).pop('dialog');
                                            },
                                          ),
                                        ],
                                        title: Text("Enter a name for your project"),
                                        content: (_futureProject==null)
                                        ?TextField(
                                          maxLength: 30,
                                          controller: projectNameController,
                                        )
                                        :FutureBuilder(
                                          future: _futureProject,
                                          builder: (context,snapshot){
                                            if(snapshot.connectionState == ConnectionState.done){
                                              if(snapshot.hasData){
                                                print("SNAPSHOT HAS DATA");
                                                return Container(
                                                  height: 200,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text('Project Added'),
                                                    ],
                                                  ),
                                                );
                                              }else{
                                                return Container(
                                                  height: 200,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text('Failed to add project'),
                                                      RaisedButton(
                                                        color: primaryColor,
                                                        child: Text("OK"),
                                                        onPressed: () {
                                                          Navigator.of(context, rootNavigator: true).pop('dialog');
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }
                                            }else {
                                              return Container(height:200,child: Center(child: CircularProgressIndicator()));
                                            }
                                          }
                                        )
                                      ),
                                    );
                                  });
                                },
                              ),
                            ]
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: ListView.builder(
              itemCount: userProjects.length,
              itemBuilder: (BuildContext context,int index){
                return Container(
                  height: 200,
                  child: ListView.builder(
                    //reverse: true,
                    scrollDirection: Axis.horizontal,
                    //padding: const EdgeInsets.all(10),
                    itemCount: userProjects[index].length,
                    itemBuilder: (BuildContext context,int index2){
                      return ProjectItem(projectName: userProjects[index][index2].name);
                    },
                  ),
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}