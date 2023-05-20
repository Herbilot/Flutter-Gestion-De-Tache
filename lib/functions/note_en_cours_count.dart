import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> updateNoteEnCoursCount(String userId) async {
  final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
  final notesRef = FirebaseFirestore.instance.collection('notes');

  try {
    final userSnapshot = await userRef.get();
    final userData = userSnapshot.data() as Map<String, dynamic>;
    int noteEnCoursCount = 0;

    if (userData != null && userData.containsKey('noteEnCoursCount')) {
      noteEnCoursCount = userData['noteEnCoursCount'] as int;
    }

    final notesSnapshot = await notesRef.get();
    final notesData = notesSnapshot.docs.map((doc) => doc.data()).toList();

    if (notesData != null) {
      final userNotes = notesData
          .where((note) =>
              note['userId'] == userId && note['status'] == 'en cours')
          .toList();
      noteEnCoursCount = userNotes.length;
    }

    await userRef.update({'noteEnCoursCount': noteEnCoursCount});
  } catch (error) {
    print(error);
  }
}

Future<int> getNoteEnCoursCount(String userId) async {
  DocumentSnapshot userSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();
  if (userSnapshot.exists) {
    int noteEnCoursCount = userSnapshot['noteEnCoursCount'] ?? 0;
    return noteEnCoursCount;
  } else {
    return 0;
  }
}
