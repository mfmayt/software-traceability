import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Models/arguments.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/views/home/home_view.dart';
import 'package:frontend/views/login/login_view.dart';
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
    ScreenArguments args = new ScreenArguments(
      projectID: archviews[index].projectID,
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
    String projectName = ModalRoute.of(context).settings.arguments;
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        actions: <Widget>[
          IconButton(
            tooltip: "Return to Home",
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
            tooltip: "Logout",
            icon: Icon(Icons.exit_to_app), 
            onPressed: (){
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => LoginView(),
                ),
              );
            })
        ],
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                    "$projectName",
                    style: TextStyle(
                      fontSize: 50,
                      color:Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ),
            ),
            Expanded(
              flex: 4,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: archviews.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Container(
                        color: primaryColor,
                        height: 280,
                        width: 300,
                        child: archviews.length != index 
                        ? RaisedButton(
                            child: Text(
                              archviews[index].id,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18, 
                                fontWeight:FontWeight.w800,
                                color: Colors.white
                              )
                            
                            ),
                            onPressed:(){},
                          )
                        : IconButton(
                          icon: Icon(Icons.add),
                          onPressed: null)
                          //Image.asset("plus.png", color: Colors.red.withAlpha(123), width: 40, height: 40,)),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}