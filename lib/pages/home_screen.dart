import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:videocallwebrtc/api/meeting_api.dart';
import 'package:videocallwebrtc/models/meeting_details.dart';

import 'join_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  late String meetingId = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meeting App'),
        backgroundColor: Colors.redAccent,
      ),
      body: Form(
        key: globalKey,
        child: formUI(),
      ),
    );
  }

  formUI() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome to WebRTC Meeting App",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 25),
            ),
            const SizedBox(height: 20),
            FormHelper.inputFieldWidget(
                context, "meetingId", "Enter your Meeting Id", (val) {
              if (val.isEmpty) {
                return "Meeting Id is required and can't be empty";
              }
              return null;
            }, (onSaved) {
              meetingId = onSaved;
            },
                borderRadius: 10,
                borderFocusColor: Colors.redAccent,
                borderColor: Colors.redAccent,
                hintColor: Colors.grey),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Flexible(
                  child: FormHelper.submitButton("Join Meeting", () {
                if (validateAndSave()) {
                  validateMeeting(meetingId);
                }
              })),
              Flexible(
                  child: FormHelper.submitButton("Start Meeting", () async {
                var response = await startMeeting();
                final body = json.decode(response!.body);
                final meetId = body["data"];
                validateMeeting(meetId);
              }))
            ])
          ],
        ),
      ),
    );
  }

  void validateMeeting(String meetingId) async {
    try {
      var response = await joinMeeting(meetingId); //here in response is var
      var data = json.decode(response!.body);
      final meetingDetails = MeetingDetail.fromJson(data["data"]);
      goToJoinScreen(meetingDetails);
    } catch (err) {
      FormHelper.showSimpleAlertDialog(
          context, "Meeting App", "Invalid Meeting Id", "OK", () {
        Navigator.of(context).pop();
      });
    }
  }
goToJoinScreen(MeetingDetail meetingDetail)async{
Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>JoinScreen(meetingDetails: meetingDetail)));



}
  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
