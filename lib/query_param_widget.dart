import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class QueryParamWidget extends StatefulWidget {
  const QueryParamWidget({Key? key, required this.queryCallback})
      : super(key: key);
  final void Function(Uri uri, Map<String, dynamic> param) queryCallback;
  @override
  _QueryParamWidgetState createState() => _QueryParamWidgetState();
}

class _QueryParamWidgetState extends State<QueryParamWidget> {
  var controller = TextEditingController();
  List<String> options = <String>[
    '日志 Logs',
    '收据 receipt',
    '语音日志 agora',
    '安卓日志 android_log',
    '自定义路径 custom',
    '视频 video'
  ];

  static const String weplay_main_host = "weplayapp.com";
  static const String path = "activity_v1/common/get_log";
  List<String> areas = <String>[
    '华语服 admin-api',
    '华测服 admin-dev-api',
    '日服 admin-api-tky',
    '日测服 admin-dev-api-tky',
    '阿语服 admin-api-fra',
    '阿测服 admin-dev-api-fra',
    '韩语服 admin-api-sel',
    '韩测服 admin-dev-api-sel',
    '泰服 admin-api-bkk',
    '泰测服 admin-dev-api-bkk',
    '马来服 admin-api-mas',
    '马测服 admin-dev-api-mas',
    '美服 admin-api-sv',
    '美测服 admin-dev-api-sv',
  ];
  String dropdownValue = '日志 Logs';
  String areaValue = '华语服 admin-api';

  String uri_name = 'admin-api';
  String func_name = 'Logs';

  bool env_debug = false;

  Widget buildWidget() {
    return Column(children: [
      Row(children: [
        Expanded(child: uidWidget()),
        Expanded(child: optionWidget()),
        Expanded(child: areaWidget()),
      ]),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: 150,
            height: 44,
            child: MaterialButton(
              color: Colors.blueAccent,
              onPressed: () {
                _buildUrI();
              },
              child: Text(
                "查询",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Container(
            width: 150,
            height: 44,
            child: MaterialButton(
              color: Colors.blueAccent,
              onPressed: () {
                _unzip();
              },
              child: Text(
                "解压",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      )
    ]);
  }

  _buildUrI() {
    String authority = uri_name + "." + weplay_main_host;

    Uri uri = Uri.https(authority, path);
    widget.queryCallback(uri, {
      "uid": controller.text,
      "func_name": func_name,
      "page": 1,
      "page_size": 100,
      "key": "huiwan@wepie2019!"
    });
  }

  _unzip() {
    var unzipUrl = "https://www.bejson.com/othertools/ziponline/";
    _launchURL(unzipUrl);
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget optionWidget() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.all(10),
      child: DropdownButton<String>(
        isExpanded: true,
        value: dropdownValue,
        onChanged: (String? newValue) {
          setState(() {
            dropdownValue = newValue!;
            func_name = dropdownValue.split(' ').last;
          });
        },
        style: const TextStyle(color: Colors.black),
        selectedItemBuilder: (BuildContext context) {
          return options.map((String value) {
            return Container(
              alignment: Alignment.center,
              child: Text(
                dropdownValue,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            );
          }).toList();
        },
        items: options.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget areaWidget() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.all(10),
      child: DropdownButton<String>(
        isExpanded: true,
        value: areaValue,
        onChanged: (String? newValue) {
          setState(() {
            areaValue = newValue!;
            uri_name = areaValue.split(' ').last;
          });
        },
        style: const TextStyle(color: Colors.black),
        selectedItemBuilder: (BuildContext context) {
          return areas.map((String value) {
            return Container(
              alignment: Alignment.center,
              child: Text(
                areaValue,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            );
          }).toList();
        },
        items: areas.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget uidWidget() {
    return Container(
      height: 44,
      alignment: Alignment.center,
      child: Container(
        width: 150,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: this.controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'uid',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildWidget();
  }
}
