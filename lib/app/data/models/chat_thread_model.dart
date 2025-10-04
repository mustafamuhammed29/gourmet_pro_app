class MessageModel {
  final int id;
  final String content;
  final DateTime createdAt;
  final int authorId;
  final String authorName;

  MessageModel({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.authorId,
    required this.authorName,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      authorId: json['author']['id'],
      authorName: json['author']['username'] ?? 'Unknown',
    );
  }
}

class ChatThreadModel {
  final int id;
  final List<MessageModel> messages;

  ChatThreadModel({
    required this.id,
    required this.messages,
  });

  factory ChatThreadModel.fromJson(Map<String, dynamic> json) {
    var messagesList = json['messages'] as List;
    List<MessageModel> messages =
    messagesList.map((i) => MessageModel.fromJson(i)).toList();
    // Sort messages by creation time
    messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return ChatThreadModel(
      id: json['id'],
      messages: messages,
    );
  }
}
