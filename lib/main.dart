import 'package:flutter/material.dart';
import 'package:sqljocky5/connection/connection.dart';

import './movie/list.dart';
import './movie/login.dart';
import './movie/publish.dart';
import './movie/goods.dart';
import './movie/chat.dart';
import './movie/search.dart';
import './movie/favorite.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '二手交易',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage2 extends StatefulWidget {
  MyHomePage2({Key key, this.username, @required this.id}) : super(key: key);
  final String username;
  final String id;

  @override
  _MyHomePage2State createState() {
    return _MyHomePage2State();
  }
}

Image _image;
MySqlConnection connt1;
String username = '';

class _MyHomePage2State extends State<MyHomePage2> {
  int _selectedIndex = 0;

  query() async {
    connt1 = await MySqlConnection.connect(s);
    var results2 =
        await connt1.execute("select 用户名 from 用户 where 用户ID=\'${widget.id}\'");
    results2.forEach((element) {
      setState(() {
        username = element[0];
      });
    });
  }

  Widget bodypage;
  @override
  void initState() {
    super.initState();
    setState(() {
      bodypage = GoodList(
        stateOfGood: 0,
        keyword: '',
        id: widget.id,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    query();
    return Scaffold(
      //头部导航栏
      appBar: AppBar(
        title: Text('二手交易'),
        centerTitle: true,
        //右侧行为按钮
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext ctx) {
                  return SearchPage(
                    id: widget.id,
                  );
                }));
              })
        ],
      ),

      //侧边栏
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.all(0),
          children: [
            //用户导航区
            UserAccountsDrawerHeader(
              accountName: Text('用户名：$username'),
              accountEmail: Text('ID：${widget.id}'),
              //用户头像
              currentAccountPicture: Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.grey[200]),
                height: size.width * 0.15,
                width: size.width * 0.15,
                child: Center(
                  child: _image == null ? Text('') : _image,
                ),
              ),
              //背景
              decoration: BoxDecoration(color: Colors.blue),
            ),

            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext ctx) {
                  return MyGoodsPage(
                    id: widget.id,
                    stateOfGood: 1,
                  );
                }));
              },
              child: ListTile(
                title: Text('我发布的'),
                trailing: Icon(Icons.local_mall),
              ),
            ),

            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext ctx) {
                  return MyGoodsPage(
                    id: widget.id,
                    stateOfGood: 2,
                  );
                }));
              },
              child: ListTile(
                title: Text('我买到的'),
                trailing: Icon(Icons.card_giftcard),
              ),
            ),

            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext ctx) {
                  return MyGoodsPage(
                    id: widget.id,
                    stateOfGood: 3,
                  );
                }));
              },
              child: ListTile(
                title: Text('我卖出的'),
                trailing: Icon(Icons.monetization_on),
              ),
            ),

            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext ctx) {
                  return FavoritePage(
                    id: widget.id,
                  );
                }));
              },
              child: ListTile(
                title: Text('我收藏的'),
                trailing: Icon(Icons.star),
              ),
            ),
            Divider(),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext ctx) {
                  return MyHomePage();
                }));
              },
              child: ListTile(
                title: Text('注销'),
                trailing: Icon(Icons.exit_to_app),
              ),
            )
          ],
        ),
      ),

      //底部栏
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: CircularNotchedRectangle(),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          IconButton(
              icon: Icon(Icons.home),
              color: _selectedIndex == 0 ? Colors.red : Colors.grey,
              onPressed: () {
                setState(() {
                  _selectedIndex = 0;
                  bodypage = GoodList(
                    stateOfGood: 0,
                    keyword: '',
                    id: widget.id,
                  );
                });
              }),
          SizedBox(
            width: 50,
          ),
          IconButton(
              icon: Icon(Icons.chat),
              color: _selectedIndex == 2 ? Colors.red : Colors.grey,
              onPressed: () {
                setState(() {
                  _selectedIndex = 2;
                  bodypage = MyChatPage(id: widget.id);
                });
              })
        ]),
      ),

      body: bodypage,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red[400],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(Icons.add)],
        ),
        onPressed: () {
          print(widget.id);
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext ctx) {
            return PublishPage(
              id: widget.id,
            );
          }));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _image = null;
    username = '';
  }
}
