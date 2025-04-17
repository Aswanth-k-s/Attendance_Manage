import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addStudentDetails(Map<String, dynamic> studentInfo, String id) async {
    return await FirebaseFirestore.instance
        .collection("Student")
        .doc(id)
        .set(studentInfo);
  }

  Future<Stream<QuerySnapshot>> getStudentDetails() async {
    return await FirebaseFirestore.instance.collection("Student").snapshots();
  }

  Future UpdateStudentDetail(String id, Map<String, dynamic> updateInfo) async {
    return await FirebaseFirestore.instance
        .collection("Student")
        .doc(id)
        .update(updateInfo);
  }

  Future DeleteStudentDetail(String id) async {
    try {
      await FirebaseFirestore.instance.collection("Student").doc(id).delete();
      print("StudentData detail deleted successfully");
    } catch (e) {
      print("StudentData deleting employee detail: $e");
    }
  }
}
