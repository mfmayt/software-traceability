import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Models/archview.dart';
import 'package:frontend/views/inspect/inspect_view.dart';
import 'package:frontend/views/login/login_view.dart';
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
  
  TextEditingController _controller = new TextEditingController();
  List<ArchViewComponent> userStories = [];
  ArchView archView;
  List<String> choices = [''];
  String dropdownValue = '';
  String projectID;
  String viewID;
  String newUserStory;
  String newUserKind;
  List<ArchViewComponent> components = [];
  List<String> vowels =["a", "e", "i", "o", "u"];
  

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
                border:Border.all(width: 4,color: Colors.black.withOpacity(0.3)),
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
                                  onChanged: (String value) async {
                                    this.newUserKind = value;
                                  },
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                    onPressed: () {
                                      _addNewUserKind();
                                      Navigator.of(context, rootNavigator: true).pop('dialog');
                                      _controller.clear();
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
                          onChanged: (String value) async {
                            this.newUserStory = value;
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
                        _controller.clear();          
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
                            barrierDismissible: false,
                            context: context,
                            builder: (context){
                              List<bool> _isSelectedList = [];
                              for (var i = 0; i < components.length; i++) {
                                _isSelectedList.add(false);
                              }
                              return StatefulBuilder(
                                builder: (context , setState2){
                                  return AlertDialog(
                                    elevation: 24.0,
                                    title: Text("Select components to link"),
                                    content: Container(
                                      width: 400,
                                      child: ListView.builder(
                                        itemCount: components.length,
                                        itemBuilder: (BuildContext context,int compIndex2){
                                          return CheckboxListTile(
                                            value: _isSelectedList[compIndex2],
                                            title: Text(components[compIndex2].description),
                                            onChanged: (bool newValue){
                                              setState2(() {
                                                _isSelectedList[compIndex2] = newValue;
                                              });
                                              //print(components.length);
                                              //print(_isSelectedList.length);
                                            },
                                            secondary: Icon( components[compIndex2].kind == "userStory" ? Icons.people : (components[compIndex2].kind == "functional" ? Icons.build : Icons.computer)),

                                          );
                                        }
                                      ),
                                    ),
                                    actions: [
                                      FlatButton(
                                        child: Text("Confirm"),
                                        onPressed: () {
                                          //
                                          for (var i = 0; i < components.length; i++) {
                                            if (_isSelectedList[i]==true) {
                                              //print(components[i].description);
                                              _addLink(userStory.id, components[i].id);
                                            }
                                          }
                                          Navigator.of(context, rootNavigator: true).pop('dialog');
                                        },
                                      ),
                                    ],
                                  );
                                }
                              );
                            },
                          );        
                      },
                      icon: Icon(Icons.add),
                      ),
                      trailing: IconButton(
                        tooltip: "Open Linked Components",
                        onPressed: (){
                          Navigator.push(
                            context, 
                            MaterialPageRoute(
                              builder: (context) =>InspectView(currentComponent: userStory,currentProject: currentProject,),
                            ),
                          );
                        },
                        icon: Icon(Icons.details),
                      ),
                    title: Text("As "+ (vowels.contains(userStory.userKind[0])?"an ":"a ") + userStory.userKind + ", " + userStory.description),
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