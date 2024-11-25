class UserInputValidator {
  UserInputValidator._();

  static String? validateUsername(String? name) {
    if (name == null || name.isEmpty) {
      return 'Username should not be empty';
    }
    return null;
  }
}
