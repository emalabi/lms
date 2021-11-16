import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lms/models/provider_notifier.dart';

import 'models.dart';

CollectionReference courses = FirebaseFirestore.instance.collection('Courses');

getForum(ProviderNotifier courseNotifier, String courseId) async {
  QuerySnapshot snapshot = await courses
      .doc(courseId)
      .collection('Forum')
      .orderBy("createdAt", descending: true)
      .get();

  List<Model> _forumList = [];

  snapshot.docs.forEach((document) {
    Model forum = Model.fromMap(document.data());
    _forumList.add(forum);
  });

  courseNotifier.modelList = _forumList;
}

uploadForum(Model forum, String courseId, Function forumUploaded) async {
  CollectionReference forumRef = courses.doc(courseId).collection('Forum');

  forum.createdAt = Timestamp.now();

  DocumentReference documentRef = await forumRef.add(forum.toMap());

  forum.id = documentRef.id;

  await documentRef.set(forum.toMap(), SetOptions(merge: true));

  forumUploaded(forum);
}

deleteForum(Model forum, String courseId, Function forumDeleted) async {
  await courses.doc(courseId).collection('Forum').doc(forum.id).delete();
  forumDeleted(forum);
}

//api for scheduling meetings
getSchedule(ProviderNotifier courseNotifier, String courseId) async {
  QuerySnapshot snapshot = await courses
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

uploadSchedule(Model schedule, Function forumUploaded, String courseId) async {
  CollectionReference scheduleRef =
      courses.doc(courseId).collection('Schedule');

  schedule.createdAt = Timestamp.now();

  DocumentReference documentRef = await scheduleRef.add(schedule.toMap());

  schedule.id = documentRef.id;

  await documentRef.set(schedule.toMap(), SetOptions(merge: true));

  forumUploaded(schedule);
}

deleteSchedule(Model schedule, Function forumDeleted, String courseId) async {
  await courses.doc(courseId).collection('Schedule').doc(schedule.id).delete();
  forumDeleted(schedule);
}

//api for announcement
getAnnouncement(ProviderNotifier courseNotifier, String courseId) async {
  QuerySnapshot snapshot = await courses
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

uploadAnnouncement(
    Model announcement, String courseId, Function announcementUploaded) async {
  CollectionReference announcementRef =
      courses.doc(courseId).collection('Announcement');
  announcement.createdAt = Timestamp.now();
  DocumentReference documentRef =
      await announcementRef.add(announcement.toMap());
  announcement.id = documentRef.id;
  await documentRef.set(announcement.toMap(), SetOptions(merge: true));
  announcementUploaded(announcement);
}

deleteAnnouncement(
    Model announcement, String courseId, Function announcementDeleted) async {
  await courses
      .doc(courseId)
      .collection('Announcement')
      .doc(announcement.id)
      .delete();
  announcementDeleted(announcement);
}

//assignment api
getAssignment(ProviderNotifier courseNotifier, String courseId) async {
  QuerySnapshot snapshot = await courses
      .doc(courseId)
      .collection('Assignment')
      .orderBy("createdAt", descending: true)
      .get();

  List<Model> _assignmentList = [];

  snapshot.docs.forEach((document) {
    Model announcement = Model.fromMap(document.data());
    _assignmentList.add(announcement);
  });

  courseNotifier.modelList = _assignmentList;
}

uploadAssignment(
    Model assignment, String courseId, Function assignmentUploaded) async {
  CollectionReference assignmentRef =
      courses.doc(courseId).collection('Assignment');
  assignment.createdAt = Timestamp.now();
  DocumentReference documentRef = await assignmentRef.add(assignment.toMap());
  assignment.id = documentRef.id;
  await documentRef.set(assignment.toMap(), SetOptions(merge: true));
  assignmentUploaded(assignment);
}

deleteAssignment(
    Model announcement, String courseId, Function announcementDeleted) async {
  await courses
      .doc(courseId)
      .collection('Assignment')
      .doc(announcement.id)
      .delete();
  announcementDeleted(announcement);
}

//course overview api
getOverview(ProviderNotifier courseNotifier, String courseId) async {
  QuerySnapshot snapshot = await courses
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
      courses.doc(courseId).collection('Overview');
  overview.createdAt = Timestamp.now();
  DocumentReference documentRef = await announcementRef.add(overview.toMap());
  overview.id = documentRef.id;
  await documentRef.set(overview.toMap(), SetOptions(merge: true));
  overviewUploaded(overview);
}

deleteOverview(
    Model overview, String courseId, Function overviewDeleted) async {
  await courses.doc(courseId).collection('Overview').doc(overview.id).delete();
  overviewDeleted(overview);
}
