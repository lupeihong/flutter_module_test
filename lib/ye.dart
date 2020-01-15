import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class yyApp extends StatelessWidget{
  String appTilte = "Y阅";
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new CupertinoApp(
      title: "阅1",
      home: new CupertinoPageScaffold(
          navigationBar: new  CupertinoNavigationBar(
            leading: new Material(
              color: Color.fromRGBO(1,1,1,0),
              child: new IconButton(icon: const Icon(Icons.arrow_back_ios)),
            ), 
            middle: new Text(appTilte),
          ),
          child: new ContentList(),
        )
      );
  }
}

class ContentList extends StatefulWidget {
  @override
  State createState() => ContentListState();
}

class ContentListState extends State<ContentList> { 
  String title = "";
  List subjects = [];

  requsetData() async{
    String loadRUL = "https://api.douban.com/v2/movie/in_theaters";
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
            return getItem(subjects[position]);
          });
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

  getItem(var subject) {
//    演员列表
    var avatars = List.generate(subject['casts'].length, (int index) =>
        Container(
          margin: EdgeInsets.only(left: index.toDouble() == 0.0 ? 0.0 : 16.0),
          child: CircleAvatar(
              backgroundColor: Colors.white10,
              backgroundImage: NetworkImage(
                  subject['casts'][index]['avatars']['small']
              )
          ),
        ),
    );

    var row = Container(
      margin: EdgeInsets.all(4.0),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: Image.network(
              subject['images']['large'],
              width: 100.0, height: 150.0,
              fit: BoxFit.fill,
            ),
          ),
          Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 8.0),
                height: 150.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
//                    电影名称
                    Text(
                      subject['title'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                      maxLines: 1,
                    ),
//                    豆瓣评分
                    Text(
                      '豆瓣评分：${subject['rating']['average']}',
                      style: TextStyle(
                          fontSize: 16.0
                      ),
                    ),
//                    类型
                    Text(
                        "类型：${subject['genres'].join("、")}"
                    ),
//                    导演
                    Text(
                        '导演：${subject['directors'][0]['name']}'
                    ),
//                    演员
                    Container(
                      margin: EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: <Widget>[
                          Text('主演：'),
                          Row(
                            children: avatars,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
          )
        ],
      ),
    );
    return Card(
      child: row,
    );
  }

  @override
  Widget build(BuildContext context) {
    return getBody();
  }
}

