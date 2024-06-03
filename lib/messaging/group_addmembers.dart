import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddToGroup extends StatefulWidget {
  const AddToGroup(
      {super.key,
      required this.data,
      required this.users,
      required this.groupName});
  final dynamic data;
  final List users;
  final String groupName;

  @override
  State<AddToGroup> createState() => _AddToGroupState();
}

class _AddToGroupState extends State<AddToGroup> {
  Future<List> Members() async {
    List<dynamic> list = [];
    DocumentSnapshot value = await FirebaseFirestore.instance
        .doc("GroupMessages/${widget.groupName}")
        .get();
    Map<String, dynamic> temp = value.data() as Map<String, dynamic>;

    QuerySnapshot<Map<String, dynamic>> ans = await FirebaseFirestore.instance
        .collection("Faculty_Detail")
        .where("Email", whereNotIn: temp['users'])
        .orderBy("Email")
        .get();

    for (var element in ans.docs) {
      list.add(element.data());
    }

    ans = await FirebaseFirestore.instance
        .collection("Student_Detail")
        .where("Email", whereNotIn: temp['users'])
        .orderBy("Email")
        .get();
    for (var element in ans.docs) {
      list.add(element.data());
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Add"),
        backgroundColor: Colors.indigo[300],
      ),
      body: FutureBuilder(
        future: Members(),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, i) {
                  Map<String, dynamic> x = snapshot.data![i];
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(children: <Widget>[
                      CachedNetworkImage(
                        imageUrl: x['imgUrl'],
                        imageBuilder: (context, imageProvider) {
                          return CircleAvatar(
                            backgroundImage: imageProvider,
                            maxRadius: 30,
                          );
                        },
                        placeholder: (context, url) => const CircleAvatar(
                          backgroundImage:
                              AssetImage("assets/images/profile.gif"),
                          maxRadius: 30,
                        ),
                        errorWidget: (context, url, error) =>
                            const CircleAvatar(
                          backgroundImage:
                              AssetImage("assets/images/profile.gif"),
                          maxRadius: 30,
                        ),
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          color: Colors.transparent,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "${x['Name']['First'].toString()} ${x["Name"]['Last'].toString()}",
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "${x["Year"] ?? ""} ${x["Branch"]}",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection("GroupMessages")
                                .doc(widget.groupName)
                                .update({
                              "users": FieldValue.arrayUnion([x['Email']]),
                            });
                            FirebaseFirestore.instance
                                .collection(
                                    "GroupMessages/${widget.groupName}/Messages")
                                .add(
                              {
                                "messageType": "joined",
                                "email": widget.data.email,
                                "name": x['Name']['First'].toString(),
                                "time": Timestamp.now(),
                                "users":
                                    FieldValue.arrayUnion([widget.data.email]),
                                "message": widget.data.name['First']
                              },
                            );
                            setState(() {
                              widget.users.add(x['Email']);
                            });
                          },
                          icon: const Icon(Icons.add))
                    ]),
                  );
                });
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
