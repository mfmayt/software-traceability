import 'dart:convert';
import 'package:flutter/material.dart';
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
    print(myUser.id);
    super.initState();
    this.getUserProjects(myUser.id, myUser.accessToken);
  }
  List<List<Project>> userProjects = [];
  getUserProjects(userId,userToken) async{
    final response = await http.get(
      baseUrl+'/users/'+userId+'/projects',
      headers: {
        "Authorization":"Bearer "+userToken
      } 
    );
    if (response.statusCode == 200) {
      print(response.body);
      var projectList = (json.decode(response.body) as List);
      print(projectList[0]);
      /*
      for(int i=0;i<response.body.length;i++){

        if(userProjects.last.length<4){
          userProjects.last.add(item);
        }else{
          userProjects.add([item]);
        }
      }
      */
      return null;
    } else {
      throw Exception('Failed to get Projects');
    }
  }
  
  final List<List> generalList =[["Software Tracker"]];

  dynamic createProject(String projectName){
    setState(() {
      if(generalList.last.length<4){
        generalList.last.add(projectName);
      }else{
        generalList.add([projectName]);
      }
    });
  }
  
  var projectNameController = new TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    //final Future<User> myUser = ModalRoute.of(context).settings.arguments;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        actions: <Widget>[
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
                                              projectNameController.clear();
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
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: ListView.builder(
              itemCount: generalList.length,
              itemBuilder: (BuildContext context,int index){
                return Container(
                  height: 200,
                  child: ListView.builder(
                    //reverse: true,
                    scrollDirection: Axis.horizontal,
                    //padding: const EdgeInsets.all(10),
                    itemCount: generalList[index].length,
                    itemBuilder: (BuildContext context,int index2){
                      return ProjectItem(projectName: generalList[index][index2]);
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