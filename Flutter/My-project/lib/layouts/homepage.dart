import 'package:flutter/material.dart';
import 'package:submisson_project/layouts/add_user_form.dart';
import 'package:submisson_project/layouts/aboutuspage.dart';
import 'package:submisson_project/layouts/favoritepage.dart';
import 'package:submisson_project/layouts/userlistpage.dart';

class MyHomepage extends StatefulWidget {
  const MyHomepage({super.key});

  @override
  State<MyHomepage> createState() => _MyHomepageState();
}

class _MyHomepageState extends State<MyHomepage> {
  final List<Map<String, dynamic>> items = [
    {'icon': Icons.playlist_add, 'text': 'Add User', 'page': AddUserForm()},
    {'icon': Icons.favorite_rounded, 'text': 'Favorites', 'page': FavoritesPage()},
    {'icon': Icons.list_alt_rounded, 'text': 'User List', 'page': UserListPage()},
    {'icon': Icons.account_circle_rounded, 'text': 'About Us', 'page': AboutUsPage()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "My Project",
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  mainAxisExtent: 100,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  bool isHovered = false;
                  bool isClicked = false;

                  return StatefulBuilder(
                    builder: (context, setState) {
                      return MouseRegion(
                        onEnter: (_) => setState(() => isHovered = true),
                        onExit: (_) => setState(() => isHovered = false),
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTapDown: (_) => setState(() => isClicked = true),
                          onTapUp: (_) => setState(() => isClicked = false),
                          onTapCancel: () => setState(() => isClicked = false),
                          onTap: () {
                            // Navigate to the SecondPage on tap
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => items[index]['page']),
                            );
                          },
                          child: AnimatedContainer(
                            height: isClicked ? 10 : 100,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Colors.blueAccent,
                                  Colors.blue,
                                  Colors.lightBlueAccent,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: isHovered?Colors.blue:Colors.grey.withOpacity(
                                      isHovered ? 1.0 : 0.8),
                                  spreadRadius: isHovered ? 4 : 2,
                                  blurRadius: isHovered ? 10 : 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  items[index]['icon'],
                                  color: Colors.white,
                                  size: 30,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  items[index]['text'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}