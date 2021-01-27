import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import './login.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() {
    return _RegisterPageState();
  }
}

File _image;

class _RegisterPageState extends State<RegisterPage> {
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    //获取屏幕宽度
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('注册'),
        backgroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
      body: ListView(
        children: [
          Text(''),
          Text(''),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.grey[200]),
                height: size.width * 0.4,
                width: size.width * 0.4,
                child: Center(
                  child: _image == null
                      ? Text('选择一张图片作为头像.')
                      : Image.file(
                          _image,
                        ),
                ),
              ),
              TextPage(),
            ],
          )
        ],
      ),
    );
  }

  Future getImage() async {
    final pickedFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
}

class TextPage extends StatefulWidget {
  @override
  _TextPageState createState() {
    return _TextPageState();
  }
}

class _TextPageState extends State<TextPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final TextEditingController _controllerusername = new TextEditingController();
  final TextEditingController _controllerpassword = new TextEditingController();
  final TextEditingController _controllerpasswordagain =
      new TextEditingController();
  final TextEditingController _controllertel = new TextEditingController();
  final TextEditingController _controlleraddress = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      new TextField(
        controller: _controllerusername,
        decoration: new InputDecoration(
          hintText: '  用户名',
        ),
      ),
      new TextField(
        obscureText: true,
        controller: _controllerpassword,
        decoration: new InputDecoration(
          hintText: '  密码',
        ),
      ),
      new TextField(
        obscureText: true,
        controller: _controllerpasswordagain,
        decoration: new InputDecoration(
          hintText: '  再次输入密码',
        ),
      ),
      new TextField(
        keyboardType: TextInputType.number,
        controller: _controllertel,
        decoration: new InputDecoration(
          hintText: '  电话',
        ),
      ),
      new TextField(
        keyboardType: TextInputType.number,
        controller: _controlleraddress,
        decoration: new InputDecoration(
          hintText: '  默认收货地址',
        ),
      ),
      new RaisedButton(
        onPressed: () {
          if (_controllerpassword.text.length == 0 ||
              _controllerusername.text.length == 0) {
            showDialog(
              context: context,
              child: new AlertDialog(title: new Text('内容不能为空')),
            );
          } else if (_controllerpassword.text !=
              _controllerpasswordagain.text) {
            showDialog(
              context: context,
              child: new AlertDialog(title: new Text('两次密码输入不同')),
            );
          } else if (_controllerpassword.text.length < 6) {
            showDialog(
              context: context,
              child: new AlertDialog(title: new Text('密码应大于六位')),
            );
          } else if (_controllertel.text.length != 11) {
            showDialog(
              context: context,
              child: new AlertDialog(title: new Text('电话输入有误')),
            );
          } else {
            String username = _controllerusername.text;
            String password = _controllerpassword.text;
            String tel = _controllertel.text;
            int id = DateTime.now().millisecondsSinceEpoch % 10000000;

            _image.readAsBytes().then((value) async {
              await connt.execute(
                  'insert into 用户 (用户ID,用户名,密码,头像,电话号码,默认地址) values (\'$id\',\'$username\',\'$password\',\'$value\',\'$tel\',\'${_controlleraddress.text}\')');
              connt.execute(
                  'insert into `收藏夹` (`用户ID`,`收藏夹名`) values (\'$id\',\'默认收藏夹\')');
            });

            showDialog(
              context: context,
              child: new AlertDialog(title: new Text('注册成功\nID：$id\n请返回登录')),
            );
          }
        },
        child: Text('注册'),
      )
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    _image = null;
  }
}
