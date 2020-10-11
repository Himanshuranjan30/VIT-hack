import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import "dart:convert";

class Status extends StatefulWidget {
  String uid;
  String time;
  Status({Key key, @required this.uid, this.time}) : super(key: key);
  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> {
  var coll;
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // ignore: deprecated_member_use
  var db;
  Map<String, dynamic> result;
  List<String> classh = [];
  List<String> study = [];
  List<String> sleep = [];
  String performance = 'Calculating your Performance..';
  database() async {
    //final User user = await _auth.currentUser;
    db = await mongo.Db.create(
        "mongodb+srv://himu:himu@cluster0.qkmvt.mongodb.net/students?retryWrites=true&w=majority");
    await db.open();

    print('DB Connected');
    coll = db.collection(widget.uid);
    print(coll);
    await coll.find(mongo.where.lt("_id", widget.time)).forEach((v) {
      print(v["performance"]);
      setState(() {
        if (v['performance'] != null) performance = v["performance"].toString();
      });
    });
  }

  void initState() {
    // ignore: deprecated_member_use
    super.initState();
    database();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Performance Report'),
          backgroundColor: Colors.indigo,
        ),
        body: Column(
          children: [
            Image.network(
                'https://www.cambridgemaths.org/Images/The-trouble-with-graphs.jpg',
                height: 150,
                width: 200),
            Text(
              'Performance Report',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            ),
            SizedBox(
              height: 140,
            ),
            Center(
              child: Text(
                'Your Performance Cofficient:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: Text(
                performance.toString(),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 250,
            ),
            performance == 'Calculating your Performance..'
                ? SpinKitRotatingCircle(
                    color: Colors.blue,
                    size: 50.0,
                  )
                : Container(),
            SizedBox(
              height: 15,
            ),
            Center(
              child: Text(
                '(If not shown Kindly re-enter the data)',
                style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
              ),
            )
          ],
        ));
  }
}
