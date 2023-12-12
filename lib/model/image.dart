class ImageModel {
  final String id;
  String imagePath;

  ImageModel({required this.id, required this.imagePath});

  /// Map型に変換
  Map toJson() => {
        'id': id,
        'imagePath': imagePath,
      };

  /// JSONオブジェクトを代入
  ImageModel.fromJson(Map json)
      : id = json['id'],
        imagePath = json['imagePath'];
}
