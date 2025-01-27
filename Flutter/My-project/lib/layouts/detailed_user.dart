import 'package:flutter/material.dart';
import 'package:submisson_project/layouts/userdata.dart';
import 'package:submisson_project/layouts/userlistpage.dart';

import 'add_user_form.dart';

final User myUser = User.instance;
dynamic users = myUser.getUserList();

class DetailedUser extends StatefulWidget {
  final int index;
  const DetailedUser({super.key, required this.index});

  @override
  State<DetailedUser> createState() => _DetailedUserState();
}

class _DetailedUserState extends State<DetailedUser> {
  @override
  Widget build(BuildContext context) {
    final user = myUser.getUserList()[widget.index];
    // Ensure the image path is correct and added to pubspec.yaml
    final String imageUrl = 'assets/images/default_avatar.png';

    // Function to create a row with consistent spacing
    Widget buildKeyValueRow(String key, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Text(
                key,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            Text(
              ':',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(width: 8),
            Expanded(
              flex: 5,
              child: Text(
                value,
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("${user['firstName']} ${user['lastName']}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipOval(
                  child: Image.asset(
                    imageUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  "${user['firstName']} ${user['lastName']}",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),
                const Text(
                  "Information :",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                buildKeyValueRow("Gender", user['gender']==0?'Female':'Male'),
                buildKeyValueRow("Date of Birth", user['dob']),
                buildKeyValueRow("Age", (user['age']).toString()),
                buildKeyValueRow("City", user['city'].toString()),
                buildKeyValueRow("Hobbies", user['hobbies'].join(',')),
                SizedBox(height: 20),
                Text(
                  "Contact Details",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                buildKeyValueRow("Email ID", user['email']),
                buildKeyValueRow("Phone", user['number'].toString()),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddUserForm(userData: user, index: widget.index),
                            ),
                          );
                          if (result == true) {
                            setState(() {
                              users = myUser.getUserList(); // Refresh the user list
                            });
                          }
                        },
                        child: Column(
                          children: [
                            Icon(Icons.edit, color:Colors.blue),
                            SizedBox(width: 10,),
                            Text("Edit"),
                          ],
                        ),
                                            ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
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
                                        myUser.deleteUser(widget.index);
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('User deleted successfully'),
                                          duration: Duration(seconds: 3),
                                        ),
                                      );
                                      Navigator.pop(context);
                                      // Navigator.push(context, MaterialPageRoute(builder: (context) => UserListPage(),));
                                    },
                                    child: Text('Delete'),
                                  ),
                                ],
                              ));
                        },
                        child: Column(
                          children: [
                            Icon(Icons.delete, color: Colors.black),
                            SizedBox(width: 10,),
                            Text('Delete'),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
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
                        child: Column(
                          children: [
                            Icon(Icons.thumb_up, color: user['isLiked']?Colors.red:Colors.black54,),
                            SizedBox(width: 10,),
                            Text(user['isLiked']?"UnLike":'Like'),
                          ],
                        ),
                      ),
                    ),
                  ]
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
