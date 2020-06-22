import 'package:flutter/material.dart';

import 'api_requests.dart';
import 'main.dart';

class HomeScreen extends StatefulWidget {
  final String ip;
  HomeScreen({Key key, @required this.ip}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState(ip);
}

class _HomeScreenState extends State<HomeScreen> {
  String ip;
  _HomeScreenState(this.ip);
  bool showImage=false;
  String link="";
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: Colors.amber),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton.icon(
                    icon: Icon(Icons.snooze),
                    label: Text('Sleep'),
                    color: Colors.redAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                    onPressed: () async {
                      await move(ip, 'sleep');
                    }),
                SizedBox(width: 10,),
                RaisedButton.icon(
                    icon: Icon(Icons.arrow_drop_up),
                    label: Text('Screenshot'),
                    color: Colors.greenAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                    onPressed: () async {
                      show(await move(ip, 'screenshot'));
                    }),
              ],
            ),
            showImage?Image.network(link,width: 400,height: 400,):Container(),
            SizedBox(
              height: 100,
              width: 100,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: RaisedButton(
                    child: Text('Back'),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyStatefulWidget(),
                        ),
                      );
                    }),
              ),
            )
          ],
        ));
  }

  void show(link) {
    setState(() {
      this.link=link;
      showImage=true;
    });

  }
}
