import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../api/HttpCore.dart';
import '../objects/Metadata.dart';
import '../objects/Music.dart';
import '../utils/AcrSdk.dart';
import 'package:tuple/tuple.dart';
import 'package:tuple/tuple.dart';

class AcrButton extends StatefulWidget {
  final Widget activeChild;
  final Widget? inactiveChild;

  final Function(String message)? onMessage;
  final Future<void> Function(Music music, Tuple2<int, int> offsets) onValue;

  final AcrSdk acrSdk;

  const AcrButton({
    super.key,
    this.inactiveChild,
    required this.activeChild,
    this.onMessage,
    required this.onValue,
    required this.acrSdk,
  });

  @override
  State<AcrButton> createState() => _AcrButtonState();
}

class _AcrButtonState extends State<AcrButton> {
  Timer? _timer;

  int duration = 3;
  int retryDepth = 0;
  final int maxRetryDepth = 3;
  final int timeIncrement = 2;

  AcrSdk get sdk => widget.acrSdk;

  Future<String> get recordPath async {
    String tempPath = (await getTemporaryDirectory()).path;
    return "$tempPath/radar.wav";
  }

  reset() {
    retryDepth = 0;
    duration = 3;
    sdk.record.recording.value = Future(() => false);
  }

  startRecording() async {
    String? path = kIsWeb ? null : await recordPath;

    sdk.record.start(path: path, encoder: AudioEncoder.wav).then(
      (state) {
        _timer = Timer(
          Duration(seconds: duration),
          () async {
            retryDepth += 1;
            duration += timeIncrement;
            path = await sdk.record.stop(changeState: false) ?? path;
            int timestamp = DateTime.now().millisecondsSinceEpoch;

            sdk.sendSample(path: path!).then((metadata) async {
              Music music = metadata.music.reduce(
                (a, b) => a.score > b.score ? a : b,
              );

              reset();
              widget.onMessage!("${music.title} By ${music.artist}");
              await widget.onValue(
                  music, Tuple2(timestamp, music.playOffsetMs));
            }).onError((error, _) {
              HttpError httpError = error as HttpError;
              switch (httpError.httpStatus) {
                case HttpStatus.notFound:
                  if (retryDepth < maxRetryDepth) {
                    return startRecording();
                  }
                  break;
              }

              reset();
              widget.onMessage!(
                httpError.message ??
                    "No songs found\nTry to get closer to the audio source",
              );
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: sdk.record.recording,
      builder: (context, value, _) {
        return FutureBuilder(
          future: value,
          builder: (context, snapshot) {
            bool recording = snapshot.data ?? false;

            return GestureDetector(
              onTap: () {
                sdk.record.hasPermission().then(
                  (hasPermission) {
                    if (hasPermission) {
                      if (recording) {
                        widget.onMessage!(
                            "Tap to identify lyrics for songs you're listening to");
                        reset();
                        sdk.record.stop();
                        _timer!.cancel();
                      } else {
                        widget.onMessage!("Listening...");
                        startRecording();
                      }
                    }
                  },
                );
              },
              child: recording
                  ? widget.activeChild
                  : widget.inactiveChild ?? widget.activeChild,
            );
          },
        );
      },
    );
  }
}
