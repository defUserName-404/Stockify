import 'package:stockify_app_flutter/feature/user/model/user.dart';
import 'package:stockify_app_flutter/feature/user/model/user_filter_param.dart';

abstract class UserService {
  void addUser(User user);

  void editUser(User user);

  User getUser(int id);

  List<User> getAllUsers();

  void deleteUser(int id);

  List<User> getFilteredUsers(UserFilterParams params);
}
