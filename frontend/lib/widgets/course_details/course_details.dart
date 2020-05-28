import 'package:flutter/material.dart';

class CourseDetails extends StatelessWidget {
  const CourseDetails({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 600,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'SOFTWARE TRACEABILITY',
            style: TextStyle(fontWeight:FontWeight.w800, height: 0.9,fontSize: 80),
            ),
          SizedBox(height: 30,),
          Text(
            'Software Traceability is really important.',
            style: TextStyle(fontSize: 21, height:1.7),
          )
        ],
      ),
    );
  }
}