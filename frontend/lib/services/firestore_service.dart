import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final CollectionReference notes =
      FirebaseFirestore.instance.collection('notes');
  final user = FirebaseAuth.instance.currentUser;
  //create
  Future<void> addNote(String note) {
    
    return notes.add({
      'user': user?.uid.toString(),
      'note': note,
      'timestamp': Timestamp.now()
    });
  }

  //read (conditional)
  Stream<QuerySnapshot> getNotesStream(String userId) {
    final notesStream = notes
        .where('user', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots();
    return notesStream;
  }

  //update
  Future<void> updateNote(String docId, String newNote) {
    return notes.doc(docId).update({
      'user': user?.uid.toString(),
      'note':newNote,
      'timeStamp':Timestamp.now(),
    });
  }

  //delete
  Future<void> deleteNote(String docId) {
    return notes.doc(docId).delete();
  }
}
