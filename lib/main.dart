import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wp_log_manager/query_param_widget.dart';
import 'package:wp_log_manager/query_result_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WPLogHelper',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'WPLogHelper Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var datas = [];

  void getHttp(Uri uri, Map<String, dynamic> param) async {
    try {
      Dio dio = Dio();
      dio.options.responseType = ResponseType.json; //数据格式
      dio.options.baseUrl = uri.toString();
      Response response = await dio.get("", queryParameters: param);
      setState(() {
        datas = response.data['result'];
      });
    } catch (e) {
      print(e);
    }
  }

  _buildTimeText() {
    //将时间字符串转为时间对象
    DateTime now = new DateTime(2021, 8, 21, 19, 50);
    return Text('build_time: ' + now.toString());
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _buildTimeText(),
            QueryParamWidget(
                queryCallback: (Uri uri, Map<String, dynamic> param) {
              getHttp(uri, param);
            }),
            Expanded(
                child: this.datas.length > 0
                    ? QueryResultWidget(datas: this.datas)
                    : Text("暂无数据"))
          ],
        ),
      ),
    );
  }
}
