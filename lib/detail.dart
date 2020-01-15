import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class DetailPage extends StatelessWidget { 
  final Set<WordPair> _saved;
  final TextStyle _biggerFont =  const TextStyle(fontSize: 18.0);
  DetailPage(this._saved);

  Iterable<ListTile> _getTiles(){
    return _saved.map(
            (WordPair pair) {
              return new ListTile(
                title: new Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
            appBar: new AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: 
            // new ListView(
            //   children: 
            //     ListTile.divideTiles(
            //       context: context,
            //       tiles: _getTiles(),
            //     ).toList()
            // )
            new Center(
              child: FlatButton(
                child: Text('POP'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
    );
  }
}