import '../database/userdatabase.dart';

class User {
  static final User instance = User._privateConstructor();
  final dbHelper = DatabaseHelper.instance;

  User._privateConstructor();

  Future<void> addUserInList({
    required String firstName,
    required String lastName,
    required String email,
    required String number,
    required String dob,
    required String city,
    required int gender,
    required List<String> hobbies,
    required String password,
    required String confirmPassword,
  }) async {
    Map<String, dynamic> map = {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'number': number,
      'dob': dob,
      'age': calculateAge(dob),
      'city': city,
      'gender': gender,
      'hobbies': hobbies,
      'password': password,
      'confirmPassword': confirmPassword,
      'isLiked': 0,
    };
    await dbHelper.insertUser(map);
  }

  Future<List<Map<String, dynamic>>> getUserList() async {
    return await dbHelper.getUsers();
  }

  Future<void> updateUser({
    required String firstName,
    required String lastName,
    required String email,
    required String number,
    required String dob,
    required String city,
    required int gender,
    required List<String> hobbies,
    required String password,
    required String confirmPassword,
    required int id,
  }) async {
    try {
      Map<String, dynamic> map = {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'number': number,
        'dob': dob,
        'age': calculateAge(dob),
        'city': city,
        'gender': gender,
        'hobbies': hobbies,
        'password': password,
        'confirmPassword': confirmPassword,
      };
      print("Updating user with ID: $id");
      await dbHelper.updateUser(id, map);
      print("User updated successfully");
    } catch (e) {
      print("Error updating user: $e");
    }
  }


  Future<void> deleteUser(int id) async {
    try {
      await dbHelper.deleteUser(id);
      print("User with ID $id deleted successfully");
    } catch (e) {
      print("Error deleting user: $e");
    }
  }

  Future<List<Map<String, dynamic>>> searchDetail(String query) async {
    final allUsers = await getUserList();
    return allUsers
        .where((user) =>
    user['firstName'].toLowerCase().contains(query.toLowerCase()) ||
        user['lastName'].toLowerCase().contains(query.toLowerCase()) ||
        user['city'].toLowerCase().contains(query.toLowerCase()))
        .toList();
  }


  int calculateAge(String dateOfBirth) {
    DateTime birthDate = DateTime.parse(dateOfBirth.split('/').reversed.join('-'));
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  Future<void> updateUserLikeStatus(int id, int isLiked) async {
    await dbHelper.updateUserLikeStatus(id, isLiked);
  }
}
