// import 'fav.dart';
import 'package:flutter/material.dart';
import 'ye.dart';
// import 'myapp.dart';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(new yyApp());
  // runApp(new MyApp());
}


class yyApp extends StatelessWidget {
  String appTilte = "Y阅";
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new CupertinoApp(
        title: "阅1",
        home: new CupertinoPageScaffold(
          navigationBar: new CupertinoNavigationBar(
            leading: new Material(
              color: Color.fromRGBO(1, 1, 1, 0),
              child: new IconButton(icon: const Icon(Icons.arrow_back_ios)),
            ),
            middle: new Text(appTilte),
          ),
          child: new ContentList(),
        ));
  }
}

class ContentList extends StatefulWidget {
  @override
  State createState() => ContentListState();
}

class ContentListState extends State<ContentList> {
  String title = "";
  List subjects = [];

  requsetData() async {
    String loadRUL = "https://douban.uieee.com/v2/movie/in_theaters";
    http.Response response = await http.get(loadRUL);
    var result = json.decode(response.body);
    setState(() {
      title = result['title'];
      subjects = result['subjects'];
    });
  }

  getBody() {
    if (subjects.length != 0) {
      return ListView.builder(
          itemCount: subjects.length,
          itemBuilder: (BuildContext context, int position) {
            return getCell(subjects[position]);
          },
          );
    } else {
      requsetData();
      // 加载菊花
      return new Container(
          decoration: const BoxDecoration(
            color: CupertinoColors.white,
          ),
          child: new Center(child: const CupertinoActivityIndicator()));
    }
  }

  getCell(var subject) {
    return 
    new GestureDetector(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 9,right: 4),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 14, right: 4,bottom: 11),
                        height: 40,
                        child: Text(subject['title'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold
                          ),
                        )
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text('导演：${subject['directors'][0]['name']}',maxLines: 1,overflow: TextOverflow.ellipsis,)
                      )
                    ],
                  ),
                ),
                Image.network(
                  subject['images']['large'],
                  width: 118.0,
                  height: 87.0,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
          Container(
            color: Colors.black12,
            height: 5,
          )
        ],
      ),
      onTap: (){
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context){
            return CupertinoAlertDialog(
              title: Text('我是title'),
              content: Text('我是content'),
              actions: <Widget>[
                new CupertinoButton(onPressed: () {
                  Navigator.of(context).pop();
                }, child: Text('取消')),
                new CupertinoButton(onPressed: () {
                  Navigator.of(context).pop();
                }, child: Text('确认')),
              ],
            );
          }
        );
        
      },
    );
    
  }

  @override
  Widget build(BuildContext context) {
    return getBody();
  }
}
