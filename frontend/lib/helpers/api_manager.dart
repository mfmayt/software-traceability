import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:frontend/Models/archview_component.dart';
import 'package:frontend/Models/archview.dart';
import 'package:frontend/helpers/data_manager.dart';
import 'package:frontend/constants/app_colors.dart';

class APIManager{
  
  static const String archViews = "/projects/{{projectID}}/views/{{viewID}}";
  static const String archViewComponents = "/projects/{{projectID}}/views/{{viewID}}/components";

  
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

  static List<ArchView> parseArchViews(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    List<ArchView> archviews = parsed.map<ArchView>((json) => ArchView.fromJson(json)).toList();
    return archviews;
  }

  static  Future<List<ArchViewComponent>> getArchViewComponents(String projectID, String viewID) async {
    final String url =  getRESTEndpoint(archViewComponents, params: {'projectID': projectID, 'viewID': viewID});
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
}