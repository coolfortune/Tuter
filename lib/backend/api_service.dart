import 'dart:convert';

import 'package:Tuter/Models/student.dart';
import 'package:Tuter/Models/tutor.dart';
import 'package:Tuter/backend/api_response.dart';
import 'package:http/http.dart' as http;

class API_service {
  static const API = '';
  static const headers = {'apiKey': ''};

  Future<APIResponse<Student>> getStudent(String userID) {
    return http.get(API + '/student/' + userID, headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        return APIResponse<Student>(data: Student.fromJson(jsonData));
      }
      return APIResponse<Student>(error: true, errorMessage: 'An error occured');
    })
    .catchError((_) => APIResponse<Student>(error: true, errorMessage: 'An error occured'));
  }

  Future<APIResponse<Tutor>> getTutor(String userID) {
    return http.get(API + '/tutor/' + userID, headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        return APIResponse<Tutor>(data: Tutor.fromJson(jsonData));
      }
      return APIResponse<Tutor>(error: true, errorMessage: 'An error occured');
    })
    .catchError((_) => APIResponse<Tutor>(error: true, errorMessage: 'An error occured'));
  }



}