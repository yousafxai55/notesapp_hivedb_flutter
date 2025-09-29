import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hivenosqlproject/boxes/boxes.dart';

import 'models/notes_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),

      body: ValueListenableBuilder<Box<NotesModel>>(
        valueListenable: Boxes.getData().listenable(),
        builder: (context, box, _) {
          var data = box.values.toList().cast<NotesModel>();
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 10,
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,

                    children: [
                      Row(
                        children: [
                          Text(
                            data[index].title.toString(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              deleteData(data[index]);
                            },
                            child: Icon(Icons.delete, color: Colors.red),
                          ),
                          SizedBox(width: 15),

                          InkWell(
                            onTap: () {
                              _editDialog(
                                data[index],
                                data[index].title.toString(),
                                data[index].description.toString(),
                              );
                            },
                            child: Icon(Icons.edit),
                          ),
                        ],
                      ),
                      Text(
                        data[index].description.toString(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _showMyDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void deleteData(NotesModel notesModel) async {
    await notesModel.delete();
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add NOTES'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: 'Enter Title',
                    border: OutlineInputBorder(),
                  ),
                ),

                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Enter description',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final data = NotesModel(
                  title: titleController.text,
                  description: descriptionController.text,
                );

                final box = Boxes.getData();
                box.add(data);

                data.save();
                titleController.clear();
                descriptionController.clear();

                Navigator.pop(context);
              },
              child: Text('Add'),
            ),

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editDialog(
    NotesModel notesModel,
    String title,
    String description,
  ) async {
    titleController.text = title;
    descriptionController.text = description;

    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Added NOTES'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: 'Enter Title',
                    border: OutlineInputBorder(),
                  ),
                ),

                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Enter description',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                notesModel.title = titleController.text.toString();
                notesModel.description = descriptionController.text.toString();

                notesModel.save();
                titleController.clear();
                descriptionController.clear();

                Navigator.pop(context);
              },
              child: Text('Edit'),
            ),

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
