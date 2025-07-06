class AppNotification {
  final int id;
  final String title;
  final String body;
  final DateTime timestamp;
  final String? payload;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    this.payload,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'timestamp': timestamp.toIso8601String(),
        'payload': payload,
      };

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      AppNotification(
        id: json['id'],
        title: json['title'],
        body: json['body'],
        timestamp: DateTime.parse(json['timestamp']),
        payload: json['payload'],
      );
}
