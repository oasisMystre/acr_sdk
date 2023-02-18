import 'Music.dart';

class Metadata {
  final List<Music> music;
  final int? resultType, costTime;

  const Metadata(this.music, this.resultType, this.costTime);

  factory Metadata.fromJson(Map<String, dynamic> data) {
    return Metadata(
      List<Music>.from(
        data["music"].map(
          (music) => Music.fromJson(music),
        ),
      ),
      data["result_type"],
      data["cost_time"],
    );
  }
}
