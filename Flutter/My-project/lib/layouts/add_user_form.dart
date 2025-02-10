import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:submisson_project/layouts/userdata.dart';
final User myUser = User.instance;
Future<List<Map<String, dynamic>>> usersFuture = myUser.getUserList();
List<String> emails = [];
List<String> numbers =[];

Future<void> getEmailsAndNumbers() async {
  List<Map<String, dynamic>> users = await usersFuture;

  emails = users.map((user) => user["email"] as String).toList();
  numbers = users.map((user) => user["number"] as String).toList();

  print('emails : ${emails}');
  print('numbers : ${numbers}');
}


class AddUserForm extends StatefulWidget {
  final Map<String,dynamic>? userData;
  final int? index;

  AddUserForm({Key? key, this.userData,this.index}) : super(key: key);

  @override
  State<AddUserForm> createState() => _AddUserFormState();
}

class _AddUserFormState extends State<AddUserForm> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  GlobalKey<FormState> _fromKey = GlobalKey();
  List<String> cities = ['Ahmedabad', 'Surat', 'Rajkot', 'Morbi', 'Jamnagar','Gandhianagar','Vadodra','Amreli','Junagadh'];
  String selectedCity = '';
  int selectedGender = 1;
  List<String> selectedHobbies = [];
  Map<String, bool> hobbies = {
    'Reading': false,
    'Traveling': false,
    'Gaming': false,
    'Cooking': false,
  };
  bool _isPressed = false;
  bool _hobbyError = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  void _validateHobbies() {
    setState(() {
      _hobbyError = !hobbies.containsValue(true);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
    if (widget.userData != null) {
      selectedCity = cities.contains(widget.userData!['city'])
          ? widget.userData!['city']
          : cities[0];
    } else {
      selectedCity = cities[0];
    }
  }

  Future<void> _loadUserData() async {

    if (widget.userData != null) {
      firstNameController.text = widget.userData!['firstName'];
      lastNameController.text = widget.userData!['lastName'];
      emailController.text = widget.userData!['email'];
      mobileController.text = widget.userData!['number'];
      dobController.text = widget.userData!['dob'];
      selectedCity = widget.userData!['city'];
      selectedGender = widget.userData!['gender'];
      selectedDate = DateFormat('dd/MM/yyyy').parse(widget.userData!['dob']);
      selectedHobbies = List<String>.from(jsonDecode(widget.userData!['hobbies']));
      passwordController.text = widget.userData!['password'];
      confirmPasswordController.text = widget.userData!['confirmPassword'];
      hobbies.forEach((key, _) {
        hobbies[key] = selectedHobbies.contains(key);
      });
      setState(() {});
    } else {
      selectedCity = cities[0];
    }
    setState(() {});
  }

  DateTime? selectedDate;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.userData == null ? "Add User" : "Edit User",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
        elevation: 4,
        shadowColor: Colors.pink.withOpacity(0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Colors.pink[50],
        child: Form(
          key: _fromKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 10,
                shadowColor: Colors.pinkAccent[50],
                color: Colors.pinkAccent[50],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),

                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                  child: Column(
                    children: [
                      // First Name
                      TextFormField(
                        keyboardType: TextInputType.name,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'[0-9]')),
                        ],
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter FirstName';
                          }
                          if (!RegExp(r'^[a-zA-Z\s]{3,50}$').hasMatch(value)) {
                            return 'Enter a valid first name (3-50 characters, alphabets only)';
                          }
                          return null;
                        },
                        controller: firstNameController,
                        decoration: InputDecoration(
                          hintText: 'Enter First Name',
                          labelText: 'First Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.redAccent),
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.person,
                              color: Colors.blueAccent,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.lightBlue.shade50,
                        ),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                        cursorColor: Colors.blueAccent,
                      ),
                      SizedBox(height: 30),
                      // Last Name
                      TextFormField(
                        keyboardType: TextInputType.name,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'[0-9]')),
                        ],
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter valid lastname';
                          }
                          if (!RegExp(r'^[a-zA-Z\s]{3,50}$').hasMatch(value)) {
                            return 'Enter a valid Last name (3-50 characters, alphabets only)';
                          }
                          return null;
                        },
                        controller: lastNameController,
                        decoration: InputDecoration(
                          hintText: 'Enter Last Name',
                          labelText: 'Last Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.redAccent),
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.person,
                              color: Colors.blueAccent,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.lightBlue.shade50,
                        ),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                        cursorColor: Colors.blueAccent,
                      ),
                      SizedBox(height: 30),
                      // Email
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter email';
                          }
                          if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
                            return 'Enter a valid email address';
                          }
                          if(emails.contains(value)){
                            return 'Enter different email';
                          }
                          return null;
                        },
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: 'Enter Email',
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.redAccent),
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.email_outlined,
                              color: Colors.blueAccent,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.lightBlue.shade50,
                        ),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                        cursorColor: Colors.blueAccent,
                      ),
                      SizedBox(height: 30),
                      // Mobile Number
                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter mobile number';
                          }
                          if (!RegExp(r'[0-9]{10}$').hasMatch(value)) {
                            return 'Enter a valid 10-digit mobile number.';
                          }
                          if(numbers.contains(value)){
                            return 'Enter different number';
                          }
                          return null;
                        },
                        controller: mobileController,
                        decoration: InputDecoration(
                          hintText: 'Enter Mobile Number',
                          labelText: 'Mobile Number',border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.blueAccent),
                        ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.redAccent),
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.call,
                              color: Colors.blueAccent,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.lightBlue.shade50,
                        ),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                        cursorColor: Colors.blueAccent,
                      ),
                      SizedBox(height: 30),
                      // DOB
                      TextFormField(
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: selectedDate ?? DateTime.now().subtract(Duration(days: 365 * 18)),
                            firstDate: DateTime.now().subtract(Duration(days: 365*98)),
                            lastDate: DateTime.now().subtract(Duration(days: 365*18)),
                          );

                          if (pickedDate != null) {
                            selectedDate = pickedDate;
                            String formattedDate =
                            DateFormat('dd/MM/yyyy').format(pickedDate);
                            dobController.text = formattedDate;
                          }
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter date of birth';
                          }
                        },
                        controller: dobController,
                        decoration: InputDecoration(
                          hintText: 'Select DOB',
                          labelText: 'DOB',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.redAccent),
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.calendar_month_outlined,
                              color: Colors.blueAccent,

                            ),
                          ),
                          filled: true,
                          fillColor: Colors.lightBlue.shade50,
                        ),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                        cursorColor: Colors.blueAccent,
                      ),
                      SizedBox(height: 30),
                      // City
                      Row(
                        children: [
                          const Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(Icons.location_city_outlined, color: Colors.blueAccent),
                              ),
                              Text(
                                "City :",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 20),
                          DropdownButton<String>(
                            value: cities.contains(selectedCity) ? selectedCity : cities[0],
                            items: cities.toSet().map((city) {
                              return DropdownMenuItem<String>(value: city, child: Text(city));
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedCity = value ?? cities[0];
                              });
                            },
                            style: TextStyle(color: Colors.blueAccent, fontSize: 16),
                            iconEnabledColor: Colors.blueAccent,
                            dropdownColor: Colors.lightBlue.shade50,
                          )

                        ],
                      ),
                      SizedBox(height: 30),
                      // Gender
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(Icons.person, color: Colors.blueAccent),
                              ),
                              Text(
                                "Gender :",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8), // Space between text and buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedGender = 1;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: selectedGender == 1 ? Colors.blueAccent : Colors.grey.shade300,
                                    foregroundColor: selectedGender == 1 ? Colors.white : Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text('Male'),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedGender = 0;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: selectedGender == 0 ? Colors.blueAccent : Colors.grey.shade300,
                                    foregroundColor: selectedGender == 0 ? Colors.white : Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text('Female'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      // Hobbies
                      Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.favorite, color: Colors.blueAccent),
                        ),
                        Text(
                          'Hobby  :',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: hobbies.keys.map((hobby) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    hobbies[hobby] = !(hobbies[hobby] ?? false);
                                    _validateHobbies();
                                  });
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Checkbox(
                                      value: hobbies[hobby],
                                      onChanged: (value) {
                                        setState(() {
                                          hobbies[hobby] = value!;
                                          _validateHobbies();
                                        });
                                      },
                                      activeColor: Colors.blueAccent,
                                    ),
                                    Text(
                                      hobby,
                                      style: TextStyle(fontSize: 16, color: Colors.blueAccent),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                      if (_hobbyError)
                        Padding(
                          padding: EdgeInsets.only(top: 5, left: 8),
                          child: Text(
                            'Please select at least one hobby!',
                            style: TextStyle(color: Colors.red, fontSize: 14),
                          ),
                        ),
                      SizedBox(height: 30),
                      // Password
                      TextFormField(
                        obscureText: _obscurePassword,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter password';
                          }
                          else if(value.length<6){
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                        controller: passwordController,
                        decoration: InputDecoration(
                          hintText: 'Enter Password',
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.redAccent),
                          ),
                          prefixIcon: Icon(Icons.lock, color: Colors.blueAccent),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                              color: Colors.blueAccent,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          filled: true,
                          fillColor: Colors.lightBlue.shade50,
                        ),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                        cursorColor: Colors.blueAccent,
                      ),
                      SizedBox(height: 30),
                      // Confirm Password
                      TextFormField(
                        obscureText: _obscureConfirmPassword,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter confirm password';
                          }
                          if (value != passwordController.text) {
                            return 'Password and confirm password are not the same';
                          }
                          return null;
                        },
                        controller: confirmPasswordController,
                        decoration: InputDecoration(
                          hintText: 'Enter Confirm Password',
                          labelText: 'Confirm Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.redAccent),
                          ),
                          prefixIcon: Icon(Icons.lock, color: Colors.blueAccent),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                              color: Colors.blueAccent,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword = !_obscureConfirmPassword;
                              });
                            },
                          ),
                          filled: true,
                          fillColor: Colors.lightBlue.shade50,
                        ),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                        cursorColor: Colors.blueAccent,
                      ),
                      SizedBox(height: 40),
                      AnimatedScale(
                        scale: _isPressed ? 0.9 : 1.0,
                        duration: Duration(milliseconds: 200),
                        child: GestureDetector(
                          onTapDown: (_) => setState(() => _isPressed = true),
                          onTapUp: (_) => setState(() => _isPressed = false),
                          onTapCancel: () => setState(() => _isPressed = false),
                            onTap: () async {
                              if (_fromKey.currentState!.validate()) {
                                selectedHobbies.clear();
                                hobbies.forEach((key, value) {
                                  if (value) selectedHobbies.add(key);
                                });

                                if (widget.userData == null) {
                                  await myUser.addUserInList(
                                    firstName: firstNameController.text,
                                    lastName: lastNameController.text,
                                    email: emailController.text,
                                    number: mobileController.text,
                                    dob: dobController.text,
                                    city: selectedCity,
                                    gender: selectedGender,
                                    hobbies: selectedHobbies,
                                    password: passwordController.text,
                                    confirmPassword: confirmPasswordController.text,
                                  );
                                } else {
                                  try {
                                    print("Submitting updated user data...");
                                    await myUser.updateUser(
                                      firstName: firstNameController.text,
                                      lastName: lastNameController.text,
                                      email: emailController.text,
                                      number: mobileController.text,
                                      dob: dobController.text,
                                      city: selectedCity,
                                      gender: selectedGender,
                                      hobbies: selectedHobbies,
                                      password: passwordController.text,
                                      confirmPassword: confirmPasswordController.text,
                                      id: widget.userData!['id'],
                                    );

                                    print("User edit successful");
                                  } catch (e) {
                                    print("Error while updating user: $e");
                                  }
                                }
                                Navigator.pop(context, true);
                                Future.delayed(Duration(milliseconds: 300), () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(widget.userData == null ? 'User added successfully' : 'User edited successfully'),
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                });
                              }
                            },
                            child: Container(
                            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.purple, Colors.pink],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.purple.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: Offset(2, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                widget.userData == null ? "Add User" : "Edit User",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}