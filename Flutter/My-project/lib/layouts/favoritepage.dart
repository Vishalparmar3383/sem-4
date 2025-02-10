import 'package:flutter/material.dart';
import 'package:submisson_project/layouts/userdata.dart';

import 'bottom_navbar.dart';
import 'detailed_user.dart';

final User myUser = User.instance;

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  TextEditingController searchController = TextEditingController();
  late Future<List<Map<String, dynamic>>> usersFuture;

  void refreshUsers() {
    setState(() {
      usersFuture = myUser.getUserList();
    });
  }

  @override
  void initState() {
    super.initState();
    usersFuture = myUser.getUserList(); // Fetch users asynchronously
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Favorite Users",
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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No users added yet!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }

          List<Map<String, dynamic>> users = snapshot.data!;
          List<Map<String, dynamic>> likedUsers =
          users.where((user) => user['isLiked'] == 1).toList();

          return Column(
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
                        setState(() {
                          searchController.clear();
                          usersFuture = myUser.getUserList();
                        });
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
                child: likedUsers.isEmpty
                    ? Center(
                  child: Text(
                    users.isEmpty
                        ? "No users added yet!"
                        : "No favorite users yet!",
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
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailedUser(index: index),
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
                                              color: Colors.orange,
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
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }
}
