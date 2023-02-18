class ACRArtist {
  final String name;

  ACRArtist(this.name);

  factory ACRArtist.fromJson(Map<String, dynamic> data) {
    return ACRArtist(data["name"]);
  }
}
