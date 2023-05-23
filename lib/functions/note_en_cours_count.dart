import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> updateNoteEnCoursCount(String userId) async {
  final userRef =
      FirebaseFirestore.instance.collection('utilisateurs').doc(userId);
  final notesRef = FirebaseFirestore.instance.collection('Tache');

  try {
    final userSnapshot = await userRef.get();
    final userData = userSnapshot.data() as Map<String, dynamic>;
    int noteEnCoursCount = 0;

    if (userData != null && userData.containsKey('TacheEnCoursCount')) {
      noteEnCoursCount = userData['TacheEnCoursCount'] as int;
    }

    final notesSnapshot = await notesRef.get();
    final notesData = notesSnapshot.docs.map((doc) => doc.data()).toList();

    if (notesData != null) {
      final userNotes = notesData
          .where(
              (note) => note['uid'] == userId && note['status'] == 'en cours')
          .toList();
      noteEnCoursCount = userNotes.length;
    }

    await userRef.update({'TacheEnCoursCount': noteEnCoursCount});
  } catch (error) {
    print(error);
  }
}

Future<int> getNoteEnCoursCount(String userId) async {
  DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
      .collection('utilisateurs')
      .doc(userId)
      .get();
  if (userSnapshot.exists) {
    int noteEnCoursCount = userSnapshot['TacheEnCoursCount'] ?? 0;
    return noteEnCoursCount;
  } else {
    return 0;
  }
}
