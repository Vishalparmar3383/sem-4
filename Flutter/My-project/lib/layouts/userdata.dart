class User {
  List<Map<String, dynamic>> userList = [];
  User._privateConstructor(){
    addUserInList(
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@example.com',
        number: '1234123434',
        dob: '01/01/1990',
        city: 'Rajkot',
        gender: 1,
        hobbies: ['Reading', 'Traveling'],
        password: 'password123',
        confirmPassword: 'password123'
    );
    addUserInList(
        firstName: 'Jane',
        lastName: 'Smith',
        email: 'jane.smith@example.com',
        number: '0987654321',
        dob: '02/02/1992',
        city: 'Morbi',
        gender: 0,
        hobbies: ['Cooking', 'Traveling'],
        password: 'password456',
        confirmPassword: 'password456'
    );
    addUserInList(
        firstName: 'Alice',
        lastName: 'Johnson',
        email: 'alice.johnson@example.com',
        number: '1122334455',
        dob: '01/01/1985',
        city: 'Ahmedabad',
        gender: 0,
        hobbies: ['Gaming', 'Reading'],
        password: 'password789',
        confirmPassword: 'password789'
    );
    addUserInList(
        firstName: 'Bob',
        lastName: 'Williams',
        email: 'bob.williams@example.com',
        number: '2233445566',
        dob: '04/04/1980',
        city: 'Surat',
        gender: 1,
        hobbies: ['Cooking'],
        password: 'password101',
        confirmPassword: 'password101'
    );
    addUserInList(
        firstName: 'Charlie',
        lastName: 'Brown',
        email: 'charlie.brown@example.com',
        number: '3344556677',
        dob: '11/11/1995',
        city: 'Morbi',
        gender: 1,
        hobbies: ['Gaming'],
        password: 'password202',
        confirmPassword: 'password202'
    );
  }
  static final User instance = User._privateConstructor();

  void addUserInList({required firstName, required lastName, required email, required number, required dob, required city, required gender, required hobbies, required password, required confirmPassword}) {
    Map<String, dynamic> map = {};
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['email'] = email;
    map['number'] = number;
    map['dob'] = dob;
    map['age'] = calculateAge(dob);
    map['city'] = city;
    map['gender'] = gender;
    map['hobbies'] = hobbies;
    map['password'] = password;
    map['confirmPassword'] = confirmPassword;
    map['isLiked'] = false;
    userList.add(map);
  }

  List<Map<String, dynamic>> getUserList() {
    return userList;
  }

  void updateUser({required firstName, required lastName, required email, required number, required dob, required city, required gender, required hobbies, required password, required confirmPassword, required id}) {
    Map<String, dynamic> map = {};
    print(id);
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['email'] = email;
    map['number'] = number;
    map['dob'] = dob;
    map['city'] = city;
    map['gender'] = gender;
    map['hobbies'] = hobbies;
    map['password'] = password;
    map['confirmPassword'] = confirmPassword;
    map['isLiked'] = userList[id]['isLiked'];
    userList[id] = map;
  }

  void deleteUser(id) {

    userList.removeAt(id);
  }

  List<Map<String, dynamic>>? searchDeatail({required searchData}) {
    List<Map<String, dynamic>> temp = [];
    // searchData = searchData.toString().toLowerCase().trim();
    for (var element in userList) {
      String name = '${element['firstName'].toString().toLowerCase()} ${element['lastName'].toString().toLowerCase()}';
      if (searchData != ' ' && (name
          .contains(searchData.toString().toLowerCase()) ||
          element['city']
              .toString()
              .toLowerCase()
              .contains(searchData.toString().toLowerCase()) ||
          element['number']
              .toString()
              .toLowerCase()
              .contains(searchData.toString().toLowerCase()) ||
          element['age']
              .toString()
              .toLowerCase()
              .contains(searchData.toString().toLowerCase()) ||
          element['email']
              .toString()
              .toLowerCase()
              .contains(searchData.toString().toLowerCase())))
      {
        temp.add(element);
      }
    }
    return temp;
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

}