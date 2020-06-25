import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/constants/url_constants.dart';
import 'package:frontend/views/home/home_view.dart';
import 'package:frontend/views/project_page/project_item.dart';
import 'package:frontend/views/project_page/project_screen.dart';
import 'package:frontend/widgets/project/project.dart';
import 'package:frontend/widgets/user/user.dart';
import 'package:http/http.dart' as http;

class MainScreen extends StatefulWidget {
  final myUser ;

  const MainScreen(Future<User> futureUser, {Key key, this.myUser}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState(myUser);
}

class _MainScreenState extends State<MainScreen> {
  //List<Future<Project>> _futureUserProjects;
  //final myNavigator = new Navigator();
  final myUser ;
  _MainScreenState(this.myUser);

  @override
  void initState() { 
    super.initState();
    print("INITIAL STATE");
    buildUser(myUser);
  }

  Future<List<Project>> getUserProjects(userId,userToken) async{
    print("User TOKEN = $userToken");
    final response = await http.get(
      baseUrl+'/users/$userToken',
      headers: {
        "Authorization":"Bearer $userToken"
      }
      
    );
    
    print("HERE");
    if (response.statusCode == 200) {
      List<Project> projects = [];
      print("USER HAS PROJECTS");
      print(response.body);
      var b =Project.fromJson(json.decode(response.body));
      print(b.name);
      createProject(b.name);
      print ("b = $b");
      projects.add(b);
      return projects;
    } else {
      throw Exception('Failed to get Projects');
    }
  }
  
  dynamic buildUser(Future<User>myUser){
    print("BUILD USER");
    return FutureBuilder<User>(
      future: myUser,
      builder: (context, userInfo) {
        print("BUILDER");
        if (userInfo.hasData) {
          var a = getUserProjects(userInfo.data.id, userInfo.data.accessToken);
          print("a = $a");
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
  
  final List<List> general_list =[["Software Tracker"]];

  dynamic createProject(String projectName){
    setState(() {
      if(general_list.last.length<4){
        general_list.last.add(projectName);
      }else{
        general_list.add([projectName]);
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
                                  text: "Welcome",
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
                              //myUserInfo,
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
              itemCount: general_list.length,
              itemBuilder: (BuildContext context,int index){
                return Container(
                  height: 200,
                  child: ListView.builder(
                    //reverse: true,
                    scrollDirection: Axis.horizontal,
                    //padding: const EdgeInsets.all(10),
                    itemCount: general_list[index].length,
                    itemBuilder: (BuildContext context,int index2){
                      return ProjectItem(projectName: general_list[index][index2]);
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