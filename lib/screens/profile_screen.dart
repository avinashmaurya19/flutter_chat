import 'package:chatting_app/screens/auth/login_screen.dart';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../api/apis.dart';
import '../helper/dialogs.dart';
import '../main.dart';
import '../models/chat_user.dart';

//profile screen -- to show signed in user info

class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Profile  Screen'),
        ),

        //floating action button to add new user

        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton.extended(
            backgroundColor: Colors.redAccent,
            onPressed: () async {
              //for showing progress dialog
              Dialogs.showProgressBar(context);

              //sign out from app
              await Apis.auth.signOut().then((value) async {
                await GoogleSignIn().signOut().then((value) {
                  //for hiding progress dialog
                  Navigator.pop(context);

                  //for moving to home screen
                  Navigator.pop(context);

                  //replacing home screen with login screen
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => LoginScreen()));
                });
              });
            },
            icon: Icon(Icons.logout),
            label: Text('Logout'),
          ),
        ),

        body: Form(
          key: formkey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //for adding some space
                  SizedBox(
                    width: mq.width,
                    height: mq.height * .03,
                  ),

                  //user profile picture
                  Stack(
                    children: [
                      //image from server
                      // ClipRRect(
                      //   //user profile picture
                      //   borderRadius: BorderRadius.circular(mq.height * .3),
                      //   child: CachedNetworkImage(
                      //     width: mq.height * .2,
                      //     height: mq.height * .2,
                      //     imageUrl: widget.user.image,
                      //     errorWidget: (context, url, error) => CircleAvatar(
                      //       child: Icon(CupertinoIcons.person),
                      //     ),
                      //   ),
                      // ),

                      //edit image button
                      // Positioned(
                      //   bottom: 0,
                      //   right: 0,
                      //   child: MaterialButton(
                      //     onPressed: () {},
                      //     shape: CircleBorder(),
                      //     color: Colors.white,
                      //     child: Icon(
                      //       Icons.edit,
                      //       color: Colors.blue,
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                  SizedBox(
                    height: mq.height * .03,
                  ),

                  // user email label
                  Text(widget.user.email),

                  SizedBox(
                    height: mq.height * .03,
                  ),

                  //name input field
                  TextFormField(
                    initialValue: widget.user.name,
                    onSaved: (val) => Apis.me.name = val ?? '',
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : 'Required Field',
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      hintText: 'eg. Happy Singh',
                      label: Text('Name'),
                    ),
                  ),

                  SizedBox(
                    height: mq.height * .03,
                  ),

                  //about info filed
                  TextFormField(
                    initialValue: widget.user.about,
                    onSaved: (val) => Apis.me.about = val ?? '',
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : 'Required Field',
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.info_outline),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      hintText: 'eg. Feeling Happy',
                      label: Text('About'),
                    ),
                  ),
                  SizedBox(
                    height: mq.height * .03,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      minimumSize: Size(mq.width * .5, mq.height * .06),
                    ),
                    onPressed: () {
                      if (formkey.currentState!.validate()) {
                        formkey.currentState!.save();
                        Apis.updateUserInfo().then((value) {
                          Dialogs.showSnackbar(
                              context, 'Profile updated successfully');
                        });
                        // log('inside validator');
                      }
                    },
                    icon: Icon(Icons.edit),
                    label: Text('UPDATE'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
