import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> updateNotePasEnCoursCount(String userId) async {
  final userRef =
      FirebaseFirestore.instance.collection('utilisateurs').doc(userId);
  final notesRef = FirebaseFirestore.instance.collection('Tache');

  try {
    final userSnapshot = await userRef.get();
    final userData = userSnapshot.data() as Map<String, dynamic>;
    int notePasEnCoursCount = 0;

    if (userData != null && userData.containsKey('TachePasEnCoursCount')) {
      notePasEnCoursCount = userData['TachePasEnCoursCount'] as int;
    }

    final notesSnapshot = await notesRef.get();
    final notesData = notesSnapshot.docs.map((doc) => doc.data()).toList();

    if (notesData != null) {
      final userNotes = notesData
          .where((note) =>
              note['uid'] == userId && note['status'] == 'pas en cours')
          .toList();
      notePasEnCoursCount = userNotes.length;
    }

    await userRef.update({'TachePasEnCoursCount': notePasEnCoursCount});
  } catch (error) {
    print(error);
  }
}

Future<int> getNotePasEnCoursCount(String userId) async {
  DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
      .collection('utilisateurs')
      .doc(userId)
      .get();
  if (userSnapshot.exists) {
    int notePasEnCoursCount = userSnapshot['TachePasEnCoursCount'] ?? 0;
    return notePasEnCoursCount;
  } else {
    return 0;
  }
}
