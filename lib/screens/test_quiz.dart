import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lms/constants/colors.dart';
import 'package:lms/models/provider_notifier.dart';
import 'package:lms/nav/custom_appbar.dart';
import 'package:lms/service/database.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:lms/tutor/test_quiz_form.dart';

class TestQuiz extends StatefulWidget {
  final String courseName;
  final String courseId;
  final String username;
  final VoidCallback openDrawer;

  const TestQuiz(
      {Key key,
      @required this.courseId,
      this.courseName,
      this.openDrawer,
      this.username})
      : super(key: key);

  @override
  _TestQuizState createState() => _TestQuizState();
}

class _TestQuizState extends State<TestQuiz> {
  bool dataReceived = false;
  String userRole = '';

  @override
  void initState() {
    getUserData();

    ProviderNotifier notifier =
        Provider.of<ProviderNotifier>(context, listen: false);
    Database()
        .getAnnouncement(courseNotifier: notifier, courseId: widget.courseId);
    super.initState();
  }

  getUserData() async {
    DocumentSnapshot userdoc =
        await userCollection.doc(FirebaseAuth.instance.currentUser.uid).get();
    setState(() {
      userRole = userdoc.get('role');
      dataReceived = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    ProviderNotifier notifier = Provider.of<ProviderNotifier>(context);

    Future<void> _refreshList() async {
      Database()
          .getAnnouncement(courseNotifier: notifier, courseId: widget.courseId);
    }

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          openDrawer: widget.openDrawer,
        ),
        body: Container(
          padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
          child: Column(
            children: [
              Divider(thickness: 1),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Container(
                  child: dataReceived == false
                      ? CircularProgressIndicator()
                      : userRole == 'Tutor'
                          ? TextButton(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  "Add Test",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                _navigate(BuildContext context) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddTestQuiz(
                                          courseId: widget.courseId,
                                          userName: widget.username,
                                          courseName: widget.courseName,
                                        ),
                                      ));
                                }

                                _navigate(context);
                              },
                            )
                          : Container(),
                ),
              ),
              SizedBox(height: kDefaultPadding),
              Expanded(
                child: RefreshIndicator(
                  child: ListView.builder(
                    itemCount: notifier.courseList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(notifier.courseList[index].title),
                          subtitle: Text(notifier.courseList[index].details),
                        ),
                      );
                    },
                  ),
                  onRefresh: _refreshList,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
