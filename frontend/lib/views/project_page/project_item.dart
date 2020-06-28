import 'package:flutter/material.dart';
import 'package:frontend/views/archviews/arch_views.dart';
import 'dart:math' as math;

import 'package:frontend/widgets/project/project.dart';
import 'package:frontend/widgets/user/user.dart';

class ProjectItem extends StatelessWidget {
  final Project currentProject;
  final User  currentUser;
  const ProjectItem({Key key, this.currentProject, this.currentUser}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10,10,10,10),
      height:200,
      width:200,
      child: Card(
        color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
        elevation: 5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                currentProject.name,
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
                    builder: (context) => ArchViewList(currentProject: currentProject,currentUser: currentUser,)
                  ),
                );
              },
            )
          ],
        )
      ),
    );
  }
}