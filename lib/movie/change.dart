import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:sqljocky5/connection/connection.dart';
import '../main.dart';
import './login.dart';

class ChangePage extends StatefulWidget {
  ChangePage({Key key, @required this.userid, @required this.goodid})
      : super(key: key);
  String userid;
  int goodid;
  @override
  _ChangePageState createState() {
    return _ChangePageState();
  }
}

File _image;

MySqlConnection connt10;

class _ChangePageState extends State<ChangePage> {
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    //获取屏幕宽度
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('修改商品信息'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(20)),
                height: size.width * 0.5,
                width: size.width * 0.5,
                child: Center(
                  child: Text('商品照片'),
                ),
              ),
              ChangeTextPage(
                userid: widget.userid,
                goodid: widget.goodid,
              ),
              Text('')
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    setState(() {
      _image = null;
    });
  }
}

class ChangeTextPage extends StatefulWidget {
  ChangeTextPage({Key key, @required this.userid, this.goodid})
      : super(key: key);

  final String userid;
  final int goodid;
  @override
  _ChangeTextPageState createState() {
    return _ChangeTextPageState();
  }
}

class _ChangeTextPageState extends State<ChangeTextPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<String> types = [
    '生活用品',
    '电子设备',
    '办公用品',
    '农林物资',
    '食品',
    '服饰',
    '书籍',
    '工艺品',
    '非实体商品',
    '其他'
  ];

  final TextEditingController _controllermessages = new TextEditingController();
  final TextEditingController _controllercost = new TextEditingController();
  final TextEditingController _controllerfreight = new TextEditingController();

  final TextEditingController _controllertype = new TextEditingController();

  @override
  void initState() {
    super.initState();
    query();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Column(
        children: [
          new TextField(
            style: TextStyle(fontSize: 13),
            maxLines: 4,
            controller: _controllermessages,
            decoration: new InputDecoration(
                hintText: '  品牌型号，新旧程度，入手渠道，转手原因...',
                border: OutlineInputBorder()),
          ),
          new TextField(
            keyboardType: TextInputType.number,
            controller: _controllercost,
            decoration: new InputDecoration(
              hintText: '  价格',
              prefixIcon: Icon(Icons.local_atm),
            ),
          ),
          new TextField(
            keyboardType: TextInputType.number,
            controller: _controllerfreight,
            decoration: new InputDecoration(
                hintText: '  运费', prefixIcon: Icon(Icons.local_shipping)),
          ),
          new TextField(
            controller: _controllertype,
            decoration: new InputDecoration(
                border: InputBorder.none,
                hintText: '  种类 请从下面选择',
                prefixIcon: Icon(Icons.category_rounded)),
          ),
          Container(
            padding: EdgeInsets.all(5),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.black12)),
            height: 110,
            child: Wrap(
              spacing: 2,
              runSpacing: 5,
              children: List.generate(types.length, (index) {
                String type = types[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _controllertype.text = type;
                    });
                  },
                  child: Container(
                    width: type.length * 25.0,
                    height: 25,
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(30)),
                    alignment: Alignment.center,
                    child: Text(type),
                  ),
                );
              }),
            ),
          ),
          new RaisedButton(
            onPressed: () async {
              connt10.execute(
                  'update `商品` set `发布信息`=\'${_controllermessages.text}\',`价格`=${_controllercost.text},`运费`=${_controllerfreight.text},`种类`=\'${_controllertype.text}\' where `商品ID`=${widget.goodid}');
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (BuildContext ctx) {
                return MyHomePage2(
                  id: widget.userid,
                );
              }), (route) => route == null);
            },
            child: Text('确认修改'),
          ),
          new RaisedButton(
            color: Colors.red[800],
            onPressed: () async {
              connt10.execute(
                  'update `商品` set `状态`=3 where `商品ID`=${widget.goodid}');
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (BuildContext ctx) {
                return MyHomePage2(
                  id: widget.userid,
                );
              }), (route) => route == null);
            },
            child: Text(
              '下架商品',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  query() async {
    connt10 = await MySqlConnection.connect(s);
    var result = await connt10.execute(
        'select `发布信息`,`价格`,`运费`,`种类` from `商品` where `商品ID`=${widget.goodid}');
    result.forEach((element) {
      setState(() {
        _controllermessages.text = element[0].toString();
        _controllercost.text = element[1].toString();
        _controllerfreight.text = element[2].toString();
        _controllertype.text = element[3].toString();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
