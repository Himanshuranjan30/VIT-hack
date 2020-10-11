import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import "dart:convert";
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

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
  List<String> dates = [];
  List<double> perf = [];
  bool ischart = false;
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
    await coll.find().forEach((v) {
      classh.add(v["classhours"]);
      sleep.add(v["sleephours"]);
      study.add(v["studyhours"]);
      dates.add(v["_id"]);
      perf.add(v["performance"]);
    });
    setState(() {
      ischart = true;
    });
    print(classh);
    print(sleep);
    print(study);
    print(dates);
    print(perf);
  }

  void initState() {
    // ignore: deprecated_member_use
    super.initState();
    database();
  }

  List<charts.Series<Sales, String>> _createSampleData() {
    final data = [
      new Sales('Monday', perf[0] != null ? perf[0].toInt() : 0),
      new Sales('Tuesday', perf[1] != null ? perf[1].toInt() : 0),
      new Sales('Wednesday', perf[2] != null ? perf[2].toInt() : 0),
      new Sales('Thursday', perf[3] != null ? perf[3].toInt() : 0),
      new Sales('Friday', perf[4] != null ? perf[4].toInt() : 0)
    ];

    return [
      new charts.Series<Sales, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Sales sales, _) => sales.date,
        measureFn: (Sales sales, _) => sales.hours,
        data: data,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Performance Report'),
          backgroundColor: Colors.indigo,
        ),
        body: SingleChildScrollView(
          child: Column(
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
              ischart == true
                  ? Container(
                      height: 200,
                      width: 400,
                      child: charts.BarChart(_createSampleData()))
                  : Container(),
              performance == 'Calculating your Performance..'
                  ? SpinKitRotatingCircle(
                      color: Colors.blue,
                      size: 50.0,
                    )
                  : Container(),
              SizedBox(
                height: 15,
              ),
              Text('Performance Graph(X- Day, Y- Performance Cofficient'),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  '(If not shown Kindly re-enter the data)',
                  style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
                ),
              )
            ],
          ),
        ));
  }
}

class Sales {
  String date;
  int hours;

  Sales(this.date, this.hours);
}
