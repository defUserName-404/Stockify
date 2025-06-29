import 'package:stockify_app_flutter/feature/user/model/user.dart';
import 'package:stockify_app_flutter/feature/user/repository/user_repository.dart';
import 'package:stockify_app_flutter/feature/user/service/user_service.dart';

class UserServiceImplementation extends UserService {
  UserServiceImplementation._privateConstructor();

  static final UserService _instance =
      UserServiceImplementation._privateConstructor();

  static UserService get instance => _instance;

  final UserRepository _userRepository = UserRepository.instance;

  @override
  void addUser(User user) {
    _userRepository.addUser(user);
  }

  @override
  void deleteUser(int id) {
    _userRepository.deleteUser(id);
  }

  @override
  void editUser(User user) {
    _userRepository.editUser(user);
  }

  @override
  List<User> getAllUsers() {
    return _userRepository.getAllUsers();
  }

  @override
  User getUser(int id) {
    return _userRepository.getUser(id);
  }
}
