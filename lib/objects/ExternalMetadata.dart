import 'AppData.dart';

class ExternalMetadata {
  final AppData? musicbrainz, spotify, deezer, musicstory, youtube;
  const ExternalMetadata(
    this.musicbrainz,
    this.spotify,
    this.deezer,
    this.musicstory,
    this.youtube,
  );

  factory ExternalMetadata.fromJson(Map<String, dynamic> data) {
    return ExternalMetadata(
      data["musicbrainz"] == null
          ? null
          : AppData.fromJson(data["musicbrainz"]),
      data["spotify"] == null ? null : AppData.fromJson(data["spotify"]),
      data["deezer"] == null ? null : AppData.fromJson(data["deezer"]),
      data["musicstory"] == null ? null : AppData.fromJson(data["musicstory"]),
      data["youtube"] == null ? null : AppData.fromJson(data["youtube"]),
    );
  }
}
