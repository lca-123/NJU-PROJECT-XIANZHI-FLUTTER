import 'package:flutter/material.dart';
import 'package:sqljocky5/connection/connection.dart';
import 'package:xianzhi/main.dart';
import 'package:xianzhi/movie/dialogue.dart';

import './login.dart';

class DealPage extends StatefulWidget {
  DealPage(
      {Key key,
      @required this.goodid,
      @required this.userid,
      @required this.stateOfGood})
      : super(key: key);
  final String goodid;
  final String userid;
  final int stateOfGood;
  @override
  _DealPageState createState() {
    return _DealPageState();
  }
}

MySqlConnection connt4;

class _DealPageState extends State<DealPage> {
  List res = [];
  List fl = [];
  int select;
  List deals = [];
  List SQL = [];

  List statedeal = ['已下单', '已付款', '已发货', '已收货', '待评论', '已完成'];
  @override
  void initState() {
    super.initState();
    getDetail();

    setState(() {
      SQL = [
        '',
        '',
        'select `发布信息`,`种类`,`价格`,`运费`,`点赞数`,`浏览数`,A.`用户名`,A.`信用等级`,A.`默认地址`,`商品`.`卖家ID`,`状态`,`订单ID`,`订单状态`,`收货地址`,B.`电话号码`,B.`用户名` from `商品`,`用户` as A,`订单`,`用户` as B where `商品`.`卖家ID`=A.`用户ID` and `商品`.`商品ID`=${widget.goodid} and `商品`.`商品ID` = `订单`.`商品ID` and `订单`.`买家ID`=B.`用户ID`',
        'select `发布信息`,`种类`,`价格`,`运费`,`点赞数`,`浏览数`,`用户名`,`信用等级`,`默认地址`,`订单`.`买家ID`,`状态`,`订单ID`,`订单状态`,`收货地址`,`电话号码` from `商品`,`用户`,`订单` where `订单`.`买家ID`=`用户`.`用户ID` and `商品`.`商品ID`=${widget.goodid} and `商品`.`商品ID` = `订单`.`商品ID`'
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var r = res[0];
    final TextEditingController _controllercomment =
        new TextEditingController();
    final TextEditingController _controllersatisfy =
        new TextEditingController();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
      ),
      body: Column(
        children: [
          Flexible(
              child: ListView(
            children: [
              Container(
                alignment: Alignment.center,
                height: size.width * 0.13,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (widget.userid != r[9].toString()) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (BuildContext ctx) {
                            return DialoguePage(
                              eid: r[9],
                              name: r[6],
                              sid: widget.userid,
                            );
                          }));
                        }
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.account_circle_outlined,
                            size: size.width * 0.1,
                          ),
                          Text('   '),
                          Text(
                            '${r[6]}',
                            style: TextStyle(fontSize: size.width * 0.07),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: size.width * 0.07,
                    ),
                    Container(
                      padding: EdgeInsets.all(6),
                      alignment: Alignment.center,
                      height: size.width * 0.08,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.blue[900])),
                      child: Text(
                        '信用等级: ${r[7]}',
                        style: TextStyle(
                            color: Colors.blue[700],
                            fontSize: size.width * 0.028),
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                height: 1.0,
                thickness: 2,
              ),
              Container(
                height: size.width * 0.02,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    Container(
                      width: size.width * 0.03,
                    ),
                    Container(
                      height: size.width * 0.3,
                      width: size.width * 0.3,
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(size.width * 0.1),
                        child: Text('商品照片'),
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(45)),
                      ),
                    ),
                    Container(
                      width: size.width * 0.65,
                      height: size.width * 0.3,
                      alignment: Alignment.topLeft,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(20)),
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.05,
                          vertical: size.width * 0.01),
                      child: Text(
                        '${r[0]}',
                        style: TextStyle(fontSize: size.width * 0.05),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  height: size.width * 0.23,
                  padding: EdgeInsets.only(
                      left: size.width * 0.05,
                      right: size.width * 0.05,
                      top: size.width * 0.033,
                      bottom: size.width * 0.005),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text('商品价格'),
                          Expanded(child: SizedBox()),
                          Text(
                            '￥${r[2]}',
                            style: TextStyle(color: Colors.grey[700]),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text('运费'),
                          Expanded(child: SizedBox()),
                          Text('￥${r[3]}',
                              style: TextStyle(color: Colors.grey[700]))
                        ],
                      ),
                      Expanded(child: SizedBox()),
                      Row(
                        children: [
                          Text(
                            '总价格',
                            style: TextStyle(
                                fontSize: size.width * 0.045,
                                fontWeight: FontWeight.w700),
                          ),
                          Expanded(child: SizedBox()),
                          Text(
                            '￥${r[2] + r[3]}',
                            style: TextStyle(
                                fontSize: size.width * 0.045,
                                color: Colors.deepOrange[800],
                                fontWeight: FontWeight.w700),
                          )
                        ],
                      )
                    ],
                  )),
              Container(
                height: size.width * 0.02,
              ),
              Row(
                children: [
                  Container(width: size.width * 0.03),
                  Container(
                      padding: EdgeInsets.all(5),
                      height: size.width * 0.1,
                      alignment: Alignment.center,
                      child: Text('${r[1]}'),
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(15))),
                ],
              ),
              Divider(
                height: 1.0,
                thickness: 2,
              ),
              Container(
                height: size.width * 0.15,
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '收货地址:  ${widget.stateOfGood == 3 ? r[6] : r[15]} ${r[14].toString()}',
                      style: TextStyle(
                          fontSize: size.width * 0.043,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      r[13].toString(),
                      style: TextStyle(
                          fontSize: size.width * 0.03, color: Colors.grey[700]),
                    )
                  ],
                ),
              ),
              Divider(
                height: 1.0,
                thickness: 2,
              ),
              Container(
                child: Column(
                  children: List.generate(deals.length, (index) {
                    var deal = deals[index];
                    String time = deal[0].toString().substring(0, 19);
                    int state = int.parse(deal[1]);

                    return Container(
                      width: (time.length + statedeal[state].length) * 25.0,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(30)),
                      alignment: Alignment.center,
                      child: Text('$time     ${statedeal[state]}'),
                    );
                  }),
                ),
              ),
              Divider(
                height: 1.0,
                thickness: 2,
              ),
              widget.stateOfGood == 2
                  ? RaisedButton(
                      onPressed: () async {
                        if (r[12] == 4) {
                          showDialog(
                              context: context,
                              child: SimpleDialog(
                                children: [
                                  Column(
                                    children: [
                                      Text('评论'),
                                      new TextField(
                                        style: TextStyle(fontSize: 13),
                                        maxLines: 4,
                                        controller: _controllercomment,
                                        decoration: new InputDecoration(
                                            hintText: '   评论内容',
                                            border: OutlineInputBorder()),
                                      ),
                                      new TextField(
                                        controller: _controllersatisfy,
                                        decoration: new InputDecoration(
                                            border: InputBorder.none,
                                            hintText: '  满意度',
                                            prefixIcon:
                                                Icon(Icons.category_rounded)),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            border: Border.all(
                                                color: Colors.black12)),
                                        height: 50,
                                        child: Wrap(
                                          spacing: 2,
                                          runSpacing: 5,
                                          children: List.generate(5, (index) {
                                            String type =
                                                (index + 1).toString();
                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _controllersatisfy.text =
                                                      type;
                                                });
                                              },
                                              child: Container(
                                                width: type.length * 25.0,
                                                height: 25,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[100],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30)),
                                                alignment: Alignment.center,
                                                child: Text(type),
                                              ),
                                            );
                                          }),
                                        ),
                                      ),
                                      RaisedButton(
                                        onPressed: () async {
                                          await connt4.execute(
                                              'insert into `评论细则`  (`买家ID`,`卖家ID`,`评论时间`,`评论内容`,`满意度`,`评论状态`) values ( \'${widget.userid}\',\'${r[9]}\',\'${DateTime.now()}\',\'${_controllercomment.text}\',${_controllersatisfy.text},1)');
                                          await connt4.execute(
                                              'insert into `订单细则` (`订单ID`,`修改时间`,`订单状态`) values (${r[11]},\'${DateTime.now()}\',${r[12] + 1})');
                                          showDialog(
                                              context: context,
                                              child: SimpleDialog(
                                                children: [
                                                  Column(
                                                    children: [
                                                      Text('评论成功'),
                                                      RaisedButton(
                                                        onPressed: () {
                                                          Navigator.pushAndRemoveUntil(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (BuildContext
                                                                          ctx) {
                                                            return MyHomePage2(
                                                              id: widget.userid,
                                                            );
                                                          }),
                                                              (route) =>
                                                                  route ==
                                                                  null);
                                                        },
                                                        child: Text('确认'),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ));
                                        },
                                        child: Text('确认'),
                                      )
                                    ],
                                  )
                                ],
                              ));
                        } else if (r[12] == 2) {
                          await connt4.execute(
                              'insert into `订单细则` (`订单ID`,`修改时间`,`订单状态`) values (${r[11]},\'${DateTime.now()}\',${r[12] + 1})');
                          showDialog(
                              context: context,
                              child: SimpleDialog(
                                children: [
                                  Column(
                                    children: [
                                      Text('更新成功'),
                                      RaisedButton(
                                        onPressed: () {
                                          Navigator.pushAndRemoveUntil(context,
                                              MaterialPageRoute(
                                                  builder: (BuildContext ctx) {
                                            return MyHomePage2(
                                              id: widget.userid,
                                            );
                                          }), (route) => route == null);
                                        },
                                        child: Text('确认'),
                                      )
                                    ],
                                  )
                                ],
                              ));
                        }
                      },
                      child: r[12] == 4 ? Text('评论') : Text('更新状态'),
                    )
                  : RaisedButton(
                      onPressed: () async {
                        if (r[12] == 0 || r[12] == 1 || r[12] == 3) {
                          await connt4.execute(
                              'insert into `订单细则` (`订单ID`,`修改时间`,`订单状态`) values (${r[11]},\'${DateTime.now()}\',${r[12] + 1})');
                          showDialog(
                              context: context,
                              child: SimpleDialog(
                                children: [
                                  Column(
                                    children: [
                                      Text('更新成功'),
                                      RaisedButton(
                                        onPressed: () {
                                          Navigator.pushAndRemoveUntil(context,
                                              MaterialPageRoute(
                                                  builder: (BuildContext ctx) {
                                            return MyHomePage2(
                                              id: widget.userid,
                                            );
                                          }), (route) => route == null);
                                        },
                                        child: Text('确认'),
                                      )
                                    ],
                                  )
                                ],
                              ));
                        }
                      },
                      child: Text('更新状态'),
                    )
            ],
          )),
        ],
      ),
    );
  }

  getDetail() async {
    connt4 = await MySqlConnection.connect(s);
    var result = await connt4.execute(SQL[widget.stateOfGood]);
    result.forEach((element) {
      setState(() {
        res.add(element);
      });
    });
    var result2 = await connt4.execute(
        'select `修改时间`,`订单细则`.`订单状态` from `订单细则`,`订单` where `订单细则`.`订单ID`=`订单`.`订单ID` and `商品ID`=${widget.goodid}');

    result2.forEach((element) {
      setState(() {
        deals.add(element);
      });
    });
  }
}
