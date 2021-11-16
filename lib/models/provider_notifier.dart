import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:lms/models/course_model.dart';
import 'package:lms/models/models.dart';
import 'package:lms/models/quiz_assignment_model.dart';

class ProviderNotifier with ChangeNotifier {
  List<Model> _courseList = [];
  Model _currentModel;

  UnmodifiableListView<Model> get courseList =>
      UnmodifiableListView(_courseList);

  Model get currentModel => _currentModel;

  set modelList(List<Model> courseList) {
    _courseList = courseList;
    notifyListeners();
  }

  set currentModel(Model course) {
    _currentModel = course;
    notifyListeners();
  }

  addCourse(Model course) {
    _courseList.insert(0, course);
    notifyListeners();
  }

  deleteCourse(Model course) {
    _courseList.removeWhere((_course) => _course.id == course.id);
    notifyListeners();
  }

  //Assignment provider notifier
  List<QuizAssignment> _assignmentList = [];
  QuizAssignment _currentAssignment;

  UnmodifiableListView<QuizAssignment> get assignmentList =>
      UnmodifiableListView(_assignmentList);

  QuizAssignment get currentAssignment => _currentAssignment;

  set assignmentList(List<QuizAssignment> assignmentList) {
    _assignmentList = assignmentList;
    notifyListeners();
  }

  set currentAssignment(QuizAssignment assignment) {
    _currentAssignment = assignment;
    notifyListeners();
  }

  addAssignment(QuizAssignment assignment) {
    _assignmentList.insert(0, assignment);
    notifyListeners();
  }

  deleteAssignment(QuizAssignment assignment) {
    _assignmentList
        .removeWhere((_assignment) => _assignment.testId == assignment.testId);
    notifyListeners();
  }

  //Courses provider notifier
  List<CourseModel> _allCoursesList = [];
  CourseModel _currentAllCourses;

  UnmodifiableListView<CourseModel> get allCourses =>
      UnmodifiableListView(_allCoursesList);

  CourseModel get currentCourse => _currentAllCourses;

  set allCourseList(List<CourseModel> assignmentList) {
    _allCoursesList = assignmentList;
    notifyListeners();
  }

  set currentAllCourses(CourseModel courses) {
    _currentAllCourses = courses;
    notifyListeners();
  }

  addAllCourses(CourseModel courses) {
    _allCoursesList.insert(0, courses);
    notifyListeners();
  }

  deleteAllCourses(CourseModel courses) {
    _allCoursesList
        .removeWhere((_courses) => _courses.courseId == courses.courseId);
    notifyListeners();
  }
}
