class GenericData {
  final String id;

  const GenericData(this.id);

  factory GenericData.fromJson(Map<String, dynamic> data) {
    return GenericData(data["id"]);
  }
}
