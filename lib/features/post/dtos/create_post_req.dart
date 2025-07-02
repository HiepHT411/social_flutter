class CreatePostRequest {
  final String title;

  final String body;

  CreatePostRequest(this.title, this.body);

  Map<String, dynamic> toJson() => {
    'title': title,
    'body': body
  };
}