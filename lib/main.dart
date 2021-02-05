import 'dart:convert';

import 'package:flutter/material.dart';
import "package:flutter_barcode_scanner/flutter_barcode_scanner.dart";
import 'package:http/http.dart' as http;


void main() {
  runApp(MyApp());}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search Song Contents',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Search Song Contents'),
    );
  }
}

class MyHomePage extends StatefulWidget {

  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String name = "";
  String description = "";


  Future _incrementCounter() async{

    // バーコードをスキャンする
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", false, ScanMode.DEFAULT);

    // janコードから商品を検索
    String url = "http://shopping.yahooapis.jp/ShoppingWebService/V3/itemSearch?appid=dj00aiZpPU43aHIyUkp0U2FpeCZzPWNvbnN1bWVyc2VjcmV0Jng9NWU-&seller_id=felista&jan_code=${barcodeScanRes}";

    http.get(url).then((response) async {
      Map<String, dynamic> data = json.decode(response.body);

      setState(() {

        if (data["hits"].length != 0) {
          List<dynamic> hits = data["hits"];
          name = hits[0]["name"];
          description = hits[0]["description"];

        } else {
          name = "商品が登録されていません";
          description = "商品が登録されていません";
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "タイトル",
              style: Theme.of(context).textTheme.display1,),
            Text(name,
              style: Theme.of(context).textTheme.headline,),
            Text(
              "詳細",
              style: Theme.of(context).textTheme.display1,),
            Text(description,
              style: Theme.of(context).textTheme.headline,),
          ],
        ),
      ),
      // カメラを起動するボタン
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.settings_overscan),
      ),
    );
  }
}