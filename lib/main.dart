// Flutter code sample for Scaffold

// This example shows a [Scaffold] with an [AppBar], a [BottomAppBar] and a
// [FloatingActionButton]. The [body] is a [Text] placed in a [Center] in order
// to center the text within the [Scaffold]. The [FloatingActionButton] is
// centered and docked within the [BottomAppBar] using
// [FloatingActionButtonLocation.centerDocked]. The [FloatingActionButton] is
// connected to a callback that increments a counter.
//
// ![](https://flutter.github.io/assets-for-api-docs/assets/material/scaffold_bottom_app_bar.png)

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ping_discover_network/ping_discover_network.dart';

import 'home_screen.dart';

void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Control it all';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}
const port = 80;
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  String url;
  bool searching=true;
  List<String> ip = new List<String>();
  double opacity=1;
  @override
  initState(){
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: refresher(Duration(seconds: 5)),
        initialData: ip,
        builder: (BuildContext context, snapshot) {
            return showBody(context);
        },
      ),
    );
  }
  Stream<List<String>> refresher(Duration duration) async* {
    while (searching) {
      print('Searching');
      ip = new List<String>();
      changeOpacity();
      await Future.delayed(duration);
      final stream = NetworkAnalyzer.discover2(
        '192.168.1',
        port,
        timeout: Duration(milliseconds: 500),
      );
      stream.listen((NetworkAddress address) {
        if (address.exists) {
          ip.contains(address.ip)? null: ip.add(address.ip);
          Text('${address.ip}');
        }
      });
      yield ip;
    }
  }
  showBody(context) {
    return ip == null
        ? Container(
        child: Text('Fetching Data'),
        alignment: Alignment.center,
        decoration: BoxDecoration(color: Colors.blueGrey))
        : Container(
        decoration: BoxDecoration(color: Colors.white),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              title: Text('Control it All'),
              backgroundColor: Colors.black,
              elevation: 3.0,
              centerTitle: true,
              leading: Opacity(opacity: opacity,child: Icon(Icons.wifi,color: Colors.green,),),
            ),
            SliverToBoxAdapter(child: Padding(padding: EdgeInsets.only(bottom:20),child:Text('Please Choose one of these IPs: ',style: GoogleFonts.amarante(
              fontSize: 20,
              color: Colors.blue
            )))),
            SliverList(
              delegate: SliverChildListDelegate(
                  List.generate(ip.length, (index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 10,left: 10,right: 10),
                      child:  Column(children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('${ip.elementAt(index)}',style: GoogleFonts.catamaran(
                                fontSize: 30,
                                decoration: TextDecoration.none
                            ),),
                            RaisedButton(child:Text('Connect'),
                              onPressed: (){
                                setState(() {
                                  print('Stopped Searcing ${ip.elementAt(index)}');
                                  searching = false;
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomeScreen(ip: ip.elementAt(index)),
                                    ),
                                  );
                                });
                              },),
                          ],
                        ),
                        Divider(height: 3,indent: 20,endIndent: 20,color: Colors.black,)
                      ],)
                    );
                  })),
            )
          ],
        ));
  }

  changeOpacity() {
      opacity = 1 - opacity;
  }
}
