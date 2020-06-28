import 'package:flutter/material.dart';
import 'package:frontend/Models/archview_component.dart';

class InspectView extends StatefulWidget {
  final ArchViewComponent currentComponent;
  InspectView({Key key, this.currentComponent}) : super(key: key);

  @override
  _InspectViewState createState() => _InspectViewState(currentComponent);
}

class _InspectViewState extends State<InspectView> {
  final ArchViewComponent currentComponent;

  _InspectViewState(this.currentComponent);
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
             borderRadius: BorderRadius.circular(12),
             border: Border.all(
               color: Colors.blue,
               width: 5
             )

            ),
            child: Text(
              "Component Name",
              style: TextStyle(
                color: Colors.white,
                fontSize:50,
                fontWeight: FontWeight.bold
               )
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
              Expanded(flex: 1,child: Container(),),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border:Border.all(
                        color: Colors.pink,
                        width: 5
                      )
                    ),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 10,
                        childAspectRatio: 10,
                        crossAxisSpacing: 10,
                      ),
                      padding: EdgeInsets.all(10),
                      itemCount: 10,
                      itemBuilder: (BuildContext context, int index){
                       return Container(color:Colors.pink,child: Text("comp $index"),);
                      }
                    ),
                  ),
                ),
              ),
              Expanded(flex: 1,child: Container()),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border:Border.all(
                        color: Colors.purple,
                        width: 5
                      )
                    ),
                    child: GridView.builder(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        childAspectRatio: 4,
                        crossAxisSpacing: 10,
                      ),
                      itemCount: 10,
                      itemBuilder: (BuildContext context, int index){
                       return Container(color: Colors.purple,child: Text("comp $index"),);
                      }
                    ),
                  ),
                ),
              ),
              Expanded(flex: 1,child: Container())
            ]
          ),
        )
      ],
     )
    );
  }
}