import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:submisson_project/layouts/favoritepage.dart';
import 'package:submisson_project/layouts/userdata.dart';

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
  List<String> cities = ['Ahmedabad', 'Surat', 'Rajkot', 'Morbi', 'Jamnagar'];
  String selectedCity = '';
  int selectedGender = 1;
  List<String> selectedHobbies = [];
  Map<String, bool> hobbies = {
    'Reading': false,
    'Traveling': false,
    'Gaming': false,
    'Cooking': false,
  };

  @override
  void initState() {
    super.initState();
    if (widget.userData != null) {
      // Initialize the text controllers with existing data
      firstNameController.text = widget.userData!['firstName'];
      lastNameController.text = widget.userData!['lastName'];
      emailController.text = widget.userData!['email'];
      mobileController.text = widget.userData!['number'];
      dobController.text = widget.userData!['dob'];
      selectedCity = widget.userData!['city'];
      selectedGender = widget.userData!['gender'];
      selectedHobbies = widget.userData!['hobbies'];
      hobbies.forEach((key, _) {
        hobbies[key] = selectedHobbies.contains(key);
      });
      selectedHobbies = [];
      passwordController.text = widget.userData!['password'];
      confirmPasswordController.text = widget.userData!['confirmPassword'];
    } else {
      selectedCity = cities[0];
    }
  }
  DateTime? selectedDate;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userData == null ? "Add User" : "Edit User", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black26,
      ),
      body: Form(
        key: _fromKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            child: Column(
              children: [
                // First Name
                TextFormField(
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
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                SizedBox(height: 20),
                // Last Name
                TextFormField(
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
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                SizedBox(height: 20),
                // Email
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter email';
                    }
                    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Enter Email',
                    labelText: 'Email',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                SizedBox(height: 20),
                // Mobile Number
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter mobile number';
                    }
                    if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
                      return 'Enter a valid 10-digit mobile number.';
                    }
                    return null;
                  },
                  controller: mobileController,
                  decoration: InputDecoration(
                    hintText: 'Enter Mobile Number',
                    labelText: 'Mobile Number',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                SizedBox(height: 20),
                // DOB
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter date of birth';
                    }
                    if (!RegExp(r'^(0[1-9]|[12][0-9]|3[01])/(0[1-9]|1[0-2])/\d{4}$')
                        .hasMatch(value)) {
                      return 'Enter a valid date in DD/MM/YYYY format';
                    }
                    DateTime dob = DateFormat('dd/MM/yyyy').parse(value);
                    DateTime today = DateTime.now();
                    int age = today.year - dob.year;
                    if (today.month < dob.month ||
                        (today.month == dob.month && today.day < dob.day)) {
                      age--;
                    }
                    if (age < 18) {
                      return 'You must be at least 18 years old to register.';
                    }
                    return null;
                  },
                  controller: dobController,
                  decoration: InputDecoration(
                    hintText: 'Enter DOB (DD/MM/YYYY)',
                    labelText: 'DOB',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_month_outlined),
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDate ?? DateTime.now().subtract(Duration(days: 365 * 18)),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );

                        if (pickedDate != null) {
                          selectedDate = pickedDate;
                          String formattedDate =
                          DateFormat('dd/MM/yyyy').format(pickedDate);
                          dobController.text = formattedDate;
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // City Dropdown
                Row(
                  children: [
                    Text("City :"),
                    SizedBox(width: 40),
                    DropdownButton<String>(
                      value: selectedCity,
                      items: cities.map((city) {
                        return DropdownMenuItem<String>(value: city, child: Text(city));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCity = value ?? cities[0];
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Gender
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Gender   :"),
                    SizedBox(width: 20),
                    Row(
                      children: [
                        Row(
                          children: [
                            Radio<int>(
                              value: 1,
                              groupValue: selectedGender,
                              onChanged: (value) {
                                setState(() {
                                  selectedGender = value!;
                                });
                              },
                            ),
                            Text('Male'),
                          ],
                        ),
                        SizedBox(width: 20),
                        Row(
                          children: [
                            Radio<int>(
                              value: 0,
                              groupValue: selectedGender,
                              onChanged: (value) {
                                setState(() {
                                  selectedGender = value!;
                                });
                              },
                            ),
                            Text('Female'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Hobbies
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hobbies :'),
                    SizedBox(width: 20),
                    Expanded(
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 5,
                        children: hobbies.keys.map((hobby) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                value: hobbies[hobby],
                                onChanged: (value) {
                                  setState(() {
                                    hobbies[hobby] = value!;
                                  });
                                },
                              ),
                              Text(hobby),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Password
                TextFormField(
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter password';
                    }
                    return null;
                  },
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: 'Enter Password',
                    labelText: 'Password',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                SizedBox(height: 20),
                // Confirm Password
                TextFormField(
                  obscureText: true,
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
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    if (_fromKey.currentState!.validate()) {
                      Navigator.pop(context,true);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(widget.userData == null?'User added successfully':'User edit successfully'),
                          duration: const Duration(seconds: 3),
                        ),
                      );
                      hobbies.forEach((key, value) {
                        if (value) {
                          selectedHobbies.add(key);
                        }
                      });
                      if(widget.userData == null){
                        myUser.addUserInList(firstName: firstNameController.text, lastName: lastNameController.text, email: emailController.text, number: mobileController.text, dob: dobController.text, city: selectedCity, gender: selectedGender, hobbies: selectedHobbies, password: passwordController.text, confirmPassword: confirmPasswordController.text);
                      }
                      else {
                        myUser.updateUser(firstName: firstNameController.text,
                            lastName: lastNameController.text,
                            email: emailController.text,
                            number: mobileController.text,
                            dob: dobController.text,
                            city: selectedCity,
                            gender: selectedGender,
                            hobbies: selectedHobbies,
                            password: passwordController.text,
                            confirmPassword: confirmPasswordController.text,
                            id: widget.index);
                        _fromKey.currentState?.reset();
                      }
                    }
                  },
                  child: Text(widget.userData == null ? "Add" : "Edit"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}