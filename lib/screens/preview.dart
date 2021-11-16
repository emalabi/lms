import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lms/constants/colors.dart';
import 'package:lms/constants/constants.dart';
import 'package:lms/models/provider_notifier.dart';
import 'package:lms/models/userModel.dart';
import 'package:lms/nav/custom_appbar.dart';
import 'package:lms/service/database.dart';
import 'package:lms/widget/main_screen.dart';
import 'package:lms/widget/preview_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class Preview extends StatefulWidget {
  final String courseName;
  final String username;
  final String courseId;
  final String overview;
  final VoidCallback openDrawer;

  const Preview(
      {Key key,
      @required this.courseId,
      this.courseName,
      this.username,
      this.openDrawer,
      this.overview})
      : super(key: key);

  @override
  _PreviewState createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool dataReceived = false;
  String userRole = '';
  bool _isJoined = false;

  @override
  void initState() {
    getUserData();
    _joinValueInGroup(widget.username, widget.courseId, widget.courseName);
    super.initState();
  }

  getUserData() async {
    DocumentSnapshot userdoc =
        await userCollection.doc(FirebaseAuth.instance.currentUser.uid).get();
    setState(() {
      userRole = userdoc.get('role');
      dataReceived = true;
      _isJoined = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          openDrawer: widget.openDrawer,
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
            child: Column(
              children: [
                Divider(thickness: 1),
                Container(
                  child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: groupTile(
                        widget.username,
                        widget.courseId,
                        widget.courseName,
                        widget.overview,
                      )),
                ),
                SizedBox(height: kDefaultPadding),

                // Expanded(
                //   child: RefreshIndicator(
                //     child: ListView.builder(
                //       itemCount: notifier.courseList.length,
                //       itemBuilder: (context, index) {
                //         return Card(
                //           child: ListTile(
                //             title: Text(notifier.courseList[index].title),
                //             subtitle: Text(notifier.courseList[index].details),
                //           ),
                //         );
                //       },
                //     ),
                //     onRefresh: _refreshList,
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _joinGroup(BuildContext context, String groupId) async {
    UserModel _currentUser = userModel;
    String _returnString = await Database().joinCourse(
        courseId: widget.courseId,
        courseName: widget.courseName,
        username: widget.username);
    if (_returnString == "success") {
      return;
    } else {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(_returnString),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  _joinValueInGroup(String username, String courseId, String courseName) async {
    bool value = await Database(uid: user.uid).isUserJoined(
      courseId: courseId,
      courseName: courseName,
      username: username,
    );
    setState(() {
      _isJoined = value;
    });
  }

  // Widget groupTile(String username, String courseId, String courseName) {
  //   _joinValueInGroup(username, courseId, courseName);
  //   return Card(
  //     child: ListTile(
  //       contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
  //       leading: CircleAvatar(
  //           radius: 30.0,
  //           backgroundColor: Colors.blueAccent,
  //           child: Text(courseName.substring(0, 1).toUpperCase(),
  //               style: TextStyle(color: Colors.white))),
  //       title: Text(courseName, style: TextStyle(fontWeight: FontWeight.bold)),
  //       subtitle: Text('Tutor: $username', style: TextStyle(fontSize: 10)),
  //       trailing: _isJoined
  //           ? Container(
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(10.0),
  //                 color: Colors.blueAccent,
  //               ),
  //               padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
  //               child: InkWell(
  //                   onTap: () async {
  //                     await Database(uid: user.uid).joinCourse(
  //                         courseId: courseId,
  //                         courseName: courseName,
  //                         username: username);
  //                     if (_isJoined) {
  //                       setState(() {
  //                         _isJoined = !_isJoined;
  //                       });
  //                       showScaffold(
  //                           'Successfully joined the course "$courseName"');
  //                     } else {
  //                       setState(() {
  //                         _isJoined = !_isJoined;
  //                       });
  //                       showScaffold('Left the group "$courseName"');
  //                     }
  //                   },
  //                   child: Text('Join', style: TextStyle(color: Colors.white))),
  //             )
  //           : Container(
  //               decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(10.0),
  //                   color: Colors.black87,
  //                   border: Border.all(color: Colors.white, width: 1.0)),
  //               padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
  //               child: InkWell(
  //                   child: Text('Go to course',
  //                       style: TextStyle(color: Colors.white)),
  //                   onTap: () {
  //                     Navigator.pushAndRemoveUntil(
  //                         context,
  //                         MaterialPageRoute(
  //                             builder: (context) => MainScreen(
  //                                 courseId: widget.courseId,
  //                                 courseName: widget.courseName)),
  //                         (Route<dynamic> route) => false);
  //                   }),
  //             ),
  //     ),
  //   );
  // }

  Widget groupTile(
      String username, String courseId, String courseName, String overview) {
    _joinValueInGroup(username, courseId, courseName);
    return SingleChildScrollView(
      child: Column(
        children: [
          ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            leading: CircleAvatar(
                radius: 30.0,
                backgroundColor: Colors.blueAccent,
                child: Text(courseName.substring(0, 1).toUpperCase(),
                    style: TextStyle(color: Colors.white))),
            title:
                Text(courseName, style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("Tutor: $username"),
            trailing: InkWell(
              onTap: () async {
                await Database(uid: user.uid).joinCourse(
                    courseId: courseId,
                    courseName: courseName,
                    overview: overview,
                    username: username);
                if (_isJoined) {
                  setState(() {
                    _isJoined = !_isJoined;
                  });
                  // await DatabaseService(uid: _user.uid).userJoinGroup(groupId, groupName, userName);
                  showScaffold('Successfully joined the group "$courseName"');
                } else {
                  setState(() {
                    _isJoined = !_isJoined;
                  });
                  showScaffold('Left the group "$courseName"');
                }
              },
              child: _isJoined
                  ? Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: Colors.white, width: 1.0)),
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MainScreen(
                                        courseId: widget.courseId,
                                        overview: widget.overview,
                                        courseName: widget.courseName)),
                                (Route<dynamic> route) => false);
                          },
                          child: Text('Go to course',
                              style: TextStyle(color: Colors.white))),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.blueAccent,
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child:
                          Text('Join', style: TextStyle(color: Colors.white)),
                    ),
            ),
          ),
          SizedBox(height: kDefaultPadding),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(overview),
          ),
        ],
      ),
    );
  }
}
