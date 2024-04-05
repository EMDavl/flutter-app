import 'package:app/model/base_model.dart';

class Post extends BaseModel{
  final String title;
  final String text;
  final String? latitude;
  final String? longitude;
  bool favorite;

  Post(super.id, this.title, this.text, this.favorite, this.latitude, this.longitude);
  Post.forCreation(this.title, this.text, this.favorite, this.latitude, this.longitude) : super(-1);

  @override
  Map<String, Object?> toMap() {
    return {
      "title": title,
      "text": text,
      "favorite": favorite.toString(),
      "latitude": latitude,
      "longitude": longitude,
    };
  }

  @override
  String toString() {
    return "{$id $favorite $title}";
  }
}