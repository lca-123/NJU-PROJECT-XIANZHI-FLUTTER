import 'package:flutter/material.dart';
import 'package:sqljocky5/connection/connection.dart';
import 'package:xianzhi/movie/change.dart';
import 'package:xianzhi/movie/deal.dart';

import './detail.dart';
import './login.dart';

class GoodList extends StatefulWidget {
  GoodList(
      {Key key,
      @required this.keyword,
      @required this.id,
      @required this.stateOfGood})
      : super(key: key);
  final String keyword;
  final String id;
  final int stateOfGood;
  @override
  _GoodListState createState() {
    return _GoodListState();
  }
}

MySqlConnection connt3;

List<String> SQL = [];

class _GoodListState extends State<GoodList>
    with AutomaticKeepAliveClientMixin {
  int pagesize = 5;

  //商品列表
  var glist = [];

  List statedeal = ['已下单', '已付款', '已发货', '已收货', '待评论', '已完成'];
  List stateGood = ['未上架', '已上架', '已卖出', '已下架'];

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

    setState(() {
      SQL = [
        'select `商品ID`,`发布信息`,`种类`,`点赞数`,`价格` from `商品` where `状态` = 1 and `发布信息` like \'%${widget.keyword}%\'', //搜索
        'select `商品ID`,`发布信息`,`种类`,`点赞数`,`价格`,`运费`,`状态` from `商品` where `卖家ID`=\'${widget.id}\' order by `状态`', //我发布的
        'select `商品`.`商品ID`,`发布信息`,`种类`,`订单状态`,`总价格` from `商品`,`订单` where `买家ID`=\'${widget.id}\' and `订单`.`商品ID`=`商品`.`商品ID`', //我买到的
        'select `商品`.`商品ID`,`发布信息`,`种类`,`订单状态`,`总价格` from `商品`,`订单` where `状态` = 2 and `订单`.`卖家ID`=\'${widget.id}\' and `订单`.`商品ID`=`商品`.`商品ID`' //我卖出的
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    //获取屏幕宽度
    final size = MediaQuery.of(context).size;
    return RefreshIndicator(
        child: ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 10),
          physics: AlwaysScrollableScrollPhysics(),
          itemBuilder: (BuildContext ctx, int i) {
            //每次循环都拿到当前的电影item项
            return Wrap(
              alignment: WrapAlignment.spaceAround,
              children: List.generate(glist.length, (ix) {
                var gitem = glist[ix];

                return GestureDetector(
                  onLongPress: () {
                    if (widget.stateOfGood == 1 && gitem[6] <= 1) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext ctx) {
                        return ChangePage(
                          userid: widget.id,
                          goodid: gitem[0],
                        );
                      }));
                    }
                  },
                  onTap: () {
                    if (widget.stateOfGood <= 1) {
                      browse(gitem[0]);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext ctx) {
                        return GoodDetail(
                          id: gitem[0].toString(),
                          userid: widget.id,
                        );
                      }));
                    } else {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext ctx) {
                        return DealPage(
                          goodid: gitem[0].toString(),
                          userid: widget.id,
                          stateOfGood: widget.stateOfGood,
                        );
                      }));
                    }
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
                                  widget.stateOfGood < 2
                                      ? Icon(Icons.thumb_up_alt_outlined)
                                      : Icon(Icons.location_searching),
                                  widget.stateOfGood >= 2
                                      ? Text('  ${statedeal[gitem[3]]}')
                                      : widget.stateOfGood == 0
                                          ? Text('  ${gitem[3]}')
                                          : Text(
                                              '  ${gitem[3]}  ${stateGood[gitem[6]]}')
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
    connt3 = await MySqlConnection.connect(s);
    var results = await connt3.execute(SQL[widget.stateOfGood]);
    results.forEach((element) {
      setState(() {
        glist.add(element);
      });
    });
  }

  browse(int id) async {
    connt3 = await MySqlConnection.connect(s);
    await connt3.execute(
        'insert into `浏览记录` values (\'${widget.id}\',$id,\'${DateTime.now()}\')');
  }
}
