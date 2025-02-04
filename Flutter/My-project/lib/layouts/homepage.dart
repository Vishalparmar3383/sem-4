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

class _MyHomepageState extends State<MyHomepage> with SingleTickerProviderStateMixin {
  bool isDarkMode = false;
  late AnimationController _animationController;
  late Animation<Color?> _backgroundColor;
  late Animation<Color?> _cardColor;
  late Animation<Color?> _textColor;

  final List<Map<String, dynamic>> items = [
    {'icon': Icons.person_add, 'text': 'Add User', 'page': AddUserForm()},
    {'icon': Icons.favorite, 'text': 'Favorites', 'page': FavoritesPage()},
    {'icon': Icons.list, 'text': 'User List', 'page': UserListPage()},
    {'icon': Icons.info, 'text': 'About Us', 'page': AboutUsPage()},
  ];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _updateTheme();
  }

  void _updateTheme() {
    _backgroundColor = ColorTween(
      begin: Colors.white,
      end: Colors.black87,
    ).animate(_animationController);

    _cardColor = ColorTween(
      begin: Colors.white,
      end: Colors.grey[850],
    ).animate(_animationController);

    _textColor = ColorTween(
      begin: Colors.black87,
      end: Colors.white,
    ).animate(_animationController);
  }

  void _toggleTheme() {
    if (isDarkMode) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: isDarkMode ? Brightness.dark : Brightness.light,
            scaffoldBackgroundColor: _backgroundColor.value,
          ),
          home: Scaffold(
            appBar: AppBar(
              title: const Text(
                "Matrimony",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDarkMode
                        ? [Colors.black87, Colors.black54]
                        : [Colors.blue.shade500, Colors.blue.shade300],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
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
                          transitionDuration: const Duration(milliseconds: 450),
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
                        color: _cardColor.value,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: isDarkMode
                            ? [
                          BoxShadow(
                            color: Colors.blueAccent.withOpacity(0.2),
                            blurRadius: 8,
                            spreadRadius: 1,
                            offset: const Offset(0, 2),
                          ),
                        ]
                            : [
                          BoxShadow(
                            color: Colors.blue.shade200,
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: const Offset(3, 3),
                          ),
                        ],
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15),
                        splashColor: Colors.blueAccent.withOpacity(0.3),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(item['icon'], size: 40, color: Colors.blueAccent),
                            const SizedBox(height: 10),
                            Text(
                              item['text'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _textColor.value,
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
      },
    );
  }
}
