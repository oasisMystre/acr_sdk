import 'package:acr_sdk/objects/ExternalMetadata.dart';

import 'Artist.dart';

class Music {
  final List<ACRArtist> artists;
  final ExternalMetadata externalMetadata;
  final int durationMs, playOffsetMs, score;
  final String releaseDate, title, acrId, label;

  const Music(
    this.releaseDate,
    this.title,
    this.durationMs,
    this.playOffsetMs,
    this.score,
    this.acrId,
    this.label,
    this.externalMetadata,
    this.artists,
  );

  String get artist => artists.map((_) => _.name).join(", ");

  factory Music.fromJson(Map<String, dynamic> data) {
    return Music(
      data["release_date"],
      data["title"],
      data["duration_ms"],
      data["play_offset_ms"],
      data["score"],
      data["acrid"],
      data["label"],
      ExternalMetadata.fromJson(data["external_metadata"]),
      List<ACRArtist>.from(
        data["artists"].map((artist) => ACRArtist.fromJson(artist)),
      ),
    );
  }
}
