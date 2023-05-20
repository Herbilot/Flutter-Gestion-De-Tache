import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> updateNotePasEnCoursCount(String userId) async {
  final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
  final notesRef = FirebaseFirestore.instance.collection('notes');

  try {
    final userSnapshot = await userRef.get();
    final userData = userSnapshot.data() as Map<String, dynamic>;
    int notePasEnCoursCount = 0;

    if (userData != null && userData.containsKey('notePasEnCoursCount')) {
      notePasEnCoursCount = userData['notePasEnCoursCount'] as int;
    }

    final notesSnapshot = await notesRef.get();
    final notesData = notesSnapshot.docs.map((doc) => doc.data()).toList();

    if (notesData != null) {
      final userNotes = notesData
          .where((note) =>
              note['userId'] == userId && note['status'] == 'pas en cours')
          .toList();
      notePasEnCoursCount = userNotes.length;
    }

    await userRef.update({'notePasEnCoursCount': notePasEnCoursCount});
  } catch (error) {
    print(error);
  }
}

Future<int> getNotePasEnCoursCount(String userId) async {
  DocumentSnapshot userSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();
  if (userSnapshot.exists) {
    int notePasEnCoursCount = userSnapshot['notePasEnCoursCount'] ?? 0;
    return notePasEnCoursCount;
  } else {
    return 0;
  }
}
