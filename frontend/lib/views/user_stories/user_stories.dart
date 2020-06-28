import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Models/archview.dart';
import 'package:frontend/Models/arguments.dart';
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
    userStories = await api.APIManager.getArchViewComponents("e1c765cd-d8b8-4e64-b04e-25f30785a789", "04f8ea09-3c2a-4b9e-89b4-d39f766633c8");
    setState(() => {
    });
  }

  void fetchAllArchViewComponents(http.Client client) async {
    components = await api.APIManager.getAllArchViewComponents("e1c765cd-d8b8-4e64-b04e-25f30785a789");

    setState(() => {
    });
  }

  void fetchArchView(http.Client client) async {
    archView = await api.APIManager.getArchView("e1c765cd-d8b8-4e64-b04e-25f30785a789", "04f8ea09-3c2a-4b9e-89b4-d39f766633c8");
    setState(() => {
      choices = []..addAll(archView.userKinds),
      choices.add("Add new user kind"),
      dropdownValue = choices[0],
    });
  }
  
  @override void initState() {
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
    
    this.projectID = currentProject.id;
    this.viewID = currentProject.userStory;

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 28.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
              Spacer(),
              Expanded(
                flex: 2,
                child: DropdownButton<String>(
                  hint: Align(alignment: Alignment.topLeft),
                  value: dropdownValue,
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
                                  Navigator.pop(context);
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
              Expanded(
                flex: 10,
                child: TextField(
                    controller: _controller,
                    onSubmitted: (String value) async {
                      this.newUserStory = value;
                    }
                  ),
              ),
              Spacer(),
              Spacer(),
              Expanded(
                flex: 1,
                child: IconButton(
                  onPressed: (){
                    this._addUserStory();              
                  },
                  icon: Icon(Icons.add),
                ),
              ),
            ],
          ),
        ),
        new Expanded(
          child: ListView.builder(
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
            itemCount: userStories.length,
          ),
        ),
      ],
    );
  }
}