import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class ControlPanel extends StatelessWidget {
  final bool? videoEnabled;
  final bool? audioEnabled;
  final bool? isConnectionFailed;
  final VoidCallback? onVideoToggle;
  final VoidCallback? onAudioToggle;
  final VoidCallback? onReconnect;
  final VoidCallback? onMeetingEnd;

  const ControlPanel(
      {Key? key,
      this.videoEnabled,
      this.audioEnabled,
      this.isConnectionFailed,
      this.onVideoToggle,
      this.onAudioToggle,
      this.onReconnect,
      this.onMeetingEnd})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey[900],
      height: 60,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buildControls(),),
    );
  }

  List<Widget> buildControls() {
    if (!isConnectionFailed!) {
      return <Widget>[
        IconButton(
          onPressed: onVideoToggle,
          icon: Icon(videoEnabled! ? Icons.videocam : Icons.videocam_off),
          color: Colors.white,
          iconSize: 32.0,
        ),
        IconButton(
          onPressed: onAudioToggle,
          icon: Icon(audioEnabled! ? Icons.mic : Icons.mic_off),
          color: Colors.white,
          iconSize: 32.0,
        ),
        const SizedBox(
          width: 25,
        ),
        Container(
          width: 70,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.red),
          child: IconButton(
            icon: const Icon(Icons.call_end),
            color: Colors.white,
            onPressed: onMeetingEnd,
          ),
        )
      ];
    } else {
      return <Widget>[
        FormHelper.submitButton(
          'Reconnect',
          onReconnect!,
          btnColor: Colors.red,
          borderRadius: 10,
          width: 200,
          height: 40,
        )
      ];
    }
  }
}
