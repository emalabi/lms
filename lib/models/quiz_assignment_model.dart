import 'package:cloud_firestore/cloud_firestore.dart';

class QuizAssignment {
  String testId;
  String title;
  String status;
  String openDate;
  String dueDate;
  String createdBy;
  Timestamp createdAt, updatedAt;

  QuizAssignment();

  QuizAssignment.fromMap(Map<String, dynamic> data) {
    testId = data['testId'];
    title = data['title'];
    status = data['status'];
    openDate = data['openDate'];
    createdBy = data['createdBy'];
    dueDate = data['dueDate'];
    createdAt = data['createdAt'];
    updatedAt = data['updatedAt'];
  }

  Map<String, dynamic> toMap() {
    return {
      'testId': testId,
      'title': title,
      'status': status,
      'openDate': openDate,
      'createdBy': createdBy,
      'updatedAt': updatedAt,
      'dueDate': dueDate,
      'createdAt': createdAt,
    };
  }
}
