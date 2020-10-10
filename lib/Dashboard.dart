import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'dart:convert';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:student/status.dart';
import 'package:http/http.dart' as http;

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  TextEditingController _classcontroller = TextEditingController();
  TextEditingController _studycontroller = TextEditingController();
  TextEditingController _sleepcontroller = TextEditingController();
  TextEditingController _idcontroller = TextEditingController();
  double activity;
  var coll;
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // ignore: deprecated_member_use
  var db;
  database() async {
    //final User user = await _auth.currentUser;
    db = await mongo.Db.create(
        "mongodb+srv://himu:himu@cluster0.qkmvt.mongodb.net/students?retryWrites=true&w=majority");
    await db.open();

    print('DB Connected');
  }

  void initState() {
    // ignore: deprecated_member_use
    super.initState();
    database();
  }

  void onsave(String id) async {
    coll = db.collection(id);
    await coll.insert({
      "_id": DateTime.now().toString(),
      "classhours": _classcontroller.text,
      "sleephours": _sleepcontroller.text,
      "studyhours": _studycontroller.text,
      "activity": json.encode(activity),
    });
    Map data = {
      "_id": DateTime.now().toString(),
      "classhours": _classcontroller.text,
      "sleephours": _sleepcontroller.text,
      "studyhours": _studycontroller.text,
      "activity": json.encode(activity),
    };
    String body = json.encode(data);
    http.Response response = await http.post(
      'http://10.0.2.2:5001',
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    print(activity);
    final srn = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Student'),
      ),
      body: Container(
        child: Column(
          children: [
            TextField(
              controller: _classcontroller,
              decoration: InputDecoration(hintText: 'Enter your Class Hours'),
            ),
            TextField(
              controller: _studycontroller,
              decoration: InputDecoration(hintText: 'Enter your Study Hours'),
            ),
            TextField(
              controller: _sleepcontroller,
              decoration: InputDecoration(hintText: 'Enter your Sleep Hours'),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Select your activity score here',
              style: TextStyle(fontStyle: FontStyle.normal),
            ),
            FlutterSlider(
                values: [10],
                max: 10,
                min: 0,
                onDragging: (handlerIndex, lowerValue, upperValue) {
                  activity = lowerValue;
                  print(activity);
                }),
            FlatButton.icon(
                onPressed: () => onsave(srn),
                icon: Icon(Icons.save),
                label: Text('Save')),
            FlatButton.icon(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Status(
                        uid: srn,
                      ))),
              icon: Icon(Icons.analytics),
              label: Text('Analytics'),
            )
          ],
        ),
      ),
    );
  }
}
