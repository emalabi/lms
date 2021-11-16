import 'package:flutter/material.dart';
import 'package:lms/authentication/auth.dart';

import 'drawer_menu_widget.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback openDrawer;

  CustomAppBar({
    Key key,
    @required this.openDrawer,
  }) : super(key: key);
  final Auth _auth = Auth();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        DrawerMenuWidget(
          onClicked: openDrawer,
        ),
        Spacer(),
        CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage(
              'http://romanroadtrust.co.uk/wp-content/uploads/2018/01/profile-icon-png-898-300x300.png'),
        ),
      ]),
      actions: [
        PopupMenuButton(
          icon: Icon(
            Icons.more_vert,
            color: Colors.black,
            size: 34,
          ),
          itemBuilder: (context) => [
            PopupMenuItem<int>(
              value: 0,
              child: TextButton.icon(
                onPressed: () async {
                  await _auth.signOut();
                },
                icon: Icon(Icons.logout),
                label: Text('Logout'),
              ),
              onTap: () async {
                await _auth.signOut();
              },
            ),
          ],
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
