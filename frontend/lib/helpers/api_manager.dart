import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:frontend/constants/url_constants.dart';
import 'package:http/http.dart' as http;

import 'package:frontend/Models/archview_component.dart';
import 'package:frontend/Models/archview.dart';
import 'package:frontend/Models/link.dart';
import 'package:frontend/helpers/data_manager.dart';

class APIManager{
  
  static const String archViews = "/projects/{{projectID}}/views/{{viewID}}";
  static const String archViewComponents = "/projects/{{projectID}}/views/{{viewID}}/components/{{componentID}}";
  static const String listArchViewComponents = "/projects/{{projectID}}/components";
  static const String link = "/projects/{{projectID}}/links/{{linkID}}"; // {GET, POST}
  static const String componentLinks = "/projects/{{projectID}}/components/{{componentID}}/links";

  static String getRESTEndpoint(String endpoint, {Map<String, dynamic> params = const {}}){
    return baseUrl + interpolate(endpoint, params: params);
  }

  static Future<List<ArchView>> getProjectArchViews(String projectID, String viewID) async{
    String url = getRESTEndpoint(archViews, params: {'projectID': projectID, 'viewID': viewID});
    final response = await http.get(
      url,
      headers: {
        HttpHeaders.authorizationHeader: "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1OTQ1NDQzODUsImlhdCI6MTU5MDk0NDM4NSwidXNlcmlkIjoiNWMxNDBlOTEtZWZmMS00ODVmLWI3MWUtNDY4MGEyMDEzNmIxIn0.XhI800q0n_mfjOg1v1_2aub6y5ehnQQno2vvn3__oC0",
        HttpHeaders.contentTypeHeader: 'application/json'
        },
    );
    return compute(parseArchViews, response.body);
  }

  static Future<ArchView> getArchView(String projectID, String viewID) async{
    String url = getRESTEndpoint(archViews, params: {'projectID': projectID, 'viewID': viewID});
    print(url);
    final response = await http.get(
      url,
      headers: {
        HttpHeaders.authorizationHeader: "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1OTQ1NDQzODUsImlhdCI6MTU5MDk0NDM4NSwidXNlcmlkIjoiNWMxNDBlOTEtZWZmMS00ODVmLWI3MWUtNDY4MGEyMDEzNmIxIn0.XhI800q0n_mfjOg1v1_2aub6y5ehnQQno2vvn3__oC0",
        HttpHeaders.contentTypeHeader: 'application/json'
        },
    );
    return compute(parseArchView, response.body);
  }

  static ArchView parseArchView(String responseBody) {
    final parsedJSON = jsonDecode(responseBody);
    ArchView archview = ArchView.fromJson(parsedJSON);
    return archview;
  }

  static List<ArchView> parseArchViews(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    List<ArchView> archviews = parsed.map<ArchView>((json) => ArchView.fromJson(json)).toList();
    return archviews;
  }

  static  Future<List<ArchViewComponent>> getArchViewComponents(String projectID, String viewID) async {
    final String url =  getRESTEndpoint(archViewComponents, params: {'projectID': projectID, 'viewID': viewID, 'componentID': ''});
    final response = await http.get(
      url,
      headers: {
        HttpHeaders.authorizationHeader: "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1OTQ1NDQzODUsImlhdCI6MTU5MDk0NDM4NSwidXNlcmlkIjoiNWMxNDBlOTEtZWZmMS00ODVmLWI3MWUtNDY4MGEyMDEzNmIxIn0.XhI800q0n_mfjOg1v1_2aub6y5ehnQQno2vvn3__oC0",
        HttpHeaders.contentTypeHeader: 'application/json'
        },
    );
    return compute(parseArchViewComponents, response.body);
  }

  static  Future<List<ArchViewComponent>> getAllArchViewComponents(String projectID) async {
    final String url =  getRESTEndpoint(listArchViewComponents, params: {'projectID': projectID, 'componentID': ''});
    final response = await http.get(
      url,
      headers: {
        HttpHeaders.authorizationHeader: "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1OTQ1NDQzODUsImlhdCI6MTU5MDk0NDM4NSwidXNlcmlkIjoiNWMxNDBlOTEtZWZmMS00ODVmLWI3MWUtNDY4MGEyMDEzNmIxIn0.XhI800q0n_mfjOg1v1_2aub6y5ehnQQno2vvn3__oC0",
        HttpHeaders.contentTypeHeader: 'application/json'
        },
    );
    return compute(parseArchViewComponents, response.body);
  }

