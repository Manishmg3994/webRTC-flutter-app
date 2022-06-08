import 'package:flutter/material.dart';
import 'package:flutter_webrtc_wrapper/flutter_webrtc_wrapper.dart';

import 'package:videocallwebrtc/models/meeting_details.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:videocallwebrtc/pages/home_screen.dart';
import 'package:videocallwebrtc/utils/user.utils.dart';
import 'package:videocallwebrtc/widgets/control_panel.dart';
import 'package:videocallwebrtc/widgets/remote_connection.dart';

class MeetingPage extends StatefulWidget {
  final String? meetingId;
  final String? name;
  final MeetingDetail meetingDetail;

  const MeetingPage(
      {Key? key, this.meetingId, this.name, required this.meetingDetail})
      : super(key: key);

  @override
  State<MeetingPage> createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  final _localRenderer = RTCVideoRenderer();
  //this is local person video view
  final Map<String, dynamic> mediaConstraints = {"audio": true, "video": true};
  bool isConnectionFailed = false;
  WebRTCMeetingHelper? meetingHelper;

  void startMeeting() async {
    final String userId = await loadUserId(); //TODO CHANGE FOR FIRESTORE
    meetingHelper = WebRTCMeetingHelper(
      url:
          "http://127.0.0.1:5000", // TODO change is requred everytime for new host
      meetingId: widget.meetingDetail.id,
      userId: userId,
      name: widget.name,
    );
    MediaStream _localStream =
        await navigator.mediaDevices.getUserMedia(mediaConstraints);
    _localRenderer.srcObject = _localStream;
    meetingHelper!.stream = _localStream;
    meetingHelper!.on(
      "open",
      context,
      (ev, context) {
        setState(() {
          isConnectionFailed = false;
        });
      },
    );
    meetingHelper!.on(
      "connection",
      context,
      (ev, context) {
        setState(() {
          isConnectionFailed = false;
        });
      },
    );
    meetingHelper!.on(
      "user-left", //TODO ither operation to do if any meeting member left the video cal or meeeting ,as to show popup saying perticular person have left the meeting or snakbar
      context,
      (ev, context) {
        setState(() {
          isConnectionFailed = false;
        });
      },
    );
    meetingHelper!.on(
      "video-toggle",
      context,
      (ev, context) {
        setState(() {});
      },
    );
    meetingHelper!.on(
      "audio-toggle",
      context,
      (ev, context) {
        setState(() {});
      },
    );
    meetingHelper!.on(
      "meeting-ended",
      context,
      (ev, context) {
        onMeetingEnd(); //TODO firebase delete Document
      },
    );
    meetingHelper!.on(
      "connection-setting-changed",
      context,
      (ev, context) {
        setState(() {
          isConnectionFailed = false;
        });
      },
    );
    meetingHelper!.on(
      "stream-changed",
      context,
      (ev, context) {
        setState(() {
          isConnectionFailed = false;
        });
      },
    );
    setState(() {});
  }

  initRenderers() async {
    await _localRenderer.initialize();
  }

  @override
  void initState() {
    super.initState();
    initRenderers();
    startMeeting();
  }

  @override
  void deactivate() {
    super.deactivate();
    _localRenderer.dispose();
    if (meetingHelper != null) {
      meetingHelper!.destroy();
      meetingHelper = null;
    }
  }

  void onMeetingEnd() {
    // deleting firestore data TODO
    if (meetingHelper != null) {
      meetingHelper!.endMeeting();
      meetingHelper = null;
      goToHomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: _buildMeetingRoom(),
      bottomNavigationBar: ControlPanel(
        onAudioToggle: onAudioToggle,
        onVideoToggle: onVideoToggle,
        videoEnabled: isVideoEnabled(),
        audioEnabled: isAudioEnabled(),
        isConnectionFailed: isConnectionFailed,
        onReconnect: handleReconnect,
        onMeetingEnd: onMeetingEnd,
      ),
    );
  }

  void onAudioToggle() {
    if (meetingHelper != null) {
      setState(() {
        meetingHelper!.toggleAudio();
      });
    }
  }

  void onVideoToggle() {
    if (meetingHelper != null) {
      setState(() {
        meetingHelper!.toggleVideo();
      });
    }
  }

  void handleReconnect() {
    if (meetingHelper != null) {
      meetingHelper!.reconnect();
    }
  }

  bool isAudioEnabled() {
    return meetingHelper != null ? meetingHelper!.audioEnabled! : false;
  }

  bool isVideoEnabled() {
    return meetingHelper != null ? meetingHelper!.videoEnabled! : false; //
  }

  void goToHomePage() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomeScreen()));
  }

  _buildMeetingRoom() {
    return Stack(
      children: [
        meetingHelper != null && meetingHelper!.connections.isNotEmpty
            ? GridView.count(
                crossAxisCount: meetingHelper!.connections.length < 3 ? 1 : 2,
                children:
                    List.generate(meetingHelper!.connections.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.all(1),
                    child: RemoteConnection(
                      renderer: meetingHelper!.connections[index].renderer,
                      connection: meetingHelper!.connections[index],
                    ),
                  );
                }))
            : const Center(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "WAiting For Participants To Join The Meeting",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 24),
                  ),
                ),
              ),
        //my local view TODO
        Positioned(
          bottom: 10,
          right: 0,
          child: SizedBox(
              width: 150, height: 200, child: RTCVideoView(_localRenderer)),
        )
      ],
    );
  }
}
