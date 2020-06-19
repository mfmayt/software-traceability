import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Models/arguments.dart';
import 'package:http/http.dart' as http;

import 'package:frontend/Models/archview_component.dart';
import 'package:frontend/helpers/api_manager.dart' as api;

class UserStories extends StatefulWidget {
  UserStories({Key key}) : super(key: key);

  @override
  _UserStoriesState createState() => _UserStoriesState();
}

class _UserStoriesState extends State<UserStories> {
  TextEditingController _controller;
  List<ArchViewComponent> userStories = [];
  List<String> choices = ['One', 'Two', 'Free', 'Four'];
  String dropdownValue = 'One';
  String projectID;
  String viewID;

  void fetchArchViewComponents(http.Client client) async {
    
    userStories = await api.APIManager.getArchViewComponents("e1c765cd-d8b8-4e64-b04e-25f30785a789", "04f8ea09-3c2a-4b9e-89b4-d39f766633c8");
    print(userStories.length);
    setState(() {
    });
  }
  
  @override void initState() {
    this.fetchArchViewComponents(http.Client());
    super.initState();
  }
  _addUserStory(){
    print("object");
  }

  @override
  Widget build(BuildContext context) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    this.projectID = args.projectID;
    this.viewID = args.viewID;
    print(projectID);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 28.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  "As a(n)", 
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
              ),
              Spacer(),
              Expanded(
                flex: 2,
                child: DropdownButton<String>(
                  hint: Align(alignment: Alignment.topLeft),
                  value: dropdownValue,
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValue = newValue;
                    });
                  },
                  items: choices
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
              ),
              Spacer(),
              Expanded(
                flex: 20,
                child: TextField(
                    controller: _controller,
                    onSubmitted: (String value) async {
                      await showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Thanks!'),
                            content: Text('You typed "$value".'),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        }
                      );
                    }
                  ),
                  ),
                  Spacer(),
                  Spacer(),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      onPressed: _addUserStory(), 
                      icon: Icon(Icons.add),
                    ),
                  ),
            ],
          ),
        ),
        new Expanded(
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              final userStory = userStories[index];

              return Padding(
                padding: const EdgeInsets.only(right: 22.0), //(8.0),
                child: ListTile(
                  leading: IconButton(
                    onPressed: null, 
                    icon: Icon(Icons.add),
                    ), // Image(image: AssetImage('assets/plus.png')),
                  title: Text(userStory.description),
                ),
              );
            },
            itemCount: userStories.length,
          ),
        ),
      ],
    );
  }
}