import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:frontend/constants/app_colors.dart';


class ArchViewList extends StatefulWidget {
  ArchViewList({Key key}) : super(key: key);
  @override
  _ArchViewListState createState() => _ArchViewListState();
}

class _ArchViewListState extends State<ArchViewList> {
// get archviews => this.archviews;
  List<ArchView> archviews = [];

  Future<List<ArchView>> fetchArchViews(http.Client client) async {
    final String url =  baseUrl + "/projects/e1c765cd-d8b8-4e64-b04e-25f30785a789/views";
    final response = await http.get(
      url,
      headers: {
        HttpHeaders.authorizationHeader: "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1OTQ1NDQzODUsImlhdCI6MTU5MDk0NDM4NSwidXNlcmlkIjoiNWMxNDBlOTEtZWZmMS00ODVmLWI3MWUtNDY4MGEyMDEzNmIxIn0.XhI800q0n_mfjOg1v1_2aub6y5ehnQQno2vvn3__oC0",
        HttpHeaders.contentTypeHeader: 'application/json'
        },
    );
    return compute(parseArchViews, response.body);
  }

  List<ArchView> parseArchViews(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    setState(() {
        this.archviews = parsed.map<ArchView>((json) => ArchView.fromJson(json)).toList();
        print(archviews.length);
    });
    return this.archviews;
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
          return Padding(
            padding: const EdgeInsets.all(28.0),
            child: new Card(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: new GridTile(
                  footer: archviews.length != index ? new Text(archviews[index].projectID) : Text("ANNEN"),
                  child: archviews.length != index ? new Text(archviews[index].id) : Text("ANNEN CHILD"),
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

class ArchView {
    final String id;
    final String name;
    final String projectID;
    final String kind;
    final List<String> userKinds;

    ArchView({this.id, this.name, this.projectID, this.kind, this.userKinds});

    factory ArchView.fromJson(Map<String, dynamic> json) {
      return ArchView(
        id: json['id'] as String,
        name: json['name'] as String,
        projectID: json['projectID'] as String,
        kind: json['kind'] as String,
        userKinds: json["userKinds"] != null ? List.from(json["userKinds"]) : null,
      );
    }
  }