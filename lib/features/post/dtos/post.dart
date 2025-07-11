class Post {
  final int id;

  final String title;

  final String body;

  final String username;

  Post({ required this.id, required  this.title, required this.body, required this.username});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(id: json['id'] as int,
        title: json['title'] as String,
        body: json['body'] as String,
        username: json['username'] as String);
  }
}