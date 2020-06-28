import 'dart:html';

import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/views/home/home_view.dart';
import 'package:frontend/widgets/project/project.dart';
import 'package:frontend/Models/archview_component.dart';
import 'package:frontend/Models/archview.dart';
import 'package:http/http.dart' as http;

import 'package:frontend/Models/link.dart';
import 'package:frontend/helpers/api_manager.dart' as api;


class FunctionalView extends StatefulWidget {
  final Project currentProject;
  
  FunctionalView({Key key, this.currentProject}) : super(key: key);

  @override
  _FunctionalViewState createState() => _FunctionalViewState(currentProject);

}

class _FunctionalViewState extends State<FunctionalView> {
  final Project currentProject;
  _FunctionalViewState(this.currentProject);

  
  List<List<ArchViewComponent>> layers =[];
  String projectID;
  String viewID;
  List<ArchViewComponent> components = [];
  List<ArchViewComponent> functionalComponents = [];
  ArchView archView;

  @override
  void initState() {
    this.projectID = currentProject.id;
    this.viewID = currentProject.functionalView;

    fetchArchViewComponents(http.Client());
    fetchAllArchViewComponents(http.Client());
    fetchArchView(http.Client());

    super.initState();
  }
  
  dynamic addLayer(String layerName){
    setState(() {
      layers.add([]);
    });
  }
   void fetchArchViewComponents(http.Client client) async {
    functionalComponents = await api.APIManager.getArchViewComponents(projectID, viewID);
    functionalComponents.sort((a, b) => a.level.compareTo(b.level));
    
    for (var funcComp in functionalComponents) {
      if(funcComp.level>=layers.length){
        layers.add([funcComp]);
      }else{
        layers[funcComp.level].add(funcComp);
      }  
      
      
    }
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
    });
  }

  dynamic addComponent(String componentName,int level) async{
    
    ArchViewComponent component = ArchViewComponent(
      projectID: this.projectID, 
      viewID: this.viewID, 
      description: componentName,
      level: level,
      kind: "functional",);

    bool _ = await api.APIManager.addArchViewComponent(component, this.projectID, this.viewID);
    setState(() {
        if(_){
          layers[component.level].add(component);
        }
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
    print("ADDED LINK = ${addedLink.id}");
  }
  
  var layerNameController = new TextEditingController();
  var componentNameController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    final String projectName = currentProject.name;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text("Funcional View of $projectName"),
        backgroundColor: primaryColor,
        actions: <Widget>[
          IconButton(
            tooltip: "Add Layer",
            icon: Icon(Icons.add), 
            onPressed: () {
              // Creates a pop up.
              showDialog(
                context: context,
                builder: (_)=> AlertDialog(
                    title: Text("Enter a name for this layer"),
                    content: TextField(
                      maxLength: 30,
                      controller: layerNameController,
                    ),
                    actions: [
                      FlatButton(
                        child: Text("Confirm"),
                        onPressed: () {
                          addLayer(layerNameController.text);
                          layerNameController.clear();
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
            tooltip: "Return Home",
            icon: Icon(Icons.home), 
            onPressed: (){
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) =>HomeView(),
                ),
              );
            }
          ),
          IconButton(
            tooltip: "Back to project page",
            icon: Icon(Icons.exit_to_app), 
            onPressed: (){
              Navigator.pop(context);
            })
        ],
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: layers == null ? 0 : layers.length,
        itemBuilder: (BuildContext context,int level){
          return Column(
            children: [
              Row(
                children: [
                  Container(
                    color: Colors.amber,
                    height: 150,
                    width: 180,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          /*
                          Text(
                            "${layers[index][0]} Level",
                            style:TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                            )
                          ),
                          */
                          Text(
                            "Level $level",
                            style:TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 30
                            ) ,
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 150,
                      color: Colors.purple,
                      child: Center(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: layers[level].length,
                          itemBuilder: (BuildContext context,int compIndex){
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  color: Colors.blue,
                                  height: 140,
                                  width: 150,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        layers[level][compIndex].description,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 18, 
                                          fontWeight:FontWeight.w800,
                                          color: Colors.white
                                        )
                                      ),
                                      RaisedButton(
                                        color: Colors.green,
                                        child: Text("Link"),
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
                                                        itemBuilder: (BuildContext context,int compIndex){
                                                          return CheckboxListTile(
                                                            value: _isSelectedList[compIndex],
                                                            title: Text(components[compIndex].description),
                                                            onChanged: (bool newValue){
                                                              setState2(() {
                                                                _isSelectedList[compIndex] = newValue;
                                                              });
                                                              //print(components.length);
                                                              //print(_isSelectedList.length);
                                                            },
                                                            secondary: Icon( components[compIndex].kind == "userStory" ? Icons.people : (components[compIndex].kind == "functional" ? Icons.build : Icons.computer)),
              
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
                                                              _addLink(layers[level][compIndex].id, components[i].id);
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
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.amber,
                    height: 150,
                    width: 180,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Add Component to this level",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            ),
                          IconButton(
                            tooltip: "Add Component",
                            color: Colors.black,
                            icon: Icon(Icons.plus_one), 
                            onPressed: (){
                              showDialog(
                                context: context,
                                builder: (_)=> AlertDialog(
                                    title: Text("Enter a name for this component"),
                                    content: TextField(
                                      maxLength: 30,
                                      controller: componentNameController,
                                    ),
                                    actions: [
                                      FlatButton(
                                        child: Text("Confirm"),
                                        onPressed: () {
                                          addComponent(componentNameController.text,level);
                                          componentNameController.clear();
                                          Navigator.of(context, rootNavigator: true).pop('dialog');
                                        },
                                      ),
                                    ],
                                    elevation: 24.0,
                                    
                                ),
                                barrierDismissible: false,
                              );
                            }
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                height: 10,
                thickness: 5,
                color: Colors.grey,
              )
            ],
          );
        }
      ),
    );
  }
}

