class NodeModel {
  final String id;
  final String content;
  final String authorName;
  final String authorAvatarUrl;
  int voteCount;
  final String path;
  final String? parentId;

  NodeModel({
    required this.id,
    required this.content,
    required this.authorName,
    required this.authorAvatarUrl,
    required this.voteCount,
    required this.path,
    this.parentId,
  });

  factory NodeModel.fromJson(Map<String, dynamic> json) {
    return NodeModel(
      id: json['id'] as String,
      content: json['content'] as String,
      authorName: json['author'] != null ? json['author']['username'] as String : 'Unknown',
      authorAvatarUrl: json['author'] != null ? json['author']['avatar_url'] as String : '',
      voteCount: json['vote_count'] as int,
      path: json['path'] as String,
      parentId: json['parent_id'] as String?,
    );
  }
}
