import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/messaging/read_message_fetch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../redux/reducer.dart';
import '../redux/store.dart';
import 'message_screen.dart';

class ConversationList extends HookWidget {
  final String name;
  final String messageText;
  final dynamic imageUrl;
  final String time;
  final bool isMessageRead;
  final String latestMessageBy;
  final int count;
  final dynamic isGroup;
  final dynamic email;
  final dynamic users;
  final dynamic facultyList;

  const ConversationList(
      {super.key,
      this.email,
      this.users,
      required this.name,
      required this.isGroup,
      required this.messageText,
      required this.imageUrl,
      required this.time,
      required this.isMessageRead,
      required this.facultyList,
      required this.latestMessageBy,
      required this.count});

  @override
  Widget build(BuildContext context) {
    var countState = useState(count);

    if (isGroup) {
      getMessageReads(store.state, name, isGroup)
          .then((value) => {countState.value = value});
    } else {
      getMessageReads(store.state, email, false)
          .then((value) => {countState.value = value});
    }
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (_, data) {
          return InkWell(
            onTap: () {
              countState.value = 0;
              if (isGroup) {
                FirebaseFirestore.instance
                    .collection("GroupMessages")
                    .doc(name)
                    .update({"isMessageRead": true});
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => MessageScreen(
                              facultyList: facultyList,
                              users: users,
                              groupName: name,
                              imageUrl: imageUrl,
                              isGroup: isGroup,
                              data: data,
                            )));
              } else {
                FirebaseFirestore.instance
                    .collection("Messages/${data.email}/Messages")
                    .doc(email)
                    .update({"isMessageRead": true});
                FirebaseFirestore.instance
                    .collection("Messages/$email/Messages")
                    .doc(data.email)
                    .update({"isMessageRead": true});
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => MessageScreen(
                              groupName: name,
                              imageUrl: imageUrl,
                              isGroup: false,
                              email: email,
                              data: data,
                            )));
              }
            },
            child: IgnorePointer(
              child: Container(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 10, bottom: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          CachedNetworkImage(
                            imageUrl: imageUrl,
                            imageBuilder: (context, imageProvider) {
                              return CircleAvatar(
                                backgroundImage: imageProvider,
                                maxRadius: 30,
                              );
                            },
                            placeholder: (context, url) => const CircleAvatar(
                              backgroundImage:
                                  AssetImage("assets/images/Profile.png"),
                              maxRadius: 30,
                            ),
                            errorWidget: (context, url, error) =>
                                const CircleAvatar(
                              backgroundImage:
                                  AssetImage("assets/images/Profile.png"),
                              maxRadius: 30,
                            ),
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: Container(
                              color: Colors.transparent,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    name.toString(),
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  Row(
                                    children: [
                                      isGroup
                                          ? Text(
                                              "$latestMessageBy : ",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey.shade600,
                                                  fontWeight: isMessageRead
                                                      ? FontWeight.bold
                                                      : FontWeight.normal),
                                            )
                                          : const SizedBox(),
                                      messageText.length >= 10
                                          ? Text(
                                              "${messageText.substring(0, 10)}...",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.grey.shade600,
                                                  fontWeight: !isMessageRead
                                                      ? FontWeight.bold
                                                      : FontWeight.normal),
                                            )
                                          : Text(
                                              messageText,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.grey.shade600,
                                                  fontWeight: !isMessageRead
                                                      ? FontWeight.bold
                                                      : FontWeight.normal),
                                            ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 3, bottom: 10),
                          child: Text(
                            time,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: !isMessageRead
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                          ),
                        ),
                        countState.value == 0
                            ? const SizedBox()
                            : Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                    color: Colors.green[400],
                                    shape: BoxShape.circle),
                                child: Text(countState.value.toString(),
                                    textAlign: TextAlign.center,
                                    style:
                                        const TextStyle(color: Colors.white)),
                              ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
