import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  const Message({
    super.key,
    required this.messageType,
    required this.text,
    required this.isCurrentUser,
    required this.name,
    required this.time,
  });
  final String text;
  final bool isCurrentUser;
  final String name;
  final String messageType;
  final dynamic time;

  @override
  Widget build(BuildContext context) {
    if ((messageType == 'groupMessage' || messageType == 'userMessage')) {
      return Container(
        // asymmetric padding
        padding: EdgeInsets.fromLTRB(
          isCurrentUser ? 64.0 : 16.0,
          4,
          isCurrentUser ? 16.0 : 64.0,
          4,
        ),
        child: Align(
          alignment:
              isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IntrinsicWidth(
                child: DecoratedBox(
                  // chat bubble decoration
                  decoration: BoxDecoration(
                    color:
                        isCurrentUser ? Colors.indigo[300] : Colors.grey[300],
                    borderRadius: BorderRadius.only(
                      topLeft: isCurrentUser
                          ? const Radius.circular(20)
                          : Radius.zero,
                      topRight: isCurrentUser
                          ? Radius.zero
                          : const Radius.circular(20),
                      bottomRight: const Radius.circular(20),
                      bottomLeft: const Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isCurrentUser)
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        Text(
                          text,
                          style: TextStyle(
                              color:
                                  isCurrentUser ? Colors.white : Colors.black87,
                              fontSize: 16),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            margin: const EdgeInsets.only(top: 3, left: 10),
                            child: Text(
                              time,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontSize: 9,
                                color:
                                    isCurrentUser ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else if (messageType == "left") {
      if (text.isNotEmpty) {
        return Padding(
          padding: const EdgeInsetsDirectional.only(top: 10, bottom: 10),
          child: Text(
            "$text removed $name",
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsetsDirectional.only(top: 10, bottom: 10),
          child: Text(
            "$name Left",
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
        );
      }
    } else if (messageType == "joined") {
      return Padding(
        padding: const EdgeInsetsDirectional.only(top: 10, bottom: 10),
        child: Text(
          "$text added $name",
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.green),
        ),
      );
    } else {
      if (messageType == "adminAdded") {
        return Padding(
          padding: const EdgeInsetsDirectional.only(top: 10, bottom: 10),
          child: Text(
            "$text is now admin by $name",
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.green),
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsetsDirectional.only(top: 10, bottom: 10),
          child: Text(
            "$text is removed from admin by $name",
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
        );
      }
    }
  }
}