  static List<ArchViewComponent> parseArchViewComponents(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    List<ArchViewComponent> userStories = parsed.map<ArchViewComponent>((json) => ArchViewComponent.fromJson(json)).toList();
    print(userStories.length);
    return userStories;
  }

  static Future<bool> addArchViewComponent(ArchViewComponent comp, String projectID, String viewID) async{
    final String url = getRESTEndpoint(archViewComponents, params: {'projectID': projectID, 'viewID': viewID, 'componentID': ''});
    String tmp = jsonEncode(comp);
    print(tmp);
    final response = await http.post(
      url,
      headers: {
        HttpHeaders.authorizationHeader: "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1OTQ1NDQzODUsImlhdCI6MTU5MDk0NDM4NSwidXNlcmlkIjoiNWMxNDBlOTEtZWZmMS00ODVmLWI3MWUtNDY4MGEyMDEzNmIxIn0.XhI800q0n_mfjOg1v1_2aub6y5ehnQQno2vvn3__oC0",
        HttpHeaders.contentTypeHeader: 'application/json'
        },
      body: tmp,
    );

    if (response.statusCode == 200){
      return true;
    }
    return false;
  }

  static Future<bool> patchArchView(ArchView av, String projectID, String viewID) async{
    final String url = getRESTEndpoint(archViews, params: {'projectID': projectID, 'viewID': viewID});
    final String body = jsonEncode(av);

    final response = await http.patch(
      url,
      headers: {
        HttpHeaders.authorizationHeader: "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1OTQ1NDQzODUsImlhdCI6MTU5MDk0NDM4NSwidXNlcmlkIjoiNWMxNDBlOTEtZWZmMS00ODVmLWI3MWUtNDY4MGEyMDEzNmIxIn0.XhI800q0n_mfjOg1v1_2aub6y5ehnQQno2vvn3__oC0",
        HttpHeaders.contentTypeHeader: 'application/json'
        },
      body: body,
    );

    if (response.statusCode == 200){
      return true;
    }
    return false;
  }

  static Future<Link> addLink(Link l) async{
    final String url = getRESTEndpoint(link, params: {'projectID': l.projectID, 'linkID': ''});
    String body = jsonEncode(l);

    final response = await http.post(
      url,
      headers: {
        HttpHeaders.authorizationHeader: "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1OTQ1NDQzODUsImlhdCI6MTU5MDk0NDM4NSwidXNlcmlkIjoiNWMxNDBlOTEtZWZmMS00ODVmLWI3MWUtNDY4MGEyMDEzNmIxIn0.XhI800q0n_mfjOg1v1_2aub6y5ehnQQno2vvn3__oC0",
        HttpHeaders.contentTypeHeader: 'application/json'
        },
        body: body,
    );
    return compute(parseLink, response.body);
  }

  static Link parseLink(String responseBody){
    final parsedJSON = jsonDecode(responseBody);
    Link link = Link.fromJson(parsedJSON);
    return link;
  }

  static List<Link> parseLinkList(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    List<Link> links = parsed.map<Link>((json) => Link.fromJson(json)).toList();
    print(links.length);
    return links;
  }

   static  Future<List<ArchViewComponent>> listLinkedComponents(String projectID, String componentID) async {
    final String url =  getRESTEndpoint(componentLinks, params: {'projectID': projectID,  'componentID': componentID});

    final response = await http.get(
      url,
      headers: {
        HttpHeaders.authorizationHeader: "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1OTQ1NDQzODUsImlhdCI6MTU5MDk0NDM4NSwidXNlcmlkIjoiNWMxNDBlOTEtZWZmMS00ODVmLWI3MWUtNDY4MGEyMDEzNmIxIn0.XhI800q0n_mfjOg1v1_2aub6y5ehnQQno2vvn3__oC0",
        HttpHeaders.contentTypeHeader: 'application/json'
        },
    );
    return compute(parseArchViewComponents, response.body);
  }
}