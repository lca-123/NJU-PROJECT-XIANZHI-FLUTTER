import 'package:flutter/material.dart';
import 'package:xianzhi/movie/goods.dart';
import 'package:sqljocky5/connection/connection.dart';

import './login.dart';
import '../main.dart';

class FavoritePage extends StatefulWidget {
  FavoritePage({Key key, @required this.id}) : super(key: key);
  final String id;
  @override
  _FavoritePageState createState() {
    return _FavoritePageState();
  }
}

MySqlConnection connt5;

class _FavoritePageState extends State<FavoritePage> {
  List favorites = [];

  getlist() async {
    connt5 = await MySqlConnection.connect(s);
    var result = await connt5.execute(
        'select `收藏夹ID`,`收藏夹名` from `收藏夹` where `用户ID` = ${widget.id}');
    result.forEach((element) {
      setState(() {
        favorites.add(element);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getlist();
  }

  final TextEditingController _controllerfavorite = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我收藏的'),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                _controllerfavorite.text = '收藏夹${favorites.length + 1}';
                showDialog(
                    context: context,
                    child: SimpleDialog(
                      children: [
                        Column(
                          children: [
                            Text('请输入收藏夹名'),
                            new TextField(
                              keyboardType: TextInputType.number,
                              controller: _controllerfavorite,
                              decoration: new InputDecoration(
                                hintText: '  收藏夹名',
                              ),
                            ),
                            RaisedButton(
                              onPressed: () async {
                                await connt5.execute(
                                    'insert into `收藏夹` (`用户ID`,`收藏夹名`) values (\'${widget.id}\',\'${_controllerfavorite.text}\')');
                                showDialog(
                                    context: context,
                                    child: SimpleDialog(
                                      children: [
                                        Column(children: [
                                          Text('添加成功'),
                                          RaisedButton(
                                              onPressed: () {
                                                Navigator.pushAndRemoveUntil(
                                                    context, MaterialPageRoute(
                                                        builder:
                                                            (BuildContext ctx) {
                                                  return MyHomePage2(
                                                    id: widget.id,
                                                  );
                                                }), (route) => route == null);
                                              },
                                              child: Text('确认')),
                                        ]),
                                      ],
                                    ));
                              },
                              child: Text('确认'),
                            )
                          ],
                        )
                      ],
                    ));
              })
        ],
      ),
      body: RefreshIndicator(
        child: ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int i) {
            var fa = favorites[i];
            return GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext ctx) {
                  return MyGoodsPage(
                    id: widget.id,
                    stateOfGood: 0,
                    favname: fa[1],
                    favid: fa[0],
                  );
                }));
              },
              child: Container(
                height: 75,
                alignment: Alignment.center,
                child: Container(
                  height: 67,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.grey[200]),
                  child: Row(
                    children: [
                      Container(
                        height: 67,
                        width: 67,
                        child: Icon(Icons.pages),
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Text(fa[1]),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
          itemCount: favorites.length,
        ),
        onRefresh: () async {
          FavoritePage(
            id: widget.id,
          );
        },
      ),
    );
  }
}
