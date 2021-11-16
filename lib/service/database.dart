import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:lms/models/course_model.dart';
import 'package:lms/models/models.dart';
import 'package:lms/models/provider_notifier.dart';
import 'package:lms/models/quiz_assignment_model.dart';
import 'package:lms/models/userModel.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart';

// Collection reference
final CollectionReference userCollection =
    FirebaseFirestore.instance.collection('users');
final CollectionReference coursesCollection =
    FirebaseFirestore.instance.collection('courses');
CollectionReference forumRef;
User user = FirebaseAuth.instance.currentUser;
UserModel userModel;

class Database {
  final String uid;
  Database({this.uid});

  // update userdata
  Future updateUserData(UserModel user) async {
    return await userCollection.doc(uid).set({
      'username': user.username,
      'email': user.email,
      'courses': [],
      'imageUrl': user.imageUrl,
      'createdAt': user.createdAt,
      'role': user.role,
    });
  }

// uploadCourse(CourseModel courses) {
//     List<String> splitList = courses.courseName.split(' ');
//     List<String> indexList = courses.indexList;

//     for (int i = 0; i < splitList.length; i++) {
//       for (int j = 0; j < splitList[i].length + 1; j++) {
//         indexList.add(splitList[i].substring(0, j).toLowerCase());
//       }
//     }
//     database.collection('courses').add({
//       'courseName': courseName,
//       'searchIndex': indexList,
//       'courseId': courses.courseId,
//       'tutor': _userName,
//       'createdAt': DateTime.now()
//     });
//   }

  // create group
  Future createGroup(String username, String courseName) async {
    DocumentReference groupDocRef = await coursesCollection.add({
      'courseName': courseName,
      'groupIcon': '',
      'tutor': username,
      'students': [],
      'courseId': '',
      'createdAt': Timestamp.now(),
    });

    await groupDocRef.update({
      'students': FieldValue.arrayUnion([uid + '_' + username]),
      'courseId': groupDocRef.id
    });

    DocumentReference userDocRef = userCollection.doc(uid);
    return await userDocRef.update({
      'courses': FieldValue.arrayUnion([groupDocRef.id + '_' + courseName])
    });
  }

  Future createCourse(
      CourseModel courses, String tutor, Function courseCreated) async {
    courses.createdAt = DateTime.now();
    courses.tutor = tutor;

    // List<String> splitList = courses.courseName.split(' ');
    // List<String> indexList = courses.indexList;

    // for (int i = 0; i < splitList.length; i++) {
    //   for (int j = 0; j < splitList[i].length + 1; j++) {
    //     indexList.add(splitList[i].substring(0, j).toLowerCase());
    //   }
    // }

    DocumentReference documentRef =
        await coursesCollection.add(courses.toJson());

    await documentRef.set(courses.toJson(), SetOptions(merge: true));

    await documentRef.update({
      'students': FieldValue.arrayUnion([uid + '_' + courses.courseName]),
      'courseId': documentRef.id
    });
    courseCreated(courses);

    DocumentReference userDocRef = userCollection.doc(uid);
    return await userDocRef.update({
      'courseIds': FieldValue.arrayUnion([documentRef.id]),
      'courseNames': FieldValue.arrayUnion([courses.courseName]),
      'overview': FieldValue.arrayUnion([courses.overview]),
    });
  }

