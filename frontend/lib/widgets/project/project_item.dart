import 'package:flutter/material.dart';

class ProjectItem extends StatelessWidget {
  final String title;

  const ProjectItem({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Text(title),
    );
  }
}