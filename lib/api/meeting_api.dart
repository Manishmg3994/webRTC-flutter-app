import 'dart:convert';

import 'package:http/http.dart' as http;

import '../utils/user.utils.dart';

//step 2
String MEETING_API_URL =
    "http://127.0.0.1:5000/api/meeting"; //"https://api.meetup.com/";
var client = http.Client();

Future<http.Response?> startMeeting() async {
  Map<String, String> requestHeaders = {
    "Content-Type": "application/json",
  }; // "Accept": "application/json"
  var userId = await loadUserId();
  var response = await client.post(Uri.parse('$MEETING_API_URL/start'),
      headers: requestHeaders,
      body: jsonEncode({"hostId": userId, "hostName": ""}));

  if (response.statusCode == 200) {
    return response;
  } else {
    return null;
  }
}

Future<http.Response?> joinMeeting(String meetingId) async {
  var response =
      await http.get(Uri.parse('$MEETING_API_URL/join?meetingId=$meetingId'));

  if (response.statusCode >= 200 && response.statusCode < 400) {
    return response;
  }
  throw UnsupportedError('Not a valid MEETING'); //TOdO :show snakbar error
}
