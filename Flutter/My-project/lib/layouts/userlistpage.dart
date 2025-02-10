import 'dart:math';
import 'package:flutter/material.dart';
import 'package:submisson_project/layouts/add_user_form.dart';
import 'package:submisson_project/layouts/userdata.dart';
import 'bottom_navbar.dart';
import 'detailed_user.dart';

final User myUser = User.instance;

class UserListPage extends StatefulWidget {
  UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  TextEditingController searchController = TextEditingController();
  Future<List<Map<String, dynamic>>> usersFuture = myUser.getUserList();

  @override
  void initState() {
    super.initState();
    usersFuture = myUser.getUserList();
    searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void refreshUsers() {
    setState(() {
      usersFuture = myUser.getUserList();
    });
  }

  final Map<int, Color> _backgroundColors = {};
  Color getUserColor(int userId) {
    if (!_backgroundColors.containsKey(userId)) {
      _backgroundColors[userId] = Colors.primaries[Random().nextInt(Colors.primaries.length)];
    }
    return _backgroundColors[userId]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "User List",
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
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search here.......',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.cancel_outlined),
                  onPressed: () {
                    searchController.clear();
                    refreshUsers();
                  },
                )
                    : null,
              ),
              onChanged: (value) {
                setState(() {
                  usersFuture = myUser.searchDetail(value);
                });
              },
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: usersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      "No users added yet!",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  );
                } else {
                  List<Map<String, dynamic>> users = snapshot.data!;
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () async {
                             Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailedUser(index: index),
                              ),
                            ).then((value) {
                              if (value == true) {
                                refreshUsers();
                              }
                            },);

                          },
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            ClipOval(
                                              child: Container(
                                                width: 70,
                                                height: 70,
                                                color: getUserColor(index),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  user['firstName'][0],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 30,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              "${user['firstName']} ${user['lastName']}",
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Text("City: ${user['city']}"),
                                        Text("DOB: ${user['dob']}"),
                                        Text("Age: ${user['age']}"),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Colors.blue),
                                        onPressed: () async {
                                          final result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => AddUserForm(userData: user, index: index),
                                            ),
                                          );
                                          if (result == true) {
                                            refreshUsers();
                                          }
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text('Are you sure you want to delete?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    try {
                                                      print("Attempting to delete user ID: ${user['id']}");

                                                      await myUser.deleteUser(user['id']);
                                                      refreshUsers();
                                                      Navigator.pop(context);

                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(
                                                          content: Text('User deleted successfully'),
                                                          duration: Duration(seconds: 2),
                                                        ),
                                                      );
                                                    } catch (e) {
                                                      print("Error deleting user: $e"); // ✅ Debugging log
                                                    }
                                                  },

                                                  child: const Text('Delete'),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.favorite_rounded,
                                          color: user['isLiked'] == 1 ? Colors.red[900] : Colors.white,
                                        ),
                                        onPressed: () async {
                                          int newValue = user['isLiked'] == 0 ? 1 : 0;

                                          await myUser.updateUserLikeStatus(user['id'], newValue);
                                          refreshUsers();

                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(newValue == 1 ? 'User liked successfully' : 'User unliked successfully'),
                                              duration: const Duration(milliseconds: 500),
                                            ),
                                          );
                                        },
                                      ),

                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }
}
