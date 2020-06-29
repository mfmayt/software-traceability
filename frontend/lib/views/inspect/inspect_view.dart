import 'package:flutter/material.dart';
import 'package:frontend/Models/archview_component.dart';
import 'package:frontend/widgets/project/project.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/helpers/api_manager.dart' as api;

class InspectView extends StatefulWidget {
  final ArchViewComponent currentComponent;
  final Project currentProject;
  InspectView({Key key, this.currentComponent, this.currentProject}) : super(key: key);

  @override
  _InspectViewState createState() => _InspectViewState(currentComponent,currentProject);
}

class _InspectViewState extends State<InspectView> {
  final ArchViewComponent currentComponent;
  final Project currentProject;
  String projectID;
  String componentID;
  List<ArchViewComponent> linkedUserStories=[];
  List<ArchViewComponent> linkedFuncViews = [];
  List<ArchViewComponent> linkedDeveloperViews=[];
  List<ArchViewComponent> linkedComponents;
  _InspectViewState(this.currentComponent, this.currentProject);
  Color border1 = Color(0xff979797);
  Color border2 = Color(0xffdbdbdb);
  Color border3 = Color(0xff7a7a7a);
  Color box1 = Color(0xfffcc802).withOpacity(0.6);
  Color box2 = Color(0xff5a487e).withOpacity(0.4);
  Color box3 = Color(0xfff491a5).withOpacity(0.6);
  @override
  void initState() {
    this.projectID = currentProject.id;
    this.componentID = currentComponent.id;
    this.fetchLinkedComponents(http.Client());
    super.initState();
  }

  void fetchLinkedComponents(http.Client client) async {
    linkedComponents = await api.APIManager.listLinkedComponents(projectID, componentID);
    setState(() => {
      for (ArchViewComponent comp in linkedComponents) {
        if(comp.kind=="userStory"){
          linkedUserStories.add(comp)
        }
        else if(comp.kind=="development"){
          linkedDeveloperViews.add(comp)
        }
        else{
          linkedFuncViews.add(comp)
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
      ),
      body: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width*0.5,
            decoration: BoxDecoration(
             color:Colors.blue,
             borderRadius: BorderRadius.circular(8),
             border: Border.all(
               color: Colors.blue,
               width: 5
             )

            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon( currentComponent.kind == "userStory" ? Icons.people : (currentComponent.kind == "functional" ? Icons.build : Icons.computer),size: 36,color: Colors.white, ),
                Container(width: 16,),

                Text(
                  currentComponent.description,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize:50,
                    fontWeight: FontWeight.bold
                   )
                 ),
              ],
            ),
          ),
        ),
        Text(
          "Related Components: ",
          style: TextStyle(
            color: Colors.blue,
            fontSize:40,
            fontWeight: FontWeight.bold
          ),
        ),
        Expanded(
          child: Row(
            children:<Widget>[
              //Just space
              Expanded(flex: 1,child: Container(),),
              //Related compenent list1
              //If current component type is not userStory then this component list will be userStory type.
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border:Border.all(
                        color: border1,
                        width: 5
                      )
                    ),
                    child: Column(
                      children: [
                        Text("User Stories",style: TextStyle(fontSize:22,fontWeight: FontWeight.w600),),
                        Expanded(
                          child: GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              mainAxisSpacing: 10,
                              childAspectRatio: 8,
                              crossAxisSpacing: 10,
                            ),
                            padding: EdgeInsets.all(10),
                            itemCount: (linkedUserStories!=null)?linkedUserStories.length:0,
                            itemBuilder: (BuildContext context, int index){
                             return Container(
                              decoration: BoxDecoration(
                                color:box1,
                                borderRadius: BorderRadius.circular(8)
                               ),
                               child: Center(
                                 child: Text(
                                   linkedUserStories[index].description,
                                   style: TextStyle(

                                   )
                                  ),
                               ),
                              );
                            }
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(flex: 1,child: Container()),
              //If current component type is userStory then this component list will be development type.
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border:Border.all(
                        color: border3,
                        width: 5
                      )
                    ),
                    child: Column(
                      children: [
                        Text("Development Views",style: TextStyle(fontSize:22,fontWeight: FontWeight.w600),),
                        Expanded(
                          child: GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              childAspectRatio: 4,
                              crossAxisSpacing: 10,
                            ),
                            padding: EdgeInsets.all(10),
                            itemCount: (linkedDeveloperViews!=null)?linkedDeveloperViews.length:0,
                            itemBuilder: (BuildContext context, int index){
                             return Container(
                              decoration: BoxDecoration(
                                color:box3,
                                borderRadius: BorderRadius.circular(8)
                               ),
                               child: Center(
                                 child: Text(
                                   linkedDeveloperViews[index].description,
                                   style: TextStyle(

                                   )
                                  ),
                               ),
                              );
                            }
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //Space again
              Expanded(flex: 1,child: Container()),
              //Related compenent list2
              
              //If current component type is functional then this component list will be development type.
              
              //If current component type is not functional then this component list will be functional type.
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border:Border.all(
                        color: border2,
                        width: 5
                      )
                    ),
                    child: Column(
                      children: [
                        Text("Functional Views",style: TextStyle(fontSize:22,fontWeight: FontWeight.w600),),
                        Expanded(
                          child: GridView.builder(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              childAspectRatio: 4,
                              crossAxisSpacing: 10,
                            ),
                            itemCount: (linkedFuncViews!=null)?linkedFuncViews.length:0,
                            itemBuilder: (BuildContext context, int index){
                             return Container(
                              decoration: BoxDecoration(
                                color:box2,
                                borderRadius: BorderRadius.circular(8)
                               ),
                               child: Center(
                                 child: Text(
                                   linkedFuncViews[index].description,
                                   style: TextStyle(

                                   )
                                  ),
                               ),
                              );
                            }
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Last Space
              Expanded(flex: 1,child: Container())
            ]
          ),
        )
      ],
     )
    );
  }
}