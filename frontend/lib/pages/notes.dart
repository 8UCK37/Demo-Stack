import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:graphedemo/services/data_service.dart';
import 'package:graphedemo/services/firestore_service.dart';
import 'package:graphedemo/utils/drawer.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController textController = TextEditingController();

  void addNoteModal(String? docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              debugPrint("add note pressed");
              if (docId == null) {
                firestoreService.addNote(textController.text);
              } else {
                firestoreService.updateNote(docId, textController.text);
              }
              setState(() {
                textController.text = '';
              });
              QuickAlert.show(
                  context: context,
                  type: QuickAlertType.success,
                  text: 'Done !!!',
                  showConfirmBtn: false,
                  autoCloseDuration: const Duration(milliseconds: 700));
              Future.delayed(const Duration(milliseconds: 500), () {
                Navigator.of(context).pop();
              });
            },
            child: Text(docId != null ? "Edit" : "Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dataService = Provider.of<DataService>(context, listen: true);
    final userData = dataService.currentUser;
    final userFromSignin=FirebaseAuth.instance.currentUser;
    return Scaffold(
      floatingActionButton: GestureDetector(
        onTap: () {
          debugPrint("saveChanges");
          addNoteModal(null);
        },
        child: const Material(
          elevation: 20,
          shape: CircleBorder(),
          child: ClipOval(
            child: CircleAvatar(
              backgroundColor: Colors.green,
              radius: 40,
              child: Icon(
                size: 50,
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SliderDrawer(
          appBar: const SliderAppBar(
              appBarColor: Colors.white,
              title: Text("Notes",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700))),
          slider: const DrawerWidget(),
          child: Container(
            height: double.infinity,
            child: StreamBuilder<QuerySnapshot>(
              stream: firestoreService.getNotesStream(userData['id']??userFromSignin?.uid),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.docs.length != 0) {
                  List notesList = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: notesList.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = notesList[index];
                      String docId = document.id;

                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      String noteText = data['note'];
                      Timestamp timestamp = data['timestamp'];
                      String timeStamp =
                          "${timestamp.toDate().year}-${timestamp.toDate().month.toString().padLeft(2, '0')}-${timestamp.toDate().day.toString().padLeft(2, '0')} ${timestamp.toDate().hour.toString().padLeft(2, '0')}:${timestamp.toDate().minute.toString().padLeft(2, '0')}";
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 159, 150, 150),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: ListTile(
                            title: Text("CreatedAt: ${timeStamp}"),
                            subtitle: Text(
                              noteText,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                            trailing: SizedBox(
                              width: 75,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        addNoteModal(docId);
                                      },
                                      child: const Icon(Icons.edit)),
                                  GestureDetector(
                                    onTap: () {
                                      firestoreService.deleteNote(docId);               
                                      if (notesList.length > 1) {
                                        QuickAlert.show(
                                          context: context,
                                          type: QuickAlertType.success,
                                          text: 'Deleted !!!',
                                          showConfirmBtn: false,
                                          autoCloseDuration:
                                              const Duration(milliseconds: 700),
                                        );
                                      }
                                    },
                                    child: const Icon(
                                      Icons.delete,
                                      color: Color.fromARGB(255, 177, 69, 61),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Text("You have no notes\nright now");
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
