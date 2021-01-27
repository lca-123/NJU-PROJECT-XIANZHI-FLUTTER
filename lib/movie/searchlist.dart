import 'package:flutter/material.dart';
import './list.dart';
import '../main.dart';

class SearchListPage extends StatefulWidget {
  SearchListPage({Key key, this.keyword, this.id}) : super(key: key);
  String keyword;
  String id;
  @override
  _SearchListPage createState() {
    return _SearchListPage();
  }
}

class _SearchListPage extends State<SearchListPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      child: Scaffold(
        appBar: AppBar(
          title: Text('搜索结果:${widget.keyword}'),
        ),
        bottomNavigationBar: Container(
          //美化container盒子
          decoration: BoxDecoration(color: Colors.black),
          //一般高度为50
          height: 0,
          child: TabBar(
            labelStyle: TextStyle(height: 0, fontSize: 10),
            tabs: [
              Tab(icon: Icon(Icons.movie_filter), text: '正在热映'),
            ],
          ),
        ),
        body: TabBarView(children: [
          GoodList(
            stateOfGood: 0,
            keyword: widget.keyword,
            id: widget.id,
          ),
        ]),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red[400],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(Icons.keyboard_return)],
          ),
          onPressed: () {
            print(widget.id);
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (BuildContext ctx) {
              return MyHomePage2(
                id: widget.id,
              );
            }), (route) => route == null);
          },
        ),
      ),
      length: 1,
    );
  }
}
