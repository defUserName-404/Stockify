class User {
  final String id;
  final String userName;
  final String? designation;
  final String? sapId;
  final String? ipPhone;
  final String? roomNo;
  final String? floor;

  User(
      {required this.id,
      required this.userName,
      this.designation,
      this.sapId,
      this.ipPhone,
      this.roomNo,
      this.floor});
}
