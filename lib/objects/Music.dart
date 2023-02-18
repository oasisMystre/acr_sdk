import 'Artist.dart';

class Music {
  final List<ACRArtist> artists;
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
      List<ACRArtist>.from(
        data["artists"].map((artist) => ACRArtist.fromJson(artist)),
      ),
    );
  }
}
