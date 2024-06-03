import 'package:chatapp/messaging/conversations.dart';
import 'package:chatapp/messaging/group_create.dart';
import 'package:chatapp/messaging/new_message_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../redux/reducer.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  List<dynamic> facultyList = [];

  void faculty() async {
    List list = [];
    await FirebaseFirestore.instance
        .collection("Faculty_Detail")
        .get()
        .then((value) => {
              value.docs.forEach((element) {
                Map<String, dynamic> data = element.data();
                list.add(data['Email']);
              })
            });
    setState(() {
      facultyList = list;
    });
  }

  @override
  void initState() {
    super.initState();
    faculty();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (_, state) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                title: const TabBar(
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: Color.fromRGBO(238, 78, 52, 1),
                  tabs: [
                    Text(
                      "Chat",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Text(
                      "Groups",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  Stack(
                    children: <Widget>[
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 10,
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                        child: SingleChildScrollView(
                          child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection(
                                      "Messages/${state.email}/Messages")
                                  .orderBy('time', descending: true)
                                  .snapshots(),
                              builder:
                                  (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasData) {
                                  return ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      physics: const ClampingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: snapshot.data?.docs.length,
                                      itemBuilder: (ctx, index) {
                                        QueryDocumentSnapshot x =
                                            snapshot.data!.docs[index];
                                        return ConversationList(
                                          name: x['groupName'],
                                          messageText: x['messageText'],
                                          time: DateFormat('hh:mm a')
                                              .format(x['time'].toDate())
                                              .toString(),
                                          isMessageRead: x['isMessageRead'],
                                          latestMessageBy: "ok",
                                          count: 0,
                                          isGroup: x["isGroup"],
                                          email: x['email'],
                                          imageUrl: x["imgUrl"],
                                          facultyList: facultyList,
                                        );
                                      });
                                } else {
                                  return const SizedBox();
                                }
                              }),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        right: 20,
                        child: FloatingActionButton(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            child: const Icon(Icons.messenger_outline_outlined),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => NewMessage(
                                            facultyList: facultyList,
                                            data: state,
                                          )));
                            }),
                      )
                    ],
                  ),
                  Stack(
                    children: <Widget>[
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 10,
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                        child: SingleChildScrollView(
                          child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("GroupMessages")
                                .snapshots(),
                            builder:
                                (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child:
                                        CircularProgressIndicator()); // Show loading indicator while waiting for data
                              }
                              if (snapshot.hasError) {
                                return Center(
                                    child: Text(
                                        'Error: ${snapshot.error}')); // Show error message if there's an error
                              }
                              if (snapshot.data!.docs.isEmpty) {
                                return Center(
                                    child: Text(
                                        'You have not joined any groups.')); // Show message if no groups found
                              }
                              List<QueryDocumentSnapshot> groupDocs =
                                  snapshot.data!.docs.where((doc) {
                                // Check if logged-in user's email is in the users array of this group document
                                List<dynamic> users = doc.get('users');
                                return users.contains(state.email);
                              }).toList();
                              return ListView.builder(
                                scrollDirection: Axis.vertical,
                                physics: const ClampingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: groupDocs.length,
                                itemBuilder: (ctx, index) {
                                  QueryDocumentSnapshot x = groupDocs[index];
                                  return ConversationList(
                                    facultyList: facultyList,
                                    users: x['users'],
                                    name: x
                                        .id, // Use the document ID as the group name
                                    messageText: x['messageText'],
                                    imageUrl: x['imgUrl'],
                                    time: DateFormat('hh:mm a')
                                        .format(x['time'].toDate())
                                        .toString(),
                                    isMessageRead: x['isMessageRead'],
                                    latestMessageBy: x['latestMessageBy'],
                                    isGroup: x["isGroup"],
                                    count: 0,
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        right: 20,
                        child: FloatingActionButton(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          child: const Icon(Icons.group_add_outlined),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => GroupCreateScreen(
                                  email: state.email,
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  )
                ],
              )),
        );
      },
    );
  }
}
