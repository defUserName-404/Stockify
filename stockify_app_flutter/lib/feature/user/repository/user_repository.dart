import '../model/user.dart';

class UserRepository {
  UserRepository._privateConstructor();

  static final UserRepository _instance = UserRepository._privateConstructor();

  List<User> _users = _generateRandomUsers(20);

  static List<User> _generateRandomUsers(int userCount) {
    return List.generate(userCount, (index) {
      return User(
          id: (index + 1).toString(),
          userName: 'User $index',
          designation: 'User');
    });
  }

  static UserRepository get instance => _instance;


  List<User> getAllUsers() => _users;

  User getUser(String id) => _users.firstWhere((element) => element.id == id);

  void addUser(User user) {
    _users.add(user);
  }

  void editUser(User user) {
    final index = _users.indexWhere((element) => element.id == element.id);
    _users[index] = user;
  }

  void deleteUser(String id) {
    _users.removeWhere((element) => element.id == id);
  }
}
