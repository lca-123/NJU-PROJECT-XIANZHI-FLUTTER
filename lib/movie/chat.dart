import 'package:flutter/material.dart';
import 'package:sqljocky5/connection/connection.dart';
import 'package:xianzhi/movie/dialogue.dart';

import './dialogue.dart';
import './login.dart';

class MyChatPage extends StatefulWidget {
  MyChatPage({Key key, @required this.id}) : super(key: key);
  final String id;
  @override
  _MyChatPageState createState() {
    return _MyChatPageState();
  }
}

MySqlConnection connt9;

class _MyChatPageState extends State<MyChatPage> {
  ScrollController _scrollController = ScrollController(); //listview的控制器

  bool isloading = false; //是否正在加载数据

  List chats = [];

  @override
  void initState() {
    super.initState();

    getChat();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print('滑动到了最底部');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        child: ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          itemBuilder: (BuildContext ctx, int i) {
            var chat = chats[i];

            return GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext ctx) {
                  return DialoguePage(
                    sid: widget.id,
                    eid: chat[1],
                    name: chat[0],
                  );
                }));
              },
              child: Container(
                height: 67,
                padding: EdgeInsets.only(left: 15, right: 15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(top: BorderSide(color: Colors.black12))),
                child: Row(
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      child: Icon(
                        Icons.account_circle_outlined,
                        size: 40,
                      ),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20)),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                    ),
                    Container(
                      height: 200,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            '${chat[0]}',
                            style: TextStyle(
                                fontSize: 23, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '${chat[2].toString().substring(0, 19)}',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
          itemCount: chats.length,
          controller: _scrollController,
        ),
        //下拉刷新
        onRefresh: () async {
          setState(() {
            chats = [];
          });

          await getChat();
        });
  }

  getChat() async {
    connt9 = await MySqlConnection.connect(s);
    var result = await connt9.execute(
        'select `用户名`,`用户`.`用户ID`,`最新时间` from `用户`,(select `用户ID`,max(`聊天时间`) as `最新时间` from (select `发送者ID` as `用户ID`,`聊天时间` from `聊天记录` where `接收者ID` = \'${widget.id}\' union select `接收者ID` as `用户ID`,`聊天时间` from `聊天记录` where `发送者ID` = \'${widget.id}\' ) as `聊天` group by `用户ID`) as `聊天2` where `用户`.`用户ID` = `聊天2`.`用户ID` order by `最新时间` desc');
    result.forEach((element) {
      setState(() {
        chats.add(element);
      });
    });
  }
}
