import 'package:app/model/media.dart';
import 'package:app/model/post.dart';
import 'package:sqflite/sqflite.dart';

import 'db_helper.dart';

class PostRepository {
  PostRepository() : _db = DbHelper().db;

  final Future<Database> _db;

  Future<int> createPost(Post post, List<Media> medias) async {
    var db = await _db;
    return db.transaction((txn) async {
      int id = await txn.insert(
        'posts',
        post.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      for (final media in medias) {
        media.postId = id;
        await txn.insert(
          "medias",
          media.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      return id;
    });
  }

  Future<List<Post>> postsPage(var offset, var limit) async {
    var db = await _db;

    final List<Map<String, Object?>> posts =
        await db.query('posts', offset: offset, limit: limit);

    return [
      for (final {
            'id': id as int,
            'text': text as String,
            'title': title as String,
            'favorite': favorite as String,
            'latitude': latitude as String?,
            'longitude': longitude as String?,
          } in posts)
        Post(id, title, text, bool.parse(favorite, caseSensitive: false),
            latitude, longitude),
    ];
  }

  Future<void> deletePost(int id) async {
    var db = await _db;

    await db.delete(
      'posts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> likePost(int id) async {
    var db = await _db;

    await db.update(
      'posts',
      {"favorite": "true"},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> dislikePost(int id) async {
    var db = await _db;

    await db.update(
      'posts',
      {"favorite": "false"},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Post>> favoritesPostPage(int offset, int limit) async {
    var db = await _db;

    final List<Map<String, Object?>> posts = await db.query('posts',
        where: "favorite = ?",
        whereArgs: ["true"],
        offset: offset,
        limit: limit);

    return [
      for (final {
            'id': id as int,
            'text': text as String,
            'title': title as String,
            'favorite': favorite as String,
            'latitude': latitude as String?,
            'longitude': longitude as String?,
          } in posts)
        Post(id, title, text, bool.parse(favorite, caseSensitive: false),
            latitude, longitude),
    ];
  }
}
