import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class QueryResultWidget extends StatefulWidget {
  const QueryResultWidget({Key? key, required this.datas}) : super(key: key);
  final List datas;
  @override
  _QueryResultWidgetState createState() => _QueryResultWidgetState();
}

class _QueryResultWidgetState extends State<QueryResultWidget> {
  Widget buildList() {
    return Container(
        margin: EdgeInsets.only(top: 6, left: 24, right: 24, bottom: 6),
        child: Container(
          child: ListView.builder(
              itemCount: widget.datas.length,
              itemBuilder: (ctx, idx) {
                return getCell(idx);
              }),
        ));
  }

  Widget getCell(idx) {
    var data = widget.datas[idx];
    return Container(
      height: 44,
      child: InkWell(
        onTap: () {
          _handleClickMe(idx);
        },
        onDoubleTap: () {
          _downloadWithIndex(idx);
        },
        child: Row(
          children: [
            Expanded(flex: 1, child: Text(data['create_time'].toString())),
            Expanded(flex: 2, child: Text(data['detail'].toString())),
          ],
        ),
      ),
    );
  }

  _downloadWithIndex(idx) {
    String url = widget.datas[idx]['detail'];
    url.replaceFirst('http', 'https');
    _launchURL(url);
  }

  _copyWithIndex(idx) {
    String url = widget.datas[idx]['detail'];
    FlutterClipboard.copy(url)
        .then((value) => Fluttertoast.showToast(msg: "复制成功"));
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _handleClickMe(idx) async {
    return showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Text('下载文件'),
              onPressed: () {
                _downloadWithIndex(idx);
                Navigator.of(context).pop('download');
              },
            ),
            CupertinoActionSheetAction(
              child: Text('复制地址'),
              onPressed: () {
                _copyWithIndex(idx);
                Navigator.of(context).pop('copy');
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            child: Text('取消'),
            onPressed: () {
              Navigator.of(context).pop('cancel');
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildList();
  }
}
