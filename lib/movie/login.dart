import 'package:flutter/material.dart';
import 'package:sqljocky5/connection/connection.dart';
import 'package:sqljocky5/connection/settings.dart';

//其他库
import '../main.dart';
import './register.dart';

//todo:数据库连接
MySqlConnection connt;
var s = ConnectionSettings(
  user: "user1", //todo:用户名
  password: "njuDatabase2", //todo:密码
  host: "rm-bp15c45du8jyl66f7eo.mysql.rds.aliyuncs.com", //todo:flutter中电脑本地的ip
  port: 3306, //todo:端口
  db: "databse1", //todo:需要连接的数据库
);

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    print('配置数据库链接');

    try {
      connt = await MySqlConnection.connect(s);
      setState(() {
        state = '连接成功';
      });
    } catch (e) {
      setState(() {
        state = e.toString();
      });
    }
  }

  String state = '连接失败';
  final TextEditingController _controlleruserid = new TextEditingController();
  final TextEditingController _controllerpassword = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: size.width * 0.42,
            child: Image.asset('images/logo1.png'),
          ),
          Container(
            height: size.width * 0.06,
            child: SizedBox(),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: new TextField(
              controller: _controlleruserid,
              keyboardType: TextInputType.number,
              decoration: new InputDecoration(
                  hintText: '  用户ID',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)))),
            ),
          ),
          new Text(''),
          Container(
            padding: EdgeInsets.all(10),
            child: new TextField(
              obscureText: true,
              controller: _controllerpassword,
              decoration: new InputDecoration(
                  hintText: '  密码',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)))),
            ),
          ),
          new Text(''),
          new RaisedButton(
            onPressed: () async {
              var results = await connt.execute('select 用户ID,密码 from 用户');
              results.any((element) {
                return element[0] == _controlleruserid.text &&
                    element[1] == _controllerpassword.text;
              }).then((value) {
                if (value) {
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (BuildContext ctx) {
                    return MyHomePage2(
                      id: _controlleruserid.text,
                    );
                  }), (route) => route == null);
                } else {
                  showDialog(
                    context: context,
                    child: new AlertDialog(title: new Text('用户名或密码错误')),
                  );
                }
              });
            },
            child: new Text('登录'),
            shape: StadiumBorder(),
          ),
          RaisedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext ctx) {
                return RegisterPage();
              }));
            },
            child: Text('注册'),
            shape: StadiumBorder(),
          ),
          Text(state),
        ],
      ),
    );
  }
}
