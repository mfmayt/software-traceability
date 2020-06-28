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

  
  List<List<dynamic>> layers;
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
      layers.add([layerName]);
    });
  }
   void fetchArchViewComponents(http.Client client) async {
    layers = [["Root"]];
    functionalComponents = await api.APIManager.getArchViewComponents(projectID, viewID);
    functionalComponents.sort((a, b) => a.level.compareTo(b.level));

    int lastLevel = functionalComponents[0].level;
    for (var i = 0 ; i < functionalComponents.length ; i++){
      int newLevel = functionalComponents[i].level;
      if (lastLevel != newLevel){
        addLayer(newLevel.toString());
      }
      print(functionalComponents[i].level);
      layers[functionalComponents[i].level].add(functionalComponents[i].description);
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
        this.fetchArchViewComponents(http.Client());
    });
  }
  dynamic renameComponent(String newComponentName,int level,int index){
    setState(() {
      layers[level][index+1] = newComponentName;
    });
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
        itemBuilder: (BuildContext context,int index){
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
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          
                          Text(
                            "${layers[index][0]} Level",
                            style:TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                            )
                          ),
                          
                          Text(
                            "Level $index",
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
                          itemCount: layers[index].length-1,
                          itemBuilder: (BuildContext context,int index2){
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  height: 140,
                                  width: 150,
                                  child: RaisedButton(
                                    color: Colors.blue,
                                    child: Text(
                                      "${layers[index][index2+1]}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18, 
                                        fontWeight:FontWeight.w800,
                                        color: Colors.white
                                      )
                                    ),
                                    onPressed: (){
                                      showDialog(
                                        context: context,
                                        builder: (_)=> AlertDialog(
                                            title: Text("Rename this component"),
                                            content: TextField(
                                              maxLength: 30,
                                              controller: componentNameController,
                                            ),
                                            actions: [
                                              FlatButton(
                                                child: Text("Confirm"),
                                                onPressed: () {
                                                  renameComponent(componentNameController.text,index,index2);
                                                  componentNameController.clear();
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
                                          addComponent(componentNameController.text,index);
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

