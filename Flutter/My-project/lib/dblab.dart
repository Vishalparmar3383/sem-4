import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class DataBaseDemo extends StatefulWidget {
  const DataBaseDemo({super.key});

  @override
  State<DataBaseDemo> createState() => _DataBaseDemoState();
}

class _DataBaseDemoState extends State<DataBaseDemo> {

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  late Database _database;
  List<Map<String,dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    _initDatabae();
  }

  Future<void> _initDatabae() async {
    _database = await openDatabase(
      join(await getDatabasesPath(),'todo_database.db'),
      onCreate: (db, version) {
        return db.execute('CREATE TABLE todo_databse(id INTEGER PRIMARY KEY AUTOINCREMENT,title TEXT,desc TEXT)');
      },
    );
  }

  Future<void> _getData() async {
    List<Map<String,dynamic>> temp = await _database.query('todo_database');
    data = temp;
  }

  Future<void> _addData(String title,String desc) async{
    await _database.insert('todo_database', {'title':title,'desc':desc});
    _getData();
  }

  Future<void> _deleteData(int id) async {
    await _database.delete('todo_database',where: 'id=?',whereArgs: [id]);
  }

  Future<void> _editData(int id,String title,String desc) async{
    await _database.update('todo_database',{'title':title,'desc':desc},where: 'id=?',whereArgs: [id]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: data.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: data[index]['title'],
              subtitle: data[index]['desc'],
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      titleController.text = data[index]['title'];
                      descController.text = data[index]['desc'];
                      showDialog(context: context, builder: (context) {
                        return AlertDialog(
                          title: Text('Edit'),
                          content: Column(
                            children: [
                            TextField(
                              controller: titleController,
                              decoration: InputDecoration(
                                  labelText: 'title',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)
                                  )
                                ),
                              ),
                              TextField(
                                controller: descController,
                                decoration: InputDecoration(
                                    labelText: 'desc',
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10)
                                    )
                                ),
                              ),
                            ]
                          ),
                          actions: [
                            ElevatedButton(onPressed: () {
                              _editData(data[index]['id'], titleController.text, descController.text);
                              Navigator.pop(context);
                            }, child: Text('Edit')),
                          ],
                        );
                      },);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      showDialog(context: context, builder: (context) {
                        return AlertDialog(
                          title: Text('Are you sure?'),
                          actions: [
                            ElevatedButton(onPressed: () {
                              _deleteData(data[index]['id']);
                              Navigator.pop(context);
                            }, child: Text('Done')),
                            ElevatedButton(onPressed: () {
                              Navigator.pop(context);
                            }, child: Text('Cancel'))
                          ],
                        );
                      },);
                    },
                  ),
                ],
              ),
            );
          },
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        showModalBottomSheet(context: context, builder: (context) {
          return Column(
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                  )
                ),
              ),
              TextField(
                controller: descController,
                decoration: InputDecoration(
                    labelText: 'desc',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
              ),
              ElevatedButton(onPressed: () {
                _addData(titleController.text, descController.text);
                Navigator.pop(context);
              }, child: Text('ADD'))
            ],
          );
        },);
      },),
    );
  }
}
