import 'package:social_media_app/model/author.dart';

class Comment {
  String id;
  String body;
  Author? author;

  Comment({
    required this.id,
    required this.body,
    this.author
  });
}