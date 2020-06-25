import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:frontend/views/project_page/project_screen.dart';

class ProjectItem extends StatelessWidget {
  final String projectName;
  const ProjectItem({Key key, this.projectName}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        padding: EdgeInsets.fromLTRB(10,10,10,10),
        height:200,
        width:200,
        child: Card(
          color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
          elevation: 5,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "$projectName",
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
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => ProjectScreen(),
                      settings: RouteSettings(arguments: "$projectName"),
                    ),
                  );
                },
              )
            ],
          )
        ),
      )
    );
  }
}