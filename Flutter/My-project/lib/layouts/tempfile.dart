import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CrudExample(),
    );
  }
}

class CrudExample extends StatefulWidget {
  @override
  _CrudExampleState createState() => _CrudExampleState();
}

class _CrudExampleState extends State<CrudExample> {
  List<Map<String, String>> items = [
    {'name': 'Vishal', 'email': 'vishal@example.com', 'age': '25'},
    {'name': 'Meet', 'email': 'meet@example.com', 'age': '30'},
    {'name': 'Yash', 'email': 'yash@example.com', 'age': '22'},
  ];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  void _createItem(String name, String email, String age) {
    setState(() {
      items.add({'name': name, 'email': email, 'age': age});
    });
    _clearControllers();
  }

  void _updateItem(int index, String name, String email, String age) {
    setState(() {
      items[index] = {'name': name, 'email': email, 'age': age};
    });
    _clearControllers();
  }

  void _deleteItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  void _showEditDialog(int index) {
    _nameController.text = items[index]['name']!;
    _emailController.text = items[index]['email']!;
    _ageController.text = items[index]['age']!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(hintText: 'Enter name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(hintText: 'Enter email'),
            ),
            TextField(
              controller: _ageController,
              decoration: InputDecoration(hintText: 'Enter age'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _updateItem(
                index,
                _nameController.text,
                _emailController.text,
                _ageController.text,
              );
              Navigator.pop(context);
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  void _clearControllers() {
    _nameController.clear();
    _emailController.clear();
    _ageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CRUD with List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(hintText: 'Enter name'),
                ),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(hintText: 'Enter email'),
                ),
                TextField(
                  controller: _ageController,
                  decoration: InputDecoration(hintText: 'Enter age'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_nameController.text.isNotEmpty &&
                        _emailController.text.isNotEmpty &&
                        _ageController.text.isNotEmpty) {
                      _createItem(
                        _nameController.text,
                        _emailController.text,
                        _ageController.text,
                      );
                    }
                  },
                  child: Text('Add Item'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(items[index]['name']!),
                  subtitle: Text(
                      'Email: ${items[index]['email']}\nAge: ${items[index]['age']}'),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _showEditDialog(index),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteItem(index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}