import 'package:flutter/material.dart';
import 'package:frontend/views/home/home_view.dart';
import 'package:frontend/widgets/project/project.dart';
import 'dart:math' as math;

class DevelopmentView extends StatefulWidget {
  final Project myProject;
  DevelopmentView({Key key, this.myProject}) : super(key: key);

  @override
  _DevelopmentViewState createState() => _DevelopmentViewState(myProject);
}

class _DevelopmentViewState extends State<DevelopmentView> {
  final Project myProject;
  _DevelopmentViewState(this.myProject);

  List<dynamic> devComponents = [ ["Component1", "Desc", ["Var1","Var2","Var3","Var4"], ["Func1","Func2","Func3"] ] ] ;
  getUserComponents(){

  }
  addNewComponent(String name,String desc){
    setState(() {
      devComponents.add([name,desc,[],[]]);
    });
  }
  editComponent(int compIndex, String newCompName,String newCompDesc){
    setState(() {
      devComponents[compIndex][0] = newCompName;
      devComponents[compIndex][1] = newCompDesc;
    });
  }
  addVariable(int compIndex,String varName){
    setState(() {
      devComponents[compIndex][2].add(varName);
    });
  }

  addFunction(int compIndex, String funcName){
    setState(() {
      devComponents[compIndex][3].add(funcName);
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
          itemBuilder: (BuildContext context,int index){
            return devComponents.length != index 
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
                  Text(
                    devComponents[index][0],
                    style: TextStyle(
                      fontSize:25,
                      fontWeight: FontWeight.bold,
                      color:Colors.white,
                    ),
                  ),
                  Text(
                    devComponents[index][1],
                    style: TextStyle(
                      fontSize:15,
                      fontWeight: FontWeight.bold,
                      color:Colors.white,
                    ),
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
                                    addVariable(index, varNameController.text);
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