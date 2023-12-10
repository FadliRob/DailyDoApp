import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_uas/widgets/update_task_dialog.dart';
import '../constants/colors.dart';
import '../widgets/delete_task_dialog.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final fireStore = FirebaseFirestore.instance;
  late QuerySnapshot taskSnapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: fireStore.collection('tasks').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text('No tasks to display');
          } else {
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                Color taskColor = tdDarkBlue;
                var taskTag = data['taskTag'];
                if (taskTag == 'School') {
                  taskColor = Colors.redAccent;
                } else if (taskTag == 'Home') {
                  taskColor = Colors.greenAccent;
                } else if (taskTag == 'Work') {
                  taskColor = Colors.yellowAccent;
                }

                bool isCompleted =
                    data['isCompleted'] != null ? data['isCompleted'] : false;

                return Dismissible(
                  key: Key(data['id']),
                  onDismissed: (direction) {
                    setState(() {
                      snapshot.data!.docs.remove(document);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Task Completed'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                    _onCheckboxChanged(document, true);
                  },
                  background: Container(
                    decoration: BoxDecoration(
                      color: taskColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  child: Container(
                    height: 80,
                    margin: const EdgeInsets.only(bottom: 15.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.white,
                      border: Border.all(
                        color: taskColor,
                        width: 2.0,
                      ),
                    ),
                    child: ListTile(
                      leading: Checkbox(
                        value: isCompleted,
                        onChanged: (bool? value) {
                          _onCheckboxChanged(document, value ?? false);
                        },
                      ),
                      title: Text(data['taskName']),
                      subtitle: Text(data['taskDesc']),
                      isThreeLine: true,
                      trailing: PopupMenuButton(
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              value: 'edit',
                              child: const Text(
                                'Edit',
                                style: TextStyle(fontSize: 13.0),
                              ),
                              onTap: () {
                                String taskId = (data['id']);
                                String taskName = (data['taskName']);
                                String taskDesc = (data['taskDesc']);
                                String taskTag = (data['taskTag']);
                                Future.delayed(
                                  const Duration(seconds: 0),
                                  () => showDialog(
                                    context: context,
                                    builder: (context) => UpdateTaskAlertDialog(
                                      taskId: taskId,
                                      taskName: taskName,
                                      taskDesc: taskDesc,
                                      taskTag: taskTag,
                                    ),
                                  ),
                                );
                              },
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: const Text(
                                'Delete',
                                style: TextStyle(fontSize: 13.0),
                              ),
                              onTap: () {
                                String taskId = (data['id']);
                                String taskName = (data['taskName']);
                                Future.delayed(
                                  const Duration(seconds: 0),
                                  () => showDialog(
                                    context: context,
                                    builder: (context) => DeleteTaskDialog(
                                      taskId: taskId,
                                      taskName: taskName,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ];
                        },
                      ),
                      dense: true,
                    ),
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }

  void _onCheckboxChanged(DocumentSnapshot document, bool value) async {
    var collection = FirebaseFirestore.instance.collection('tasks');
    await collection.doc(document.id).update({'isCompleted': value});

    if (value) {
      var completesCollection =
          FirebaseFirestore.instance.collection('completes');
      var taskData = document.data() as Map<String, dynamic>;

      await completesCollection.add({
        'taskName': taskData['taskName'],
        'taskDesc': taskData['taskDesc'],
        'taskTag': taskData['taskTag'],
      });

      await collection.doc(document.id).delete();
    }
  }
}
