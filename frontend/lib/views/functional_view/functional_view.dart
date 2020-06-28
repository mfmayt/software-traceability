import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/views/home/home_view.dart';
import 'package:frontend/widgets/project/project.dart';
class FunctionalView extends StatefulWidget {
  final String projectName ;
  final Project currentProject;
  FunctionalView({Key key, this.projectName, this.currentProject}) : super(key: key);

  @override
  _FunctionalViewState createState() => _FunctionalViewState(projectName);
}

class _FunctionalViewState extends State<FunctionalView> {
  final String projectName ;
  _FunctionalViewState(this.projectName);
  
  List<List<dynamic>> layers ;
  
  @override
  void initState() { 
    super.initState();
    layers= [ ["Root",projectName] ];
  }
  
  dynamic addLayer(String layerName){
    setState(() {
      layers.add([layerName,""]);
    });
  }

  dynamic addComponent(String componentName,int level){
    setState(() {
      layers[level].add(componentName);
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
    final String projectName = ModalRoute.of(context).settings.arguments;
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
        itemCount: layers.length,
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

