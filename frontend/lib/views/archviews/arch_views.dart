import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Models/arguments.dart';
import 'package:http/http.dart' as http;

import 'package:frontend/Models/archview.dart';
import 'package:frontend/helpers/api_manager.dart' as api;
import 'package:frontend/views/user_stories/user_stories.dart';

class ArchViewList extends StatefulWidget {
  ArchViewList({Key key}) : super(key: key);
  @override
  _ArchViewListState createState() => _ArchViewListState();
}

class _ArchViewListState extends State<ArchViewList> {
  List<ArchView> archviews = [];

  void fetchArchViews(http.Client client) async {
    archviews = await api.APIManager.getProjectArchViews("e1c765cd-d8b8-4e64-b04e-25f30785a789", "");
    print(archviews.length);
    setState(() {
    });
  }

  void cardSelectedAt(int index){
    print(index);
    print(archviews[index].projectID);
    ScreenArguments args = new ScreenArguments(projectID: archviews[index].projectID,
        viewID: archviews[index].id);
    print(args);
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => UserStories(),
        settings: RouteSettings(arguments: args)
      ),
    );
  }

  @override void initState() {
    this.fetchArchViews(http.Client());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GridView.builder(
        itemCount: archviews.length + 1,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () => setState(() => cardSelectedAt(index)),
             child: new Card(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: new GridTile(
                  child: Center(child: archviews.length != index ? new Text(archviews[index].id) : Image.asset("plus.png", color: Colors.red.withAlpha(123), width: 100, height: 100,)),
                ),
              ),
              color: Colors.lightBlue.withAlpha(125),
              shadowColor: Colors.indigo,
            
            ),
          );
        },
      ),
    );
  }
}