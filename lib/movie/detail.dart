import 'package:flutter/material.dart';
import 'package:sqljocky5/connection/connection.dart';
import 'package:xianzhi/main.dart';
import 'package:xianzhi/movie/dialogue.dart';

import './login.dart';

class GoodDetail extends StatefulWidget {
  GoodDetail({Key key, @required this.id, @required this.userid})
      : super(key: key);
  final String id;
  final String userid;
  @override
  _GoodDetailState createState() {
    return _GoodDetailState();
  }
}

MySqlConnection connt4;

class _GoodDetailState extends State<GoodDetail> {
  List res = [];
  List fl = [];
  int select;
  List comments = [];
  @override
  void initState() {
    super.initState();
    getDetail();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var r = res[0];
    final TextEditingController _controlleraddress =
        new TextEditingController();
    final TextEditingController _controllernote = new TextEditingController();
    final TextEditingController _controllerwarn = new TextEditingController();
    final TextEditingController _controllerfav = new TextEditingController();
    setState(() {
      _controlleraddress.text = r[8].toString();
    });
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
                padding: EdgeInsets.all(size.width * 0.01),
                child: Text(
                  '￥ ${r[2]}',
                  style: TextStyle(
                      color: Colors.deepOrange[800],
                      fontSize: size.width * 0.07,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                padding: EdgeInsets.all(size.width * 0.03),
                child: Text(
                  '${r[0]}',
                  style: TextStyle(fontSize: size.width * 0.05),
                ),
              ),
              Container(
                height: size.width * 0.7,
                width: size.width * 0.7,
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
                  Expanded(child: SizedBox()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.thumb_up_alt_outlined),
                          Text(' ${r[4]}')
                        ],
                      ),
                      Container(
                        width: size.width * 0.03,
                      ),
                      Row(
                        children: [
                          Icon(Icons.visibility_outlined),
                          Text(' ${r[5]}')
                        ],
                      )
                    ],
                  ),
                  Container(
                    width: size.width * 0.03,
                  )
                ],
              ),
              Divider(
                height: 1.0,
                thickness: 2,
              ),
              Column(
                  children: List.generate(comments.length, (index) {
                var comment = comments[index];
                return Container(
                  child: Column(
                    children: [
                      Container(
                        height: size.width * 0.02,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: size.width * 0.03,
                          ),
                          Column(
                            children: [
                              Icon(
                                Icons.account_circle,
                                size: size.width * 0.07,
                              ),
                              Text(
                                '${comment[0]}',
                                style: TextStyle(fontSize: size.width * 0.04),
                              )
                            ],
                          ),
                          Container(
                            width: size.width * 0.07,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(4),
                                alignment: Alignment.center,
                                height: size.width * 0.065,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                        color: comment[3] >= 3
                                            ? Colors.green[800]
                                            : Colors.yellow[700])),
                                child: Text(
                                  '满意度: ${comment[3]}',
                                  style: TextStyle(
                                      color: comment[3] >= 3
                                          ? Colors.green[800]
                                          : Colors.yellow[700],
                                      fontSize: size.width * 0.025),
                                ),
                              ),
                              Container(
                                width: size.width * 0.65,
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                ),
                                child: Text(comment[2].toString()),
                              ),
                              Text(
                                comment[1].toString().substring(0, 19),
                                style: TextStyle(color: Colors.grey),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                );
              }))
            ],
          )),
          new Divider(
            height: 1.0,
            thickness: 2,
          ),
          Row(
            children: [
              Container(
                width: size.width * 0.53,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                        icon: Icon(Icons.thumb_up_alt_outlined),
                        onPressed: () {
                          connt4.execute(
                              'insert into `点赞记录` values (\'${widget.userid}\',${widget.id},\'${DateTime.now()}\')');
                          showDialog(
                            context: context,
                            child: new AlertDialog(title: new Text('点赞成功')),
                          );
                        }),
                    IconButton(
                        icon: Icon(Icons.star_border_outlined),
                        onPressed: () async {
                          showDialog(
                              context: context,
                              child: SimpleDialog(
                                children: [
                                  Column(
                                    children: [
                                      Text('请选择收藏夹'),
                                      Container(
                                        width: size.width * 0.6,
                                        child: new TextField(
                                          keyboardType: TextInputType.number,
                                          controller: _controllerfav,
                                          decoration: new InputDecoration(
                                            border: InputBorder.none,
                                            hintText: '  收藏夹名',
                                          ),
                                        ),
                                      ),
                                      Container(
                                          height: 30.0 * fl.length,
                                          child: Column(
                                            children: List.generate(fl.length,
                                                (index) {
                                              String name = fl[index][1];
                                              print(name);
                                              return GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _controllerfav.text = name;
                                                    select = index;
                                                  });
                                                },
                                                child: Container(
                                                  width: name.length * 25.0,
                                                  height: 25,
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey[100],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30)),
                                                  alignment: Alignment.center,
                                                  child: Text(name),
                                                ),
                                              );
                                            }),
                                          )),
                                      RaisedButton(
                                        onPressed: () async {
                                          await connt4.execute(
                                              'insert into `收藏细则` values(${fl[select][0]},${widget.id},\'${DateTime.now()}\')');
                                          showDialog(
                                              context: context,
                                              child: SimpleDialog(
                                                children: [
                                                  Text('收藏成功'),
                                                ],
                                              ));
                                        },
                                        child: Text('确认'),
                                      )
                                    ],
                                  )
                                ],
                              ));
                        }),
                    IconButton(
                        icon: Icon(Icons.warning_amber_outlined),
                        onPressed: () {
                          showDialog(
                              context: context,
                              child: SimpleDialog(
                                children: [
                                  Column(
                                    children: [
                                      Text('请输入举报原因'),
                                      new TextField(
                                        controller: _controllerwarn,
                                        decoration: new InputDecoration(
                                          hintText: '  举报原因',
                                        ),
                                      ),
                                      RaisedButton(
                                        onPressed: () async {
                                          await connt4.execute(
                                              'insert into `举报记录` (`买家ID`,`商品ID`,`举报时间`,`举报内容`) values(\'${widget.userid}\',${widget.id},\'${DateTime.now()}\',\'${_controllerwarn.text}\')');
                                          showDialog(
                                              context: context,
                                              child: SimpleDialog(
                                                children: [
                                                  Column(
                                                    children: [
                                                      Text('我们会认真处理您的举报'),
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
                                        child: Text('确认举报'),
                                      )
                                    ],
                                  )
                                ],
                              ));
                        })
                  ],
                ),
              ),
              Container(
                child: Text(''),
                width: size.width * 0.26,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2),
                width: size.width * 0.2,
                child: RaisedButton(
                  color: Colors.pink,
                  onPressed: () {
                    if (widget.userid != r[9].toString() && r[10] == 1) {
                      showDialog(
                        context: context,
                        child: SimpleDialog(children: [
                          Column(
                            children: [
                              Text('确认信息'),
                              Text(''),
                              new Divider(
                                height: 1.0,
                                thickness: 2,
                              ),
                              Text(''),
                              Text('价格:${r[2]}'),
                              Text('运费:${r[3]}'),
                              Text('总价格:${r[2] + r[3]}'),
                              new TextField(
                                controller: _controlleraddress,
                                decoration: new InputDecoration(
                                    hintText: '  收货地址', helperText: '收货地址'),
                              ),
                              new TextField(
                                controller: _controllernote,
                                decoration: new InputDecoration(
                                    hintText: '  备注', helperText: '备注'),
                              ),
                              RaisedButton(
                                onPressed: () {
                                  connt4.execute(
                                      'insert into `订单` (`订单编号`,`商品ID`,`买家ID`,`卖家ID`,`生成时间`,`总价格`,`收货地址`,`备注`) values (\'${DateTime.now().millisecondsSinceEpoch % 1000000000}\',${widget.id},\'${widget.userid}\',\'${r[9]}\',\'${DateTime.now()}\',${r[2] + r[3]},\'${_controlleraddress.text}\',\'${_controllernote.text}\')');
                                  Navigator.pushAndRemoveUntil(context,
                                      MaterialPageRoute(
                                          builder: (BuildContext ctx) {
                                    return MyHomePage2(
                                      id: widget.userid,
                                    );
                                  }), (route) => route == null);
                                },
                                child: Text('确认购买'),
                              )
                            ],
                          ),
                        ]),
                      );
                    }
                  },
                  child: Text(
                    '购买',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  shape: StadiumBorder(),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  getDetail() async {
    connt4 = await MySqlConnection.connect(s);
    var result = await connt4.execute(
        'select `发布信息`,`种类`,`价格`,`运费`,`点赞数`,`浏览数`,A.`用户名`,A.`信用等级`,B.`默认地址`,`卖家ID`,`状态` from `商品`,`用户` as A,`用户`as B where `商品`.`卖家ID`=A.`用户ID` and `商品`.`商品ID`=${widget.id} and B.`用户ID`=${widget.userid}');
    result.forEach((element) {
      setState(() {
        res.add(element);
      });
    });
    var ans = await connt4.execute(
        'select `收藏夹ID`,`收藏夹名` from `收藏夹` where `用户ID`=${widget.userid}');
    ans.forEach((element) {
      setState(() {
        fl.add(element);
      });
    });

    var ans2 = await connt4.execute(
        'select `用户名`,`评论时间`,`评论内容`,`满意度` from `评论细则`,`商品`,`用户` where `商品`.`卖家ID`=`评论细则`.`卖家ID` and `商品ID`=${widget.id} and `用户`.`用户ID`=`评论细则`.`买家ID` order by `评论时间` desc');

    ans2.forEach((element) {
      setState(() {
        comments.add(element);
      });
    });
  }
}
