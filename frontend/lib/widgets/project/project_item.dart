import 'package:flutter/material.dart';
import 'dart:math' as math;
class ProjectItem extends StatelessWidget {
  final String title;

  const ProjectItem({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var projects;
    return Card(
    child: Container(
      width: 800,
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(10),
        itemCount: projects.length,
        itemBuilder: (BuildContext context,int index){
          return Container(
            padding: EdgeInsets.fromLTRB(10,10,10,10),
            height:220,
            width:200,
            child: Card(
              color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
              elevation: 5,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "${projects[index]}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize:20,
                        fontWeight: FontWeight.bold
                      )
                    ),
                  ),
                  IconButton(
                    alignment: Alignment.bottomRight,
                    icon: Icon(Icons.search),
                    onPressed: () {
                    },
                  )
                ],
              )
            ),
            );
          },
        ),
      ),
    );
  }
}