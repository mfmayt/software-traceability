import 'package:flutter/material.dart';

class DevelopmentView extends StatefulWidget {
  final String projectName;
  DevelopmentView({Key key, this.projectName}) : super(key: key);

  @override
  _DevelopmentViewState createState() => _DevelopmentViewState(projectName);
}

class _DevelopmentViewState extends State<DevelopmentView> {
  final String projectName;
  _DevelopmentViewState(this.projectName);
  @override
  Widget build(BuildContext context) {
    return Container(
       child: Center(child: Text("$projectName"),),
    );
  }
}