// lib/models/comment.dart
// Model bình luận cho truyện

class Comment {
  final int? id;
  final int storyId;
  final String username;
  final String? avatarPath;
  final String content;
  final DateTime createdAt;

  Comment({
    this.id,
    required this.storyId,
    required this.username,
    this.avatarPath,
    required this.content,
    required this.createdAt,
  });

  // Chuyển đổi từ Map (database)
  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'],
      storyId: map['story_id'],
      username: map['username'],
      avatarPath: map['avatar_path'],
      content: map['content'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  // Chuyển đổi sang Map (database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'story_id': storyId,
      'username': username,
      'avatar_path': avatarPath,
      'content': content,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Copy với giá trị mới
  Comment copyWith({
    int? id,
    int? storyId,
    String? username,
    String? avatarPath,
    String? content,
    DateTime? createdAt,
  }) {
    return Comment(
      id: id ?? this.id,
      storyId: storyId ?? this.storyId,
      username: username ?? this.username,
      avatarPath: avatarPath ?? this.avatarPath,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
