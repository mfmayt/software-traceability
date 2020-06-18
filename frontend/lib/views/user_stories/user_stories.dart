import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:frontend/constants/app_colors.dart';


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

  Future<List<ArchViewComponent>> fetchArchViews(http.Client client) async {
    final String url =  baseUrl + "/projects/e1c765cd-d8b8-4e64-b04e-25f30785a789/views/04f8ea09-3c2a-4b9e-89b4-d39f766633c8/components";
    final response = await http.get(
      url,
      headers: {
        HttpHeaders.authorizationHeader: "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1OTQ1NDQzODUsImlhdCI6MTU5MDk0NDM4NSwidXNlcmlkIjoiNWMxNDBlOTEtZWZmMS00ODVmLWI3MWUtNDY4MGEyMDEzNmIxIn0.XhI800q0n_mfjOg1v1_2aub6y5ehnQQno2vvn3__oC0",
        HttpHeaders.contentTypeHeader: 'application/json'
        },
    );
    return compute(parseArchViewComponents, response.body);
  }

  List<ArchViewComponent> parseArchViewComponents(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    setState(() {
        this.userStories = parsed.map<ArchViewComponent>((json) => ArchViewComponent.fromJson(json)).toList();
        print(userStories.length);
    });
    return this.userStories;
  }

  @override void initState() {
    this.fetchArchViews(http.Client());
    super.initState();
  }
  _addUserStory(){
    print("object");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 28.0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Text("As a(n)"),
              ),
              Expanded(
                flex: 2,
                child: DropdownButton<String>(
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

class ArchViewComponent {
    final String id;
    final String userKind;
    final String projectID;
    final String viewID;
    final String description;
    final List<String> links;
    final List<String> functions;
    final List<String> variables;

    ArchViewComponent({this.id, this.description, this.projectID, this.userKind, this.functions, this.variables, this.links, this.viewID});

    factory ArchViewComponent.fromJson(Map<String, dynamic> json) {
      return ArchViewComponent(
        id: json['id'] as String,
        description: json['description'] as String,
        projectID: json['projectID'] as String,
        viewID: json['viewID'] as String,
        userKind: json['userKind'] as String,
        functions: json["functions"] != null ? List.from(json["functions"]) : null,
        links: json["links"] != null ? List.from(json["links"]) : null,
        variables: json["variables"] != null ? List.from(json["variables"]) : null,
      );
    }
  }

class CustomPopupMenu {
  CustomPopupMenu({this.title, this.icon});
  String title;
  IconData icon;
}