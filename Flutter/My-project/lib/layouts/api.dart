import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Constants for the API
const String NAME = "Name";
const String CITY = "City";
const String COLUMN_ID = "id";
const String TABLE_NAME = "crud";

// MyApi class for handling CRUD operations with the API
class MyApi {
  // Add user to the API
  Future<void> addUser(Map<String, dynamic> user) async {
    final response = await http.post(
      Uri.parse("https://67cee03e823da0212a808215.mockapi.io/users"),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
      },
      body: jsonEncode({
        NAME: user[NAME],
        CITY: user[CITY],
      }),
    );

    if (response.statusCode == 201) {
      print("User Added Successfully");
      getUserList();
    } else {
      print("Failed to add");
    }
  }

  // Get user list from the API
  Future<List<Map<String, dynamic>>> getUserList() async {
    final response = await http.get(Uri.parse("https://67cee03e823da0212a808215.mockapi.io/users"));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);

      List<Map<String, dynamic>> userList = jsonData.map((user) {
        return {
          COLUMN_ID: user[COLUMN_ID],
          NAME: user[NAME],
          CITY: user[CITY],
        };
      }).toList();
      return userList;
    }
    return [];
  }

  // Update a user in the API
  Future<void> updateUser(String id, Map<String, dynamic> user) async {
    try {
      final response = await http.put(
        Uri.parse("https://67cee03e823da0212a808215.mockapi.io/users/$id"),
        headers: <String, String>{
          'Content-Type': "application/json; charset=UTF-8",
        },
        body: jsonEncode({
          NAME: user[NAME],
          CITY: user[CITY],
        }),
      );

      if (response.statusCode == 200) {
        print("User Updated Successfully");
        getUserList();
      } else {
        print("Failed to update");
      }
    } catch (error) {
      print("Error occurred $error");
    }
  }

  // Delete a user from the API
  Future<void> deleteUser(String id) async {
    final response = await http.delete(
      Uri.parse("https://67cee03e823da0212a808215.mockapi.io/users/$id"),
    );

    if (response.statusCode == 200) {
      print("Deleted Successfully");
    } else {
      print("Error occurred while deleting");
    }

    getUserList();
  }
}

// Flutter CRUD UI screen
void main() {
  runApp(MaterialApp(
    home: Crud(),
  ));
}

class Crud extends StatefulWidget {
  Crud({super.key});

  @override
  State<Crud> createState() => _CrudState();
}

class _CrudState extends State<Crud> {
  TextEditingController nameController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey();
  List<Map<String, dynamic>> userList = [];

  MyApi api = MyApi();

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  // Fetch user data from the API
  Future<void> fetchUsers() async {
    List<Map<String, dynamic>> users = await api.getUserList();

    setState(() {
      userList = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crud With API"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: "Enter Your Name",
                      labelText: "Enter Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  child: TextFormField(
                    controller: cityController,
                    decoration: InputDecoration(
                      hintText: "Enter Your City",
                      labelText: "Enter City",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      Map<String, dynamic> user = {
                        "Name": nameController.text,
                        "City": cityController.text
                      };

                      await api.addUser(user);

                      setState(() {
                        fetchUsers();
                      });

                      nameController.clear();
                      cityController.clear();
                    }
                  },
                  child: Text("Add"),
                ),
                SizedBox(height: 20),
                Text(
                  "UserList",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                userList.isEmpty
                    ? Text("No User Found")
                    : SingleChildScrollView(
                  child: ListView.builder(
                    itemCount: userList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 2,
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          title: Text(userList[index]["Name"]),
                          subtitle: Text(userList[index]["City"]),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (context) {
                                      TextEditingController editNameController =
                                      TextEditingController(text: userList[index]["Name"]);
                                      TextEditingController editCityController =
                                      TextEditingController(text: userList[index]["City"]);

                                      return Padding(
                                        padding: EdgeInsets.only(bottom: 10),
                                        child: Container(
                                          padding: EdgeInsets.all(20),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "Edit User",
                                                style: TextStyle(
                                                    fontSize: 20, fontWeight: FontWeight.bold),
                                              ),
                                              SizedBox(height: 20),
                                              TextFormField(
                                                controller: editNameController,
                                                decoration: InputDecoration(
                                                  labelText: "Edit Name",
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(15),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              TextFormField(
                                                controller: editCityController,
                                                decoration: InputDecoration(
                                                  labelText: "Edit City",
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(15),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 20),
                                              ElevatedButton(
                                                onPressed: () async {
                                                  Map<String, dynamic> updateUser = {
                                                    "Name": editNameController.text,
                                                    "City": editCityController.text
                                                  };

                                                  await api.updateUser(
                                                      userList[index]["id"].toString(), updateUser);

                                                  setState(() {
                                                    fetchUsers();
                                                  });

                                                  Navigator.pop(context);
                                                },
                                                child: Text("Update"),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                icon: Icon(Icons.edit),
                              ),
                              IconButton(
                                onPressed: () async {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("Are you sure you want to delete the user?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("Cancel"),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              await api.deleteUser(userList[index]["id"].toString());
                                              Navigator.pop(context);
                                              fetchUsers();
                                            },
                                            child: Text("Delete"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
