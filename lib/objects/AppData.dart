import 'GenericData.dart';

class AppData {
  final GenericData? track, album;
  final List<GenericData>? artists;

  const AppData(this.track, this.artists, this.album);

  factory AppData.fromJson(Map<String, dynamic> data) {
    return AppData(
      data["track"] == null ? null : GenericData.fromJson(data["track"]),
      data["artist"] == null
          ? null
          : List<GenericData>.from(
              data["artists"]
                  .map((artist) => GenericData.fromJson(data["artists"])),
            ),
      data["album"] == null ? null : GenericData.fromJson(data["album"]),
    );
  }
}
