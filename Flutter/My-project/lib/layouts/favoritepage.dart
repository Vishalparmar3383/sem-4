// FavoritesPage.dart
import 'package:flutter/material.dart';
import 'package:submisson_project/layouts/userdata.dart';

import 'detailed_user.dart';

final User myUser = User.instance;
dynamic users = myUser.getUserList();
dynamic likedUsers = [];

class FavoritesPage extends StatefulWidget {
  FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    users = myUser.getUserList();
    likedUsers = users.where((user) => user['isLiked'] == true).toList();
  }

  @override
  Widget build(BuildContext context) {
    likedUsers = users.where((user) => user['isLiked'] == true).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
      ),
      body: Column(
        children: [
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
            child: likedUsers.isEmpty
              ? searchController.text.isNotEmpty && users.isEmpty?
            const Center(
              child: Text(
                "Users not found yet!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
                : Center(
              child: Text(
                users.isEmpty?"No users added yet!":"No favorite users yet!",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
                : ListView.builder(
              itemCount: likedUsers.length,
              itemBuilder: (context, index) {
                final user = likedUsers[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailedUser(index: index), // Pass the index
                        ),
                      );
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
                                  Text("Email: ${user['email']}"),
                                  Text("City: ${user['city']}"),
                                  Text("Mobile: ${user['number']}"),
                                ],
                              ),
                            ),
                            // Icon Section
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.thumb_up,
                                    color: user['isLiked'] ? Colors.red[900] : Colors.black,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      user['isLiked'] = !user['isLiked'];
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('User unliked successfully'),
                                        duration: Duration(milliseconds: 500),
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
    );
  }
}