  // toggling the user group join
  Future togglingGroupJoin(
      {String courseId, String courseName, String username}) async {
    DocumentReference userDocRef = userCollection.doc(uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    DocumentReference groupDocRef = coursesCollection.doc(courseId);

    List<dynamic> courses = await userDocSnapshot.get('courseIds');

    if (courses.contains(courseId)) {
      await userDocRef.update({
        'courseIds': FieldValue.arrayRemove([courseId]),
        // 'courseNames': FieldValue.arrayRemove([courseName])
      });

      await groupDocRef.update({
        'students': FieldValue.arrayRemove([uid + '_' + courseName])
      });
    } else {
      await userDocRef.update({
        // 'courseNames': FieldValue.arrayUnion([courseName]),
        'courseIds': FieldValue.arrayUnion([courseId])
      });

      await groupDocRef.update({
        'students': FieldValue.arrayUnion([uid + '_' + courseName])
      });
    }
  }

  Future joinCourse(
      {String courseId,
      String courseName,
      String username,
      String overview}) async {
    String retVal = "error";
    DocumentReference userDocRef = userCollection.doc(uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();
    DocumentReference groupDocRef = coursesCollection.doc(courseId);
    CollectionReference forumRef;

    List<dynamic> courses = await userDocSnapshot.get('courseIds');

    if (courses.contains(courseId)) {
      retVal = "You have registered for this course";
    } else {
      try {
        await userDocRef.update({
          // 'courseNames': FieldValue.arrayUnion([courseName]),
          'courseIds': FieldValue.arrayUnion([courseId]),
          'courseNames': FieldValue.arrayUnion([courseName]),
          'overview': FieldValue.arrayUnion([overview])
        });

        await groupDocRef.update({
          'students': FieldValue.arrayUnion([uid + '_' + courseName])
        });

        retVal = "success";
      } on PlatformException catch (e) {
        retVal = "Make sure you have the right group ID!";
      } catch (e) {
        print(e);
      }
    }

    return retVal;
  }

  Future<String> leaveGroup(String courseId, UserModel userModel) async {
    String retVal = "error";
    List<String> members = [];
    List<String> tokens = [];
    try {
      members.add(userModel.uid);
      tokens.add(userModel.notifToken);
      await coursesCollection.doc(courseId).update({
        'students': FieldValue.arrayRemove(members),
        'tokens': FieldValue.arrayRemove(tokens),
      });

      await userCollection.doc(userModel.uid).update({
        'courseId': null,
      });
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  // has user joined the group
  Future<bool> isUserJoined(
      {String courseId, String courseName, String username}) async {
    DocumentReference userDocRef = userCollection.doc(uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    List<dynamic> courses = await userDocSnapshot.get('courseIds');

    if (courses.contains(courseId)) {
      return true;
    } else {
      return false;
    }
  }

  // get user data
  Future getUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where('email', isEqualTo: email).get();
    print(snapshot.docs[0].data);
    return snapshot;
  }

  // get user groups
  getUserCourses() async {
    return userCollection.doc(uid).snapshots();
  }

  // send message
  sendMessage(String courseId, chatMessageData) {
    forumRef.doc(courseId).collection('Discussion').add(chatMessageData);
    forumRef.doc(courseId).update({
      'recentMessage': chatMessageData['message'],
      'recentMessageSender': chatMessageData['sender'],
      'recentMessageTime': chatMessageData['time'].toString(),
    });
  }

  // get chats of a particular group
  getChats(String courseId) async {
    return forumRef
        .doc(courseId)
        .collection('Discussion')
        .orderBy('time')
        .snapshots();
  }

  // search groups
  searchByName(String courseName) {
    return FirebaseFirestore.instance
        .collection("courses")
        .where('courseName', isEqualTo: courseName)
        .get();
  }

  Stream<QuerySnapshot> getCourses() {
    return coursesCollection.snapshots();
  }

  getAllCourses({ProviderNotifier courseNotifier, String courseId}) async {
    QuerySnapshot snapshot =
        await coursesCollection.orderBy("createdAt", descending: true).get();

    List<CourseModel> _courseList = [];

    snapshot.docs.forEach((document) {
      CourseModel courses = CourseModel.fromJson(document.data());
      _courseList.add(courses);
    });

    courseNotifier.allCourseList = _courseList;
  }

  getForum({ProviderNotifier courseNotifier, String courseId}) async {
    QuerySnapshot snapshot = await coursesCollection
        .doc(courseId)
        .collection('Forum')
        .orderBy("createdAt", descending: true)
        .get();

    List<Model> _courseList = [];

    snapshot.docs.forEach((document) {
      Model forum = Model.fromMap(document.data());
      _courseList.add(forum);
    });

    courseNotifier.modelList = _courseList;
  }

  uploadForum(Model forum, String courseId, Function forumUploaded) async {
    forumRef = coursesCollection.doc(courseId).collection('Forum');

    forum.createdAt = Timestamp.now();

    DocumentReference documentRef = await forumRef.add(forum.toMap());

    forum.id = documentRef.id;

    await documentRef.set(forum.toMap(), SetOptions(merge: true));

    forumUploaded(forum);
  }

  deleteForum(Model forum, String courseId, Function forumDeleted) async {
    await coursesCollection
        .doc(courseId)
        .collection('Forum')
        .doc(forum.id)
        .delete();
    forumDeleted(forum);
  }

//api for scheduling meetings
  getSchedule({ProviderNotifier courseNotifier, String courseId}) async {
    QuerySnapshot snapshot = await coursesCollection
        .doc(courseId)
        .collection('Schedule')
        .orderBy("createdAt", descending: true)
        .get();

    List<Model> _forumList = [];

    snapshot.docs.forEach((document) {
      Model schedule = Model.fromMap(document.data());
      _forumList.add(schedule);
    });

    courseNotifier.modelList = _forumList;
  }

  uploadSchedule(
      Model schedule, Function forumUploaded, String courseId) async {
    CollectionReference scheduleRef =
        coursesCollection.doc(courseId).collection('Schedule');
    schedule.createdAt = Timestamp.now();
    DocumentReference documentRef = await scheduleRef.add(schedule.toMap());
    schedule.id = documentRef.id;
    await documentRef.set(schedule.toMap(), SetOptions(merge: true));
    forumUploaded(schedule);
  }

  deleteSchedule(Model schedule, Function forumDeleted, String courseId) async {
    await coursesCollection
        .doc(courseId)
        .collection('Schedule')
        .doc(schedule.id)
        .delete();
    forumDeleted(schedule);
  }

//api for announcement
  getAnnouncement({ProviderNotifier courseNotifier, String courseId}) async {
    QuerySnapshot snapshot = await coursesCollection
        .doc(courseId)
        .collection('Announcement')
        .orderBy("createdAt", descending: true)
        .get();

    List<Model> _announcementList = [];

    snapshot.docs.forEach((document) {
      Model announcement = Model.fromMap(document.data());
      _announcementList.add(announcement);
    });

    courseNotifier.modelList = _announcementList;
  }

  uploadAnnouncement(Model announcement, String courseId,
      Function announcementUploaded) async {
    CollectionReference announcementRef =
        coursesCollection.doc(courseId).collection('Announcement');
    announcement.createdAt = Timestamp.now();
    DocumentReference documentRef =
        await announcementRef.add(announcement.toMap());
    announcement.id = documentRef.id;
    await documentRef.set(announcement.toMap(), SetOptions(merge: true));
    announcementUploaded(announcement);
  }

  deleteAnnouncement(
      Model announcement, String courseId, Function announcementDeleted) async {
    await coursesCollection
        .doc(courseId)
        .collection('Announcement')
        .doc(announcement.id)
        .delete();
    announcementDeleted(announcement);
  }

//assignment api
  getAssignment({ProviderNotifier courseNotifier, String courseId}) async {
    QuerySnapshot snapshot = await coursesCollection
        .doc(courseId)
        .collection('Assignment')
        .orderBy("createdAt", descending: true)
        .get();

    List<QuizAssignment> _assignmentList = [];

    snapshot.docs.forEach((document) {
      QuizAssignment assignment = QuizAssignment.fromMap(document.data());
      _assignmentList.add(assignment);
    });

    courseNotifier.assignmentList = _assignmentList;
  }

  uploadAssignment(QuizAssignment assignment, String courseId,
      Function assignmentUploaded) async {
    CollectionReference assignmentRef =
        coursesCollection.doc(courseId).collection('Assignment');
    assignment.createdAt = Timestamp.now();
    DocumentReference documentRef = await assignmentRef.add(assignment.toMap());
    assignment.testId = documentRef.id;

    await documentRef.set(assignment.toMap(), SetOptions(merge: true));
    assignmentUploaded(assignment);
  }

  deleteAssignment(QuizAssignment assignment, String courseId,
      Function announcementDeleted) async {
    await coursesCollection
        .doc(courseId)
        .collection('Assignment')
        .doc(assignment.testId)
        .delete();
    announcementDeleted(assignment);
  }

//course overview api
  getOverview({ProviderNotifier courseNotifier, String courseId}) async {
    QuerySnapshot snapshot = await coursesCollection
        .doc(courseId)
        .collection('Overview')
        .orderBy("createdAt", descending: true)
        .get();

    List<Model> _overviewList = [];

    snapshot.docs.forEach((document) {
      Model announcement = Model.fromMap(document.data());
      _overviewList.add(announcement);
    });

    courseNotifier.modelList = _overviewList;
  }

  uploadOverview(
      Model overview, String courseId, Function overviewUploaded) async {
    CollectionReference announcementRef =
        coursesCollection.doc(courseId).collection('Overview');
    overview.createdAt = Timestamp.now();
    DocumentReference documentRef = await announcementRef.add(overview.toMap());
    overview.id = documentRef.id;
    await documentRef.set(overview.toMap(), SetOptions(merge: true));
    overviewUploaded(overview);
  }

  deleteOverview(
      Model overview, String courseId, Function overviewDeleted) async {
    await coursesCollection
        .doc(courseId)
        .collection('Overview')
        .doc(overview.id)
        .delete();
    overviewDeleted(overview);
  }

//course resources api
  getResources({ProviderNotifier courseNotifier, String courseId}) async {
    QuerySnapshot snapshot = await coursesCollection
        .doc(courseId)
        .collection('Resources')
        .orderBy("createdAt", descending: true)
        .get();

    List<Model> _resourcesList = [];

    snapshot.docs.forEach((document) {
      Model resources = Model.fromMap(document.data());
      _resourcesList.add(resources);
    });

    courseNotifier.modelList = _resourcesList;
  }

  uploadResources(Model resourse, bool isUpdating, String courseId,
      File localFile, Function foodUploaded) async {
    if (localFile != null) {
      print("uploading file");

      var uuid = Uuid().v4();
      String filename = basename(localFile.path);
      Reference reference = FirebaseStorage.instance
          .ref()
          .child('resources/documents/$uuid$filename');
      UploadTask uploadTask = reference.putFile(localFile);
      String url = await (await uploadTask).ref.getDownloadURL();

      _uploadResource(resourse, isUpdating, courseId, foodUploaded,
          imageUrl: url);
    } else {
      _uploadResource(resourse, isUpdating, courseId, foodUploaded);
    }
  }

  void _uploadResource(
      Model resourse, bool isUpdating, String courseId, Function foodUploaded,
      {String imageUrl}) async {
    CollectionReference resourseRef =
        coursesCollection.doc(courseId).collection('Resources');
    if (imageUrl != null) {
      resourse.imageUrl = imageUrl;
    }

    if (isUpdating) {
      resourse.createdAt = Timestamp.now();
      await resourseRef.doc(resourse.id).update(resourse.toMap());
      foodUploaded(resourse);
    } else {
      resourse.createdAt = Timestamp.now();
      DocumentReference documentRef = await resourseRef.add(resourse.toMap());
      resourse.id = documentRef.id;
      await documentRef.set(resourse.toMap(), SetOptions(merge: true));

      foodUploaded(resourse);
    }
  }
}
