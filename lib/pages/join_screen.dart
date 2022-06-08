import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

import 'package:videocallwebrtc/models/meeting_details.dart';
import 'package:videocallwebrtc/pages/meeting_page.dart';

class JoinScreen extends StatefulWidget {
  final MeetingDetail? meetingDetails;

  const JoinScreen({Key? key, this.meetingDetails}) : super(key: key);

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  static final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  late String userName = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Join Meeting"),
        backgroundColor: Colors.redAccent,
      ),
      body: formUI(),
    );
  }

  formUI() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            FormHelper.inputFieldWidget(context, "UserId", "Enter your Name ",
                (val) {
              if (val.isEmpty) {
                return "Name is required and can't be empty";
              }
              return null;
            }, (onSaved) {
              userName = onSaved;
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
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) {
                      return MeetingPage(
                        meetingId: widget.meetingDetails!.id,
                        name: userName,
                        meetingDetail: widget.meetingDetails!,
                      );
                    },
                  ));
                }
              })),
            ])
          ],
        ),
      ),
    );
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
