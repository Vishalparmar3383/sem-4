// UserListPage.dart
import 'package:flutter/material.dart';
import 'package:submisson_project/layouts/add_user_form.dart';
// import 'package:submisson_project/layouts/add_user_form.dart';
import 'package:submisson_project/layouts/userdata.dart';

import 'bottom_navbar.dart';
import 'detailed_user.dart';

final User myUser = User.instance;
dynamic users = myUser.getUserList();

class UserListPage extends StatefulWidget {
  UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    users = myUser.getUserList();
    searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User List"),
        backgroundColor: Colors.blue[400],
      ),
      body: Column(
        children: [
          SizedBox(height: 10,),
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
                    setState(() {
                      searchController.clear();
                      users = myUser.getUserList();
                    });
                  },
                )
                    : null,
              ),
              onChanged: (value) {
                setState(() {
                  users = myUser.searchDeatail(searchData: value);
                });
              },
            ),
          ),
          const SizedBox(height: 10,),
          Expanded(
            child: myUser.getUserList().isEmpty
              ? const Center(
                child: Text(
                  "No users added yet!",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              )
              : searchController.text.isNotEmpty && users.isEmpty?
            const Center(
              child: Text(
                "Users not found yet!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
                :Column(
                children :[
                  const SizedBox(height: 20,),
                  Expanded(
                    child: ListView.builder(
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                    final user = users[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),

                      child: GestureDetector(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailedUser(index: index),
                            ),
                          ).then((value) {
                            users = myUser.getUserList();
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
                                // User Details Section
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${user['firstName']} ${user['lastName']}",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text("City: ${user['city']}"),
                                      Text("Email: ${user['email']}"),
                                      Text("Mobile: ${user['number']}"),
                                    ],
                                  ),
                                ),
                                // Icon Section
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
                                          setState(() {
                                            users = myUser.getUserList();
                                          });
                                        }
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context)=> AlertDialog(
                                              title: Text('Are you sure want to delete.'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      myUser.deleteUser(index);
                                                    });
                                                    Navigator.pop(context);
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(
                                                        content: Text('User deleted successfully'),
                                                        duration: Duration(seconds: 3),
                                                      ),
                                                    );
                                                  },
                                                  child: Text('Delete'),
                                                ),

                                              ],
                                            ));
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.favorite_rounded, color: user['isLiked']?Colors.red[900]:Colors.white),
                                      onPressed: () {
                                        setState(() {
                                          user['isLiked'] = !user['isLiked'];
                                        });
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(user['isLiked']?'User liked successfully':'User unliked successfully'),
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
                          ),
                  ),
                ]
              ),
          ),
        ]
      ),
        bottomNavigationBar: const BottomNavBar(currentIndex: 2)
    );
  }
}
