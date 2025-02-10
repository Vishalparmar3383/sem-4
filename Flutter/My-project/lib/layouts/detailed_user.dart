import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:submisson_project/layouts/userdata.dart';
import 'add_user_form.dart';
import 'bottom_navbar.dart';

final User myUser = User.instance;

class DetailedUser extends StatefulWidget {
  final int index;
  const DetailedUser({super.key, required this.index});

  @override
  State<DetailedUser> createState() => _DetailedUserState();
}

class _DetailedUserState extends State<DetailedUser> {
  final Map<int, Color> _backgroundColors = {};

  Color getUserColor(int userId) {
    if (!_backgroundColors.containsKey(userId)) {
      _backgroundColors[userId] = Colors.primaries[Random().nextInt(Colors.primaries.length)];
    }
    return _backgroundColors[userId]!;
  }

  void refreshUsers() {
    setState(() {
      usersFuture = myUser.getUserList();
    });
  }

  Widget buildInfoCard(String title, String value) {
    title = '$title :';
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: ListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value, style: TextStyle(fontSize: 16)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: myUser.getUserList(), // Fetch user list asynchronously
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: Text("Loading...")),
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: Text("User Not Found")),
            body: Center(child: Text("No user data available.")),
          );
        }

        final usersList = snapshot.data!;
        if (widget.index >= usersList.length) {
          return Scaffold(
            appBar: AppBar(title: Text("Invalid User")),
            body: Center(child: Text("Invalid user index.")),
          );
        }

        final user = usersList[widget.index];

        return Scaffold(
          appBar: AppBar(
            title: Text(
              "${user['firstName']} ${user['lastName']}",
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),
            ),
            centerTitle: true,
            backgroundColor: Colors.pinkAccent,
            elevation: 4,
            shadowColor: Colors.pink.withOpacity(0.4),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.pop(context,true),
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        ClipOval(
                          child: Container(
                            width: 100,
                            height: 100,
                            color: getUserColor(widget.index),
                            alignment: Alignment.center,
                            child: Text(
                              user['firstName'][0],
                              style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text("${user['firstName']} ${user['lastName']}", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20),
                Text("Personal Details", style: TextStyle(color: Colors.pinkAccent, fontSize: 20, fontWeight: FontWeight.bold)),
                buildInfoCard("Date of Birth", user['dob']),
                buildInfoCard("Age", user['age'].toString()),
                buildInfoCard("City", user['city'].toString()),
                buildInfoCard("Hobbies", jsonDecode(user['hobbies']).join(', ')),


          SizedBox(height: 10),
                Text("Contact Details", style: TextStyle(color: Colors.pinkAccent, fontSize: 20, fontWeight: FontWeight.bold)),
                buildInfoCard("Email ID", user['email']),
                buildInfoCard("Phone", user['number'].toString()),

                SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddUserForm(userData: user, index: widget.index),
                          ),
                        );
                        if (result == true) {
                          setState(() {});
                        }
                      },
                      icon: Icon(Icons.edit, color: Colors.white),
                      label: Text("Edit", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 6,
                      ),
                    ),

                    ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Are you sure you want to delete?', style: TextStyle(fontWeight: FontWeight.bold)),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Cancel', style: TextStyle(color: Colors.blueAccent)),
                              ),
                              TextButton(
                                onPressed: () async {
                                  try {
                                    print("Attempting to delete user ID: ${user['id']}");

                                    await myUser.deleteUser(user['id']);
                                    Navigator.pop(context);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('User deleted successfully'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                   Navigator.pop(context,true);
                                  } catch (e) {
                                    print("Error deleting user: $e");
                                  }
                                },
                                child: Text('Delete', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: Icon(Icons.delete, color: Colors.white),
                      label: Text("Delete", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 6,
                      ),
                    ),

                    ElevatedButton.icon(
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
                      icon: Icon(Icons.favorite_rounded, color: user['isLiked'] == 1? Colors.red : Colors.white),
                      label: Text(user['isLiked']==1 ? "Unlike" : "Like", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        backgroundColor: Colors.orangeAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 6,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          bottomNavigationBar: const BottomNavBar(currentIndex: 0),
        );
      },
    );
  }
}
