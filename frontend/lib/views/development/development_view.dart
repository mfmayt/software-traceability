import 'package:flutter/material.dart';
import 'package:frontend/Models/archview.dart';
import 'package:frontend/Models/archview_component.dart';
import 'package:frontend/views/home/home_view.dart';
import 'package:frontend/widgets/project/project.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:frontend/Models/link.dart';
import 'package:frontend/helpers/api_manager.dart' as api;
class DevelopmentView extends StatefulWidget {
  final Project myProject;
  DevelopmentView({Key key, this.myProject}) : super(key: key);

  @override
  _DevelopmentViewState createState() => _DevelopmentViewState(myProject);
}

class _DevelopmentViewState extends State<DevelopmentView> {
  final Project myProject;
  _DevelopmentViewState(this.myProject);

  List<ArchViewComponent> devComponents= [];
  List<dynamic> devComponentsCopy =[];
  List<ArchViewComponent> allComponents = [];
  List<List<String>> variables = [];
  List<List<String>> functions = [];
  List<String> compNames = [];
  List<bool> isEditable = [];
  String projectID;
  String viewID;
  ArchView archView;

  @override
  void initState() { 
    
    this.projectID = myProject.id;
    this.viewID = myProject.functionalView;

    fetchArchViewComponents(http.Client());
    fetchAllArchViewComponents(http.Client());
    fetchArchView(http.Client());
    
    super.initState();

    
  }
  //Gango function1
  void fetchArchViewComponents(http.Client client) async {
    devComponents = await api.APIManager.getArchViewComponents(projectID, viewID);
    setState(() => {
      for (var comp in devComponents) {
        isEditable.add(true),
        compNames.add(comp.description),
        if(comp.variables!=null){
          variables.add(comp.variables)
        },
        if(comp.functions!=null){
          functions.add(comp.functions)
        }
      }
    });
  }
  //Gango function2
  void fetchAllArchViewComponents(http.Client client) async {
    allComponents = await api.APIManager.getAllArchViewComponents(projectID);

    setState(() => {
    });
  }
  // Gango function3
  void fetchArchView(http.Client client) async {
    archView = await api.APIManager.getArchView(projectID, viewID);
    setState(() => {
    });
  }
  /*
  void updateComponent(ArchView archView,int index)async{
    bool a = await api.APIManager.patchArchView(archView, projectID, viewID);
    setState(() {
      if(a){
        //devComponents[index] = updatedComp;
      }
    });
    
  }
  */
  // Gango function4
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

  dynamic addComponent(int compIndex) async{
    
    ArchViewComponent component = ArchViewComponent(
      projectID: this.projectID, 
      viewID: this.viewID, 
      description: compNames[compIndex],
      variables: variables[compIndex],
      functions: functions[compIndex],
      kind: "development",);

    bool _ = await api.APIManager.addArchViewComponent(component, this.projectID, this.viewID);
    setState(() {
        if(_){
          devComponents.add(component);
        }
    });
  }
  
  
  editComponent(int compIndex, String newCompName){
    setState(() {
      compNames[compIndex] = newCompName;
    });
  }
  
  addVariable(int compIndex,String varName){
    setState(() {
      variables[compIndex].add(varName);
    });
  }

