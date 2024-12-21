class GenreModel {
  final int idGenre;
  final String name;

  GenreModel({
    required this.idGenre,
    required this.name,
  });

  factory GenreModel.fromJson(Map<String, dynamic> json) {
    return GenreModel(
      idGenre: json["idGenre"],
      name: json["name"],
    );
  }

  static List<GenreModel> fromJsonList(List list) {
    return list.map((item) => GenreModel.fromJson(item)).toList();
  }

  /// Prevent overriding toString
  String userAsString() {
    return '#$idGenre $name';
  }

  /// Check equality of two models
  bool isEqual(GenreModel model) {
    return idGenre == model.idGenre;
  }

  @override
  String toString() => name;
}
