import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:sqljocky5/connection/connection.dart';
import '../main.dart';
import './login.dart';

class PublishPage extends StatefulWidget {
  PublishPage({Key key, this.username, this.id}) : super(key: key);
  String username;
  String id;
  @override
  _PublishPageState createState() {
    return _PublishPageState();
  }
}

File _image;

MySqlConnection connt2;

class _PublishPageState extends State<PublishPage> {
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    //获取屏幕宽度
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('发布商品'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
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
                ),
                height: size.width * 0.6,
                width: size.width * 0.6,
                child: Center(
                  child:
                      _image == null ? Text('请选择一张商品照片') : Image.file(_image),
                ),
              ),
              PublishTextPage(
                id: widget.id,
              ),
              Text('')
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

  @override
  void dispose() {
    super.dispose();
    setState(() {
      _image = null;
    });
  }
}

class PublishTextPage extends StatefulWidget {
  PublishTextPage({Key key, this.username, this.id}) : super(key: key);

  final String username;
  final String id;
  @override
  _PublishTextPageState createState() {
    return _PublishTextPageState();
  }
}

class _PublishTextPageState extends State<PublishTextPage>
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
  Widget build(BuildContext context) {
    query();
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Column(
        children: [
          new TextField(
            style: TextStyle(fontSize: 13),
            maxLines: null,
            maxLength: 1000,
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
              _image.readAsBytes().then((value) {
                connt2.execute(
                    'insert into 商品 (卖家ID,发布信息,商品照片,种类,价格,运费,状态) values (\'${widget.id}\',\'${_controllermessages.text}\',\'$value\',\'${_controllertype.text}\',${_controllercost.text},${_controllerfreight.text},1)');
              });

              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (BuildContext ctx) {
                return MyHomePage2(
                  id: widget.id,
                );
              }), (route) => route == null);
            },
            child: Text('发布'),
          ),
        ],
      ),
    );
  }

  query() async {
    connt2 = await MySqlConnection.connect(s);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
