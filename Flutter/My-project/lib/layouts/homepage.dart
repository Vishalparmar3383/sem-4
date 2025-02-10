import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:submisson_project/layouts/add_user_form.dart';
import 'package:submisson_project/layouts/aboutuspage.dart';
import 'package:submisson_project/layouts/favoritepage.dart';
import 'package:submisson_project/layouts/userlistpage.dart';
import 'bottom_navbar.dart';

class MyHomepage extends StatefulWidget {
  const MyHomepage({super.key});

  @override
  State<MyHomepage> createState() => _MyHomepageState();
}

class _MyHomepageState extends State<MyHomepage> {
  static bool isDarkMode = false;

  final List<Map<String, dynamic>> items = [
    {'icon': Icons.person_add, 'text': 'Add User', 'page': AddUserForm()},
    {'icon': Icons.favorite, 'text': 'Favorites', 'page': const FavoritesPage()},
    {'icon': Icons.list, 'text': 'User List', 'page': UserListPage()},
    {'icon': Icons.info, 'text': 'About Us', 'page': AboutUsPage()},
  ];

  void _toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: 150,
          title: AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                "Welcome to our app",
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
                speed: Duration(milliseconds: 100),
              ),
            ],
            repeatForever: false,
            totalRepeatCount: 1,
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
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.0,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return FadeTransition(
                          opacity: animation,
                          child: item['page'],
                        );
                      },
                      transitionDuration: const Duration(milliseconds: 400),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        const begin = Offset(1.0, 0.0);
                        const end = Offset.zero;
                        const curve = Curves.easeInOut;

                        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                        var offsetAnimation = animation.drive(tween);

                        return SlideTransition(position: offsetAnimation, child: child);
                      },
                    ),
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[850] : Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: isDarkMode ? Colors.pinkAccent.withOpacity(0.2) : Colors.pink.shade200,
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: const Offset(3, 3),
                      ),
                    ],
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    splashColor: Colors.pinkAccent.withOpacity(0.3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(item['icon'], size: 40, color: Colors.pinkAccent),
                        const SizedBox(height: 10),
                        Text(
                          item['text'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _toggleTheme,
          backgroundColor: isDarkMode ? Colors.orangeAccent : Colors.blueAccent,
          child: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode, color: Colors.white),
        ),
        bottomNavigationBar: const BottomNavBar(currentIndex: 0),
      ),
    );
  }
}