  addFunction(int compIndex, String funcName){
    setState(() {
      functions[compIndex].add(funcName);
    });
  }
  
  
  var compNameController = new TextEditingController();
  var compDescController = new TextEditingController();
  var varNameController  = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text( " Development View"),
        backgroundColor: Colors.blue,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add), 
            onPressed: () {
              // Creates a pop up.
              showDialog(
                context: context,
                builder: (_)=> AlertDialog(
                    title: Text("Enter a name for your class"),
                    content: TextField(
                      maxLength: 30,
                    ),
                    actions: [
                      FlatButton(
                        child: Text("Confirm"),
                        onPressed: () {
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
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: GridView.builder(
          itemCount: devComponents.length+1,
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 30,
            childAspectRatio: 1,
            crossAxisSpacing: 30

          ),
          itemBuilder: (BuildContext context,int compIndex){
            return devComponents.length != compIndex 
            ?Container(
              decoration: BoxDecoration(
                color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
                border: Border.all(
                  color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
                  width: 4,
                ),
                borderRadius: BorderRadius.circular(8)
              ),
              child: ListView(
                padding: EdgeInsets.all(10),
                children: <Widget>[
                  Row(
                    children: [
                      Text(
                        devComponents[compIndex].description,
                        style: TextStyle(
                          fontSize:25,
                          fontWeight: FontWeight.bold,
                          color:Colors.white,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.insert_link,
                          color: Colors.white,
                        ), 
                        onPressed: (){
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(

                            )
                          );
                        }
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Variables:",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                      ),
                      IconButton(
                        tooltip:"Add variable",
                        icon: Icon(Icons.add_circle_outline,color: Colors.white,), 
                        onPressed: (){
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Text("Enter name of variable"),
                              content: TextField(
                                maxLength:30,
                                controller:varNameController,
                              ),
                              actions: [
                                FlatButton(
                                  color: Colors.blue,
                                  child: Text("Confirm"),
                                  onPressed: (){
                                    addVariable(compIndex, varNameController.text);
                                    varNameController.clear();
                                    Navigator.of(context, rootNavigator: true).pop('dialog');
                                  },
                                ),
                              ],
                            )
                            
                          );
                        }
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color : Colors.white,
                      ),
                    ),
                    height: 60,
                    child: Row(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            itemCount: devComponents[index][2].length,
                            itemBuilder: (BuildContext contex,int varIndex){
                              return Text(
                                devComponents[index][2][varIndex],
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                                ),
                              );
                            }
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "Functions:",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                      ),
                      IconButton(
                        tooltip:"Add function",
                        icon: Icon(Icons.add_circle_outline,color: Colors.white,), 
                        onPressed: (){
                          
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Text("Enter name of function"),
                              content: TextField(
                                maxLength:30,
                                controller:varNameController,
                              ),
                              actions: [
                                FlatButton(
                                  color: Colors.blue,
                                  child: Text("Confirm"),
                                  onPressed: (){
                                    addFunction(index, varNameController.text);
                                    varNameController.clear();
                                    Navigator.of(context, rootNavigator: true).pop('dialog');
                                  },
                                ),
                              ],
                            )
                          );
                        }
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color : Colors.white,
                      ),
                    ),
                    height: 60,
                    child: Row(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            itemCount: devComponents[index][3].length,
                            itemBuilder: (BuildContext contex,int funcIndex){
                              return Text(
                                devComponents[index][3][funcIndex],
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                                ),
                              );
                            }
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        tooltip: "Edit this component",
                        color:Colors.white, 
                        icon: Icon(Icons.edit),
                        onPressed: (){
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text("Edit this component"),
                              content: Container(
                                height: 200,
                                width: 200,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text("Name : "),
                                    TextField(
                                      controller: compNameController,
                                      maxLength: 30,
                                    ),
                                    Text("Description : "),
                                    TextField(
                                      controller: compDescController,
                                      maxLength: 150,
                                    ),
                                  ]
                                ),
                              ),
                              actions: [
                                FlatButton(
                                  onPressed: (){
                                    editComponent(index,compNameController.text,compDescController.text);
                                    compNameController.clear();
                                    compDescController.clear();
                                    Navigator.of(context, rootNavigator: true).pop('dialog');
                                  }, 
                                  child: Text("confirm")
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  )
                  
                ],
              ),
            )
            :Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.blue,
                  width: 4,
                ),
                borderRadius: BorderRadius.circular(8)
              ),
              height: 50,
              width: 50,
              child: Center(
                child: IconButton(
                  icon: Icon(Icons.add_circle),
                  color: Colors.blue,
                  tooltip: "Add New Component",
                  onPressed: (){
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text("Create your component"),
                        content: Container(
                          height: 200,
                          width: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Name : "),
                              TextField(
                                controller: compNameController,
                                maxLength: 30,
                              ),
                              Text("Description : "),
                              TextField(
                                controller: compDescController,
                                maxLength: 150,
                              ),
                            ]
                          ),
                        ),
                        actions: [
                          FlatButton(
                            onPressed: (){
                              addNewComponent(compNameController.text,compDescController.text);
                              compNameController.clear();
                              compDescController.clear();
                              Navigator.of(context, rootNavigator: true).pop('dialog');
                            }, 
                            child: Text("confirm")
                          )
                        ],
                      ),
                    );
                  },
                ),
              )
            );
          } 
        ),
      ),
    );
  }
}