import 'package:chatting_app/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../api/apis.dart';
import '../main.dart';
import '../models/chat_user.dart';
import '../widgets/chat_user_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //for storing all users
  List<ChatUser> _list = [];

  // for storing searched items
  final List<ChatUser> _searchList = [];

  // for storing search status
  bool _isSearchilng = false;

  void initState() {
    super.initState();
    Apis.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //for hiding keybord when a tap is detected on screen
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        //if search in on & back button is pressed then close search
        //or else simple close current screen on back button click
        onWillPop: () {
          if (_isSearchilng) {
            setState(() {
              _isSearchilng = !_isSearchilng;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            leading: Icon(CupertinoIcons.home),
            title: _isSearchilng
                ? TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: 'Name , Email'),
                    autofocus: true,

                    //when search text changes then updated search list
                    onChanged: (val) {
                      //search logic
                      _searchList.clear();

                      for (var i in _list) {
                        if (i.name.toLowerCase().contains(val.toLowerCase()) ||
                            i.email.toLowerCase().contains(val.toLowerCase())) {
                          _searchList.add(i);
                        }
                      }
                      setState(() {
                        _searchList;
                      });
                    },
                  )
                : Text('We Chat'),
            actions: [
              // search user button
              IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearchilng = !_isSearchilng;
                    });
                  },
                  icon: Icon(_isSearchilng
                      ? CupertinoIcons.clear_circled_solid
                      : Icons.search)),

              //more features button
              IconButton(
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ProfileScreen(
                                  user: Apis.me,
                                )));
                  },
                  icon: Icon(Icons.more_vert)),
            ],
          ),

          //floating action button to add new user

          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FloatingActionButton(
              onPressed: () async {
                await Apis.auth.signOut();
                await GoogleSignIn().signOut();
              },
              child: Icon(Icons.add_comment_rounded),
            ),
          ),

          body: StreamBuilder(
            stream: Apis.getAllUsers(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                // if data is loading

                case ConnectionState.waiting:
                case ConnectionState.none:
                  return CircularProgressIndicator();

                //if some or all data is loaded then show it
                case ConnectionState.active:
                case ConnectionState.done:
                  final data = snapshot.data?.docs;
                  _list =
                      data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                          [];
                  if (_list.isNotEmpty) {
                    return ListView.builder(
                      itemCount:
                          _isSearchilng ? _searchList.length : _list.length,
                      padding: EdgeInsets.only(top: mq.height * .01),
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ChatUserCard(
                            user: _isSearchilng
                                ? _searchList[index]
                                : _list[index]);
                      },
                    );
                  } else {
                    return Center(child: Text('No Connections Found'));
                  }
              }
            },
          ),
        ),
      ),
    );
  }
}
