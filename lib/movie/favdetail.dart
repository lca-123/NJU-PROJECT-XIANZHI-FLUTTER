import 'package:flutter/material.dart';
import 'package:sqljocky5/connection/connection.dart';

import './login.dart';
import 'detail.dart';

class FavDetailPage extends StatefulWidget {
  FavDetailPage({Key key, @required this.id, @required this.favid})
      : super(key: key);
  final String id;
  final int favid;
  @override
  _FavDetailPageState createState() {
    return _FavDetailPageState();
  }
}

MySqlConnection connt6;

class _FavDetailPageState extends State<FavDetailPage>
    with AutomaticKeepAliveClientMixin {
  //商品列表
  var glist = [];

  @override
  bool get wantKeepAlive => true;

  ScrollController _scrollController = ScrollController(); //listview的控制器

  bool isloading = false; //是否正在加载数据

  @override
  void initState() {
    super.initState();

    _getGoodsList();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print('滑动到了最底部');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List state = ['未上架', '热卖中', '已卖出', '已下架'];
    //获取屏幕宽度
    final size = MediaQuery.of(context).size;
    return RefreshIndicator(
        child: ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 10),
          physics: AlwaysScrollableScrollPhysics(),
          itemBuilder: (BuildContext ctx, int i) {
            return Wrap(
              alignment: WrapAlignment.spaceAround,
              children: List.generate(glist.length, (ix) {
                var gitem = glist[ix];

                return GestureDetector(
                  onTap: () {
                    browse(gitem[0]);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext ctx) {
                      return GoodDetail(
                        id: gitem[0].toString(),
                        userid: widget.id,
                      );
                    }));
                  },
                  child: Container(
                    height: size.width * 0.6,
                    width: size.width * 0.4,
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: size.width * 0.45,
                          height: size.width * 0.36,
                          child: Text('商品照片'),
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                child: Text(
                                  '${gitem[1]}', //发布信息
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                height: size.width * 0.05,
                              ),
                              Row(children: [
                                Text(
                                  '￥ ${gitem[4]}',
                                  style: TextStyle(
                                      color: Colors.deepOrange,
                                      fontWeight: FontWeight.w600),
                                ), //价格
                                Text('  ${gitem[2]}')
                              ] //种类
                                  ),
                              Row(
                                children: [
                                  Icon(Icons.location_searching),
                                  Text('  ${state[gitem[5]]}')
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
            );
          },
          itemCount: 1,
          controller: _scrollController,
        ),
        //下拉刷新
        onRefresh: () async {
          setState(() {
            glist = [];
          });

          await _getGoodsList();
        });
  }

  _getGoodsList() async {
    connt6 = await MySqlConnection.connect(s);
    var results = await connt6.execute(
        'select `商品ID`,`发布信息`,`种类`,`点赞数`,`价格`,`状态` from `商品` where `商品ID` in (select `商品ID` from `收藏细则` where `收藏夹ID`=${widget.favid})');
    results.forEach((element) {
      setState(() {
        glist.add(element);
      });
    });
  }

  browse(int id) async {
    connt6 = await MySqlConnection.connect(s);
    await connt6.execute(
        'insert into `浏览记录` values (\'${widget.id}\',$id,\'${DateTime.now()}\')');
  }
}
