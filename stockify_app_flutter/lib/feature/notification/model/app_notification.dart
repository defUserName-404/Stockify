enum NotificationType { warrantyExpiring, warrantyExpired }

class AppNotification {
  final int id;
  final String title;
  final String body;
  final DateTime timestamp;
  final String? payload;
  final String? assetName;
  final int? itemId;
  final NotificationType type;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    this.payload,
    this.assetName,
    this.itemId,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'timestamp': timestamp.toIso8601String(),
        'payload': payload,
        'assetName': assetName,
        'itemId': itemId,
        'type': type.toString(),
      };

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      AppNotification(
        id: json['id'],
        title: json['title'],
        body: json['body'],
        timestamp: DateTime.parse(json['timestamp']),
        payload: json['payload'],
        assetName: json['assetName'],
        itemId: json['itemId'],
        type: NotificationType.values.firstWhere(
          (e) => e.toString() == json['type'],
          orElse: () => NotificationType.warrantyExpiring,
        ),
      );
}
