import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/delete_complete_dialog.dart';

class CompletesPage extends StatefulWidget {
  final Map<String, dynamic> data;

  const CompletesPage({Key? key, required this.data}) : super(key: key);

  @override
  _CompletesPageState createState() => _CompletesPageState();
}

class _CompletesPageState extends State<CompletesPage> {
  late Map<String, dynamic> data;

  @override
  void initState() {
    super.initState();
    data = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('completes').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Text('No completed tasks to display');
          } else {
            List<DocumentSnapshot> completedTasks = snapshot.data!.docs;

            return ListView(
              children: completedTasks.map((DocumentSnapshot document) {
                Map<String, dynamic> taskData =
                    document.data() as Map<String, dynamic>;

                return Dismissible(
                  key: Key(document.id),
                  onDismissed: (direction) {
                    // Hapus item dari daftar ketika di-swipe
                    setState(() {
                      completedTasks.remove(document);
                    });

                    // Tampilkan snackbar "Task Uncompleted"
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Task Uncompleted'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Container(
                    height: 80,
                    margin: const EdgeInsets.only(bottom: 15.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.white,
                    ),
                    child: ListTile(
                      leading: Checkbox(
                        value:
                            true, // Gantilah dengan status ceklis yang sesuai
                        onChanged: (bool? value) {
                          // Logika ketika ceklis berubah
                          if (value == false) {
                            // Pindahkan item ke tasks_page.dart
                            _onCheckboxChanged(document, value ?? true);
                          }
                        },
                      ),
                      title: Text(taskData['taskName']),
                      subtitle: Text(taskData['taskDesc']),
                      isThreeLine: true,
                      trailing: PopupMenuButton(
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              value: 'delete',
                              child: const Text(
                                'Delete',
                                style: TextStyle(fontSize: 13.0),
                              ),
                              onTap: () {
                                String taskId =
                                    document.id; // Use document.id directly
                                String taskName = taskData['taskName'];
                                Future.delayed(
                                  const Duration(seconds: 0),
                                  () => showDialog(
                                    context: context,
                                    builder: (context) => DeleteCompleteDialog(
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

  // Tambahkan fungsi untuk menangani perubahan status ceklis
  void _onCheckboxChanged(DocumentSnapshot document, bool value) async {
    var tasksCollection = FirebaseFirestore.instance.collection('tasks');
    var completesCollection =
        FirebaseFirestore.instance.collection('completes');
    var taskData = document.data() as Map<String, dynamic>;

    // Update the 'isCompleted' field
    await completesCollection.doc(document.id).update({'isCompleted': value});

    // Pindahkan item dari 'tasks' ke 'completes' jika ceklis bernilai true
    if (value) {
      await completesCollection.add({
        'taskName': taskData['taskName'],
        'taskDesc': taskData['taskDesc'],
        'taskTag': taskData['taskTag'],
      });
      await tasksCollection.doc(document.id).delete();
    } else {
      // Pindahkan item dari 'completes' ke 'tasks' jika ceklis bernilai false
      await tasksCollection.add({
        'taskName': taskData['taskName'],
        'taskDesc': taskData['taskDesc'],
        'taskTag': taskData['taskTag'],
      });
      await completesCollection.doc(document.id).delete();
    }
  }
}
