import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add a category
  Future<String> addCategory(String userId, String categoryName, int id) async {
    DocumentReference categoryRef =
        _db.collection('users').doc(userId).collection('categories').doc();

    await categoryRef.set({'name': categoryName, 'id': id});
    return categoryRef.id;
  }

  // Add a student to a category
  Future<void> addStudent(
      String userId, String categoryId, int studentNumber) async {
    // Check if the category already has 100 students
    QuerySnapshot studentSnapshot = await _db
        .collection('users')
        .doc(userId)
        .collection('categories')
        .doc(categoryId)
        .collection('students')
        .get();

    if (studentSnapshot.docs.length >= 100) {
      throw Exception('This category already has 100 students.');
    }

    DocumentReference studentRef = _db
        .collection('users')
        .doc(userId)
        .collection('categories')
        .doc(categoryId)
        .collection('students')
        .doc();

    await studentRef.set({'number': studentNumber});
  }

  // Add an award to a student
  Future<void> addAward(String userId, String categoryId, String studentId,
      String awardName, int mark) async {
    DocumentReference awardRef = _db
        .collection('users')
        .doc(userId)
        .collection('categories')
        .doc(categoryId)
        .collection('students')
        .doc(studentId)
        .collection('awards')
        .doc();

    await awardRef.set({
      'name': awardName,
      'mark': mark,
    });
  }

  // Function to get students by category for a specific user
  Future<List<Map<String, dynamic>>> getStudentsByCategory(
      String userId, String categoryName) async {
    try {
      // Get the categories for the specified user that match the given category name
      final categorySnapshot = await _db
          .collection('users')
          .doc(userId)
          .collection('categories')
          .where('name', isEqualTo: categoryName)
          .get();

      List<Map<String, dynamic>> matchingStudents = [];

      // Check if any categories matched
      for (final categoryDoc in categorySnapshot.docs) {
        // Now fetch the students for this specific category
        final studentSnapshot =
            await categoryDoc.reference.collection('students').get();

        // Iterate through each student document in this category
        for (final studentDoc in studentSnapshot.docs) {
          matchingStudents.add(studentDoc.data() as Map<String, dynamic>);
        }
      }

      matchingStudents.sort((a, b) {
        return (a['number'] as int).compareTo(
            b['number'] as int); 
      });
      
      return matchingStudents; // Return the collected student documents
    } catch (e) {
      print('Error fetching students: $e');
      rethrow; // Rethrow the exception to handle it where this function is called
    }
  }

  // Get categories for a user
  Stream<List<String>> getCategories(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('categories')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => doc['name'] as String).toList());
  }

  Stream<List<Map<String, dynamic>>> getCategories_2(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('categories')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => ({'name': doc['name']})).toList());
  }
}
