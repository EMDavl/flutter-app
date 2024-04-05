import 'package:app/model/media.dart';
import 'package:app/repository/db_helper.dart';
import 'package:sqflite/sqflite.dart';

class MediaRepository {
  MediaRepository() : _db = DbHelper().db;

  final Future<Database> _db;

  Future<Media> getByPost(int postId) async {
    var db = await _db;
    List medias = await db.query("medias", whereArgs: [postId], where: "post_id = ?");
    var media = [
      for (final {
        "id": id as int,
        "link": link as String,
        "type": type as String,
        "post_id": idOfPost as int
      } in medias) Media(id, link, Type.of(type), idOfPost)
    ];
    Media med = media.firstWhere((element) => element.type == Type.video);
    return med;
  }
}