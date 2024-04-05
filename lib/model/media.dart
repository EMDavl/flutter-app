import 'package:app/model/base_model.dart';

class Media extends BaseModel {

  final String link;
  final Type type;
  int? postId;

  Media(super.id, this.link, this.type, this.postId);

  Media.forCreation(this.link, this.type) : super(-1);

  @override
  Map<String, Object?> toMap() {
    return {
      "link": link,
      "post_id": postId,
      "type": type.name,
    };
  }

  @override
  String toString() {
    return "{ $postId - $link }";
  }

}

enum Type {
 thumbnail, video;

 static Type of(String str) {
   return str == Type.thumbnail.name ? Type.thumbnail : Type.video;
 }
}