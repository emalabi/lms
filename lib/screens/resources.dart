import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lms/constants/colors.dart';
import 'package:lms/models/provider_notifier.dart';
import 'package:lms/nav/custom_appbar.dart';
import 'package:lms/service/database.dart';
import 'package:lms/tutor/add_resources.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class Resources extends StatefulWidget {
  final String courseName;
  final String courseId;
  final String username;
  final VoidCallback openDrawer;

  const Resources(
      {Key key,
      @required this.courseId,
      this.courseName,
      this.openDrawer,
      this.username})
      : super(key: key);

  @override
  _ResourcesState createState() => _ResourcesState();
}

class _ResourcesState extends State<Resources> {
  bool dataReceived = false;
  String userRole = '';

  @override
  void initState() {
    getUserData();

    ProviderNotifier notifier =
        Provider.of<ProviderNotifier>(context, listen: false);
    Database()
        .getResources(courseNotifier: notifier, courseId: widget.courseId);
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
          .getResources(courseNotifier: notifier, courseId: widget.courseId);
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
              SizedBox(height: kDefaultPadding),
              Card(
                child: ExpansionTile(
                  title: Text('Documents'),
                  children: [
                    RefreshIndicator(
                      child: ListView.builder(
                        itemCount: notifier.courseList.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                                leading: Icon(Icons.file_present,
                                    color: Colors.yellow),
                                title: Text(notifier.courseList[index].title),
                                subtitle:
                                    Text(notifier.courseList[index].details),
                                trailing: TextButton(
                                  onPressed: () {},
                                  child: Text('Play'),
                                )),
                          );
                        },
                      ),
                      onRefresh: _refreshList,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Card(
                child: ExpansionTile(
                  title: Text('Documents'),
                  children: [
                    RefreshIndicator(
                      child: ListView.builder(
                        itemCount: notifier.courseList.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                                leading: Icon(Icons.video_camera_front,
                                    color: Colors.yellow),
                                title: Text(notifier.courseList[index].title),
                                subtitle:
                                    Text(notifier.courseList[index].details),
                                trailing: TextButton(
                                  onPressed: () {},
                                  child: Text('Play'),
                                )),
                          );
                        },
                      ),
                      onRefresh: _refreshList,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
