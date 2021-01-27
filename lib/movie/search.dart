import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sqljocky5/connection/connection.dart';

import 'searchlist.dart';
import './login.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key, @required this.id}) : super(key: key);
  String id;
  @override
  _SearchPageState createState() {
    return _SearchPageState();
  }
}

MySqlConnection connt3;

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controllersearch = new TextEditingController();

  List search = [];

  @override
  void initState() {
    super.initState();
    query2();
    search.forEach((element) {
      print(element);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('搜索'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                  controller: _controllersearch,
                  decoration: InputDecoration(
                      hintText: '   请输入您要搜索的关键字',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                      prefixIcon: Icon(Icons.search))),
            ),
            RaisedButton(
              onPressed: () {
                connt3.execute(
                    'insert into `搜索历史`(`用户ID`,`搜索内容`) values (\'${widget.id}\',\'${_controllersearch.text}\')');
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (BuildContext ctx) {
                  return SearchListPage(
                    id: widget.id,
                    keyword: _controllersearch.text,
                  );
                }), (route) => route == null);
              },
              child: Text('搜索'),
              shape: StadiumBorder(),
            ),
            Container(
              padding: EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
              child: Text(
                '搜索历史：',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
            ),
            Container(
                height: 200,
                padding: EdgeInsets.all(10),
                alignment: Alignment.topLeft,
                child: Wrap(
                  spacing: 2,
                  runSpacing: 5,
                  children: List.generate(search.length, (index) {
                    var item = search[index];
                    return Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(30)),
                      height: 50,
                      width: max(10.0 * item.length, 50),
                      alignment: Alignment.center,
                      child: Text(
                        item,
                      ),
                    );
                  }),
                ))
          ],
        ));
  }

  query2() async {
    connt3 = await MySqlConnection.connect(s);
    var results = await connt3
        .execute('select `搜索内容` from `搜索历史` where `用户ID`=${widget.id}');
    setState(() {
      results.forEach((element) {
        search.add(element[0]);
      });
    });
  }
}
