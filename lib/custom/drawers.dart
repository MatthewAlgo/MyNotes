import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Widget getMainDrawer(BuildContext context, User? user) {
  return Drawer(
    child: Container(
      color: Color.fromARGB(255, 215, 225, 251),
      width: double.infinity,
      height: double.infinity,
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.lightBlue,
            ),
            child: UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.lightBlue),
              accountName: Text(
                user?.displayName ?? '',
                style: const TextStyle(fontSize: 18),
              ),
              accountEmail: Text(user?.email ?? ''),
              currentAccountPictureSize: const Size.square(50),
              currentAccountPicture: CircleAvatar(
                // backgroundColor: const Color.fromARGB(255, 151, 0, 239),
                child: Text(
                  ((user?.displayName?.length != null
                              ? user?.displayName!.length
                              : 0)! >
                          0)
                      ? (user?.displayName?[0] ?? '?')
                      : '?',
                  style: const TextStyle(fontSize: 30.0, color: Colors.blue),
                ), //Text
              ), //circleAvatar
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.home,
            ),
            title: const Text('Home'),
            onTap: () {
              // Close the drawer
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.delete,
            ),
            title: const Text('Trash'),
            onTap: () {
              // We need to push the route
              Navigator.pushNamed(context, '/trash/');
            },
          ),
        ],
      ),
    ),
  );
}
