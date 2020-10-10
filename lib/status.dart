import 'package:flutter/material.dart';
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
  double performance = 0;
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
        if (v['performance'] != null) performance = v["performance"];
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
        appBar: AppBar(),
        body: Center(
          child: Text(performance.toString()),
        ));
  }
}
