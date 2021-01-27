import 'package:flutter/material.dart';
import 'package:xianzhi/movie/favdetail.dart';
import 'list.dart';

class MyGoodsPage extends StatefulWidget {
  MyGoodsPage(
      {Key key,
      @required this.id,
      @required this.stateOfGood,
      this.favid,
      this.favname})
      : super(key: key);
  final String id;
  final int stateOfGood;
  final int favid;
  final String favname;
  @override
  _MyGoodsPageState createState() {
    return _MyGoodsPageState();
  }
}

class _MyGoodsPageState extends State<MyGoodsPage> {
  List bodypage = [];
  List titles = [];
  @override
  void initState() {
    super.initState();
    setState(() {
      bodypage = [
        FavDetailPage(id: widget.id, favid: widget.favid),
        GoodList(
          stateOfGood: 1,
          id: widget.id,
          keyword: '',
        ),
        GoodList(
          stateOfGood: 2,
          id: widget.id,
          keyword: '',
        ),
        GoodList(
          stateOfGood: 3,
          id: widget.id,
          keyword: '',
        ),
      ];
      titles = [
        widget.favname == null ? '' : widget.favname,
        '我发布的',
        '我买到的',
        '我卖出的'
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[widget.stateOfGood]),
        centerTitle: true,
      ),
      body: bodypage[widget.stateOfGood],
    );
  }
}
