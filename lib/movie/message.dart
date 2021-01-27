import 'package:flutter/material.dart';
import 'package:sqljocky5/connection/connection.dart';
import './login.dart';

List messages = [];

class MessagePage extends StatefulWidget {
  MessagePage({Key key, @required this.sid, @required this.eid})
      : super(key: key);
  final String sid;
  final String eid;
  @override
  _MessagePageState createState() {
    return _MessagePageState();
  }
}

class _MessagePageState extends State<MessagePage> {
  @override
  void dispose() {
    super.dispose();
    messages.clear();
  }

  MySqlConnection connt8;

  @override
  void initState() {
    super.initState();
    query();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      displacement: 25,
      onRefresh: () async {
        setState(() {
          messages = [];
        });
        query();
      },
      child: ListView.builder(
        itemBuilder: (BuildContext ctx, int i) {
          var message = messages[messages.length - i - 1];
          return Container(
            height: 65,
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(30)),
              alignment: message[0].toString() == widget.sid
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              padding: EdgeInsets.only(left: 20, right: 20),
              height: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: message[0].toString() == widget.sid
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Text(message[2].toString().substring(0, 19)),
                  Text(message[3])
                ],
              ),
            ),
          );
        },
        itemCount: messages.length,
        reverse: true,
      ),
    );
  }

  query() async {
    connt8 = await MySqlConnection.connect(s);
    var result = await connt8.execute(
        'select `发送者ID`,`接收者ID`,`聊天时间`,`聊天内容` from `聊天记录` where `发送者ID` in (\'${widget.sid}\',\'${widget.eid}\') and `接收者ID` in (\'${widget.sid}\',\'${widget.eid}\') order by `聊天时间`');

    result.forEach((element) {
      setState(() {
        messages.add(element);
      });
    });
  }
}
