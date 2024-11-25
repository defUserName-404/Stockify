import 'package:stockify_app_flutter/feature/user/model/user.dart';

abstract class UserService {
  void addUser(User user);

  void editUser(User user);

  User getUser(String id);

  List<User> getAllUsers();

  void deleteUser(String id);
}
