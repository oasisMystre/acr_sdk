import 'package:flutter/foundation.dart';
import 'package:record/record.dart';

class GenericRecord extends Record {
  final ValueNotifier<Future<bool>> recording = ValueNotifier(
    Future(() => false),
  );

  GenericRecord() {
    recording.value = super.isRecording();
  }

  @override
  Future<void> start({
    String? path,
    AudioEncoder encoder = AudioEncoder.aacLc,
    int bitRate = 128000,
    int samplingRate = 44100,
    int numChannels = 2,
    InputDevice? device,
    bool changeState = true,
  }) {
    if (changeState) {
      recording.value = Future(() => true);
    }

    return super.start(
      path: path,
      encoder: encoder,
      samplingRate: samplingRate,
      numChannels: numChannels,
      device: device,
      bitRate: bitRate,
    );
  }

  @override
  Future<String?> stop({bool changeState = true}) {
    if (changeState) {
      recording.value = Future(() => false);
    }
    return super.stop();
  }
}
