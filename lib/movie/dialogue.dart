import 'package:flutter/material.dart';
import 'package:sqljocky5/connection/connection.dart';
import 'package:xianzhi/movie/message.dart';

import './login.dart';

class DialoguePage extends StatefulWidget {
  DialoguePage(
      {Key key, @required this.sid, @required this.eid, @required this.name})
      : super(key: key);
  final String sid;
  final String eid;
  final String name;
  @override
  _DialoguePage createState() {
    return _DialoguePage();
  }
}

MySqlConnection connt7;

class _DialoguePage extends State<DialoguePage> {
  final TextEditingController _controllerdialogue = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    String text = '';
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.name),
          centerTitle: true,
        ),
        body: new Column(children: <Widget>[
          new Flexible(
            child: MessagePage(
              sid: widget.sid,
              eid: widget.eid,
            ),
          ),
          new Divider(
            height: 1.0,
            thickness: 2,
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.01, vertical: size.width * 0.02),
                width: size.width * 0.8,
                child: TextField(
                  onSubmitted: (val) {
                    setState(() {
                      text = val;
                      send(text);

                      _controllerdialogue.text = '';
                    });
                  },
                  controller: _controllerdialogue,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10, horizontal: size.width * 0.05),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)))),
                ),
              ),
              Container(
                padding: EdgeInsets.all(size.width * 0.01),
                child: RaisedButton(
                  onPressed: () {
                    setState(() {
                      text = _controllerdialogue.text;
                      send(text);

                      _controllerdialogue.text = '';
                    });
                  },
                  child: Text('发送'),
                  shape: StadiumBorder(),
                ),
                width: size.width * 0.2,
              )
            ],
          )
        ]));
  }

  send(String text) async {
    connt7 = await MySqlConnection.connect(s);
    await connt7.execute(
        'insert into `聊天记录` values (\'${widget.sid}\',\'${widget.eid}\',\'${DateTime.now()}\',\'$text\')');
  }
}
