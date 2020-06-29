import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Models/archview.dart';
import 'package:frontend/views/home/home_view.dart';
import 'package:frontend/views/login/login_view.dart';
import 'package:frontend/views/main/main_screen.dart';
import 'package:frontend/widgets/project/project.dart';
import 'package:http/http.dart' as http;

import 'package:frontend/Models/archview_component.dart';
import 'package:frontend/Models/link.dart';
import 'package:frontend/helpers/api_manager.dart' as api;

class UserStories extends StatefulWidget {
  final Project currentProject;
  UserStories({Key key, this.currentProject}) : super(key: key);

  @override
  _UserStoriesState createState() => _UserStoriesState(currentProject);
}

class _UserStoriesState extends State<UserStories> {
  final Project currentProject;
  _UserStoriesState(this.currentProject);
  
  TextEditingController _controller;
  List<ArchViewComponent> userStories = [];
  ArchView archView;
  List<String> choices = [''];
  String dropdownValue = '';
  String projectID;
  String viewID;
  String newUserStory;
  String newUserKind;
  List<ArchViewComponent> components = [];

  

  void fetchArchViewComponents(http.Client client) async {
    userStories = await api.APIManager.getArchViewComponents(projectID, viewID);
    setState(() => {
    });
  }

  void fetchAllArchViewComponents(http.Client client) async {
    components = await api.APIManager.getAllArchViewComponents(projectID);

    setState(() => {
    });
  }

  void fetchArchView(http.Client client) async {
    archView = await api.APIManager.getArchView(projectID, viewID);
    setState(() => {
      choices = []..addAll(archView.userKinds),
      choices.add("Add new user kind"),
      dropdownValue = choices[0],
    });
  }
  
  @override void initState() {
    this.projectID = currentProject.id;
    this.viewID = currentProject.userStory;
    this.fetchArchViewComponents(http.Client());
    this.fetchArchView(http.Client());
    this.fetchAllArchViewComponents(http.Client());
    
    super.initState();
  }
  
  _addUserStory() async{
    ArchViewComponent component = ArchViewComponent(
      projectID: this.projectID, 
      viewID: this.viewID, 
      description: this.newUserStory,
      userKind: this.dropdownValue,
      kind: "userStory",);

    bool _ = await api.APIManager.addArchViewComponent(component, this.projectID, this.viewID);
    setState(() {
        this.fetchArchViewComponents(http.Client());
    });
  }
  _addNewUserKind() async{
    this.archView.userKinds.add(newUserKind);

    bool _ = await api.APIManager.patchArchView(this.archView, projectID, viewID);
    setState(() {
        this.fetchArchView(http.Client());
    });

  }

  _addLink(String from, String to) async {
    Link l = Link(
      from: from,
      to: to,
      projectID: projectID,
      kind: "required",
    );
    Link addedLink = await api.APIManager.addLink(l);
    print(addedLink.id);
  }

  @override
  Widget build(BuildContext context) {
    //final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    //this.projectID = args.projectID;
    //this.viewID = args.viewID;
    
    Widget _setupAlertDialoadContainer(String from) {       
    return Container(
      height: 400.0,
      width: 600.0,
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[ 
          ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: components.length,
          itemBuilder: (BuildContext context, int index){
            final component = components[index];
          
            return ListTile(
              title: Text(component.description),
              onTap: ()=>{
                   _addLink(from, component.id)
                },
              leading: Icon( component.kind == "userStory" ? Icons.people : (component.kind == "functional" ? Icons.build : Icons.computer)),
            );
          },
        ),
        ]
      ),
    );
  }
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
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
        body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 28.0,right: 20,top: 10),
            child: Container(
              decoration: BoxDecoration(
                border:Border.all(width: 4,color: Colors.black),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Spacer(),
                  //As an text
                  Expanded(
                    flex: 2,
                    child: Text(
                      "As a(n)", 
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                  ),
                  
                  //DropDownButton
                  Expanded(
                    flex: 3,
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: Align(alignment: Alignment.topLeft),
                      value: dropdownValue,
                      underline: Container(
                        height: 2,
                        color: Colors.purple,
                      ),
                      onChanged: (String newValue) async{
                        if (newValue == "Add new user kind"){
                          await showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Type new user kind'),
                                content: TextField(
                                  controller: _controller,
                                  onSubmitted: (String value) async {
                                    this.newUserKind = value;
                                  }
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                    onPressed: () {
                                      _addNewUserKind();
                                      Navigator.of(context, rootNavigator: true).pop('dialog');
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            }
                          );
                        }
                        setState(() {
                          dropdownValue = newValue;
                        });
                      },
                      items: choices
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                  ),
                  Spacer(),
                  //TextField, input for user stories.
                  Expanded(
                    flex: 9,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                      child: TextField(
                          cursorColor: Colors.purple,
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide:BorderSide(color: Colors.purple,width: 2)
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:BorderSide(color: Colors.purple,width: 2)
                            )
                          ),
                          controller: _controller,
                          onSubmitted: (String value) async {
                            this.newUserStory = value;
                            _controller.clear();
                          }
                        ),
                    ),
                  ),
                  
                  //Add button
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      onPressed: (){
                        this._addUserStory();              
                      },
                      icon: Icon(Icons.add,color: Colors.purple,),
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
          new Expanded(
            child: ListView.builder(
              itemCount: userStories.length,
              itemBuilder: (BuildContext context, int index) {
                final userStory = userStories[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 22.0),
                  child: ListTile(
                    leading: IconButton(
                      onPressed: (){
                        showDialog(
                          context: context,
                          builder: (BuildContext context){
                            return AlertDialog(
                              title: Text("Select from list!"),
                              content: _setupAlertDialoadContainer(userStory.id),
                            );
                          }  
                        );        
                      },
                      icon: Icon(Icons.add),
                      ),
                      trailing: IconButton(
                        onPressed: (){
                          showDialog( // TODO: should navigate a new screen and show listed components
                            context: context,
                            builder: (BuildContext context){
                              return AlertDialog(
                                title: Text("Linked Components desc"),
                              );
                            },
                            );
                        },
                        icon: Icon(Icons.details),
                      ),
                    title: Text(userStory.description),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}