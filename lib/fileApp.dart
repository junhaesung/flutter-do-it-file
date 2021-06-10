import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FileApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FileApp();
}

class _FileApp extends State<FileApp> {
  List<String> itemList = [];
  TextEditingController _textEditingController = TextEditingController();

  Future<List<String>> readListFile() async {
    List<String> itemList = [];
    var key = 'first';
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool firstCheck = pref.getBool(key) ?? false;
    var dir = await getApplicationDocumentsDirectory();
    bool doesFileExist = await File('${dir.path}/fruit.txt').exists();

    if (firstCheck == false || doesFileExist == false) {
      pref.setBool(key, true);
      var file =
          await DefaultAssetBundle.of(context).loadString('repo/fruit.txt');
      File('${dir.path}/fruit.txt').writeAsStringSync(file);
      var array = file.split('\n');
      for (var item in array) {
        print(item);
        itemList.add(item);
      }
      return itemList;
    } else {
      var file = await File('${dir.path}/fruit.txt').readAsString();
      var array = file.split('\n');
      for (var item in array) {
        print(item);
        itemList.add(item);
      }
      return itemList;
    }
  }

  void writeFruit(String fruit) async {
    var dir = await getApplicationDocumentsDirectory();
    var file = await File('${dir.path}/fruit.txt').readAsString();
    file = file + '\n$fruit';
    File('${dir.path}/fruit.txt').writeAsStringSync(file);
  }

  @override
  void initState() {
    super.initState();
    readCountFile();
    initData();
  }

  void initData() async {
    var results = await readListFile();
    setState(() {
      itemList.addAll(results);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File Example'),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              TextField(
                controller: _textEditingController,
                keyboardType: TextInputType.text,
              ),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Card(
                      child: Center(
                        child: Text(
                          itemList[index],
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                    );
                  },
                  itemCount: itemList.length,
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          writeFruit(_textEditingController.value.text);
          setState(() {
            itemList.add(_textEditingController.value.text);
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void writeCountFile(int count) async {
    var dir = await getApplicationDocumentsDirectory();
    File('${dir.path}/count.txt').writeAsStringSync(count.toString());
  }

  void readCountFile() async {
    try {
      var dir = await getApplicationDocumentsDirectory();
      var file = await File(dir.path + '/count.txt').readAsString();
      print(file);
      setState(() {
        _count = int.parse(file);
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
