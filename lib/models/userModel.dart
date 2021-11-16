import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String email;
  String password;
  Timestamp createdAt;
  String username;
  String courseId;
  String notifToken;
  List<String> courses;
  String courseName;
  String role;
  String imageUrl;

  UserModel({
    this.uid,
    this.email,
    this.createdAt,
    this.username,
    this.courseId,
    this.notifToken,
    this.courseName,
    this.role,
    this.password,
    this.imageUrl,
    this.courses,
  });

  UserModel.fromDocumentSnapshot({DocumentSnapshot doc}) {
    uid = doc.id;
    email = doc.get('email');
    createdAt = doc.get('createdAt');
    username = doc.get('username');
    password = doc.get('password');
    courseId = doc.get('groupId');
    courseName = doc.get('courseName');
    role = doc.get('role');
    notifToken = doc.get('notifToken');
    imageUrl = doc.get('imageUrl');
    courses = doc.get('courses');
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'imageUrl': imageUrl,
      'role': role,
      'password': password,
      'createdAt': createdAt,
      'email': email,
      'courseId': courseId,
      'notifToken': notifToken,
      'courseName': courseName,
      'courses': courses,
    };
  }

  UserModel.fromMap(Map<String, dynamic> data) {
    uid = data['uid'];
    username = data['username'];
    imageUrl = data['imageUrl'];
    role = data['role'];
    createdAt = data['createdAt'];
    email = data['email'];
    courseName = data['courseName'];
    notifToken = data['notifToken'];
    courseId = data['courseId'];
    courses = data['courses'];
  }
}
