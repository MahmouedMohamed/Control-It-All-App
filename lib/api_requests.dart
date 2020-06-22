import 'dart:async';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
String getUrl(String url,decision){
  return "http://"+url+":8080/"+decision;
}
Future<dynamic> move(String url,String decision) async {
  print(getUrl(url, decision));
  var response = await http.get(Uri.encodeFull(getUrl(url, decision)),
      headers: {"Accpet": "application/json"});
  print(response.body.length);
    return "http://"+url+":8080/"+response.body;
}
Future<dynamic> sleep(String url,String decision) async {
  print(getUrl(url, decision));
  var response = await http.get(Uri.encodeFull(getUrl(url, decision)),
      headers: {"Accpet": "application/json"});
  return (response.body);
}
