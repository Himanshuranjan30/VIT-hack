import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:student/Dashboard.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _srn = TextEditingController();

  TextEditingController _pass = TextEditingController();
  var coll;

  var db;

  database() async {
    //final User user = await _auth.currentUser;
    db = await mongo.Db.create(
        "mongodb+srv://himu:himu@cluster0.qkmvt.mongodb.net/registered?retryWrites=true&w=majority");
    await db.open();

    print('DB Connected');
  }

  void initState() {
    // ignore: deprecated_member_use
    super.initState();
    database();
  }

  Future<bool> oncheck() async {
    coll = db.collection(_srn.text);
    var id = await coll.findOne({"id": _srn.text});
    var pass = await coll.findOne({"password": _pass.text});
    print(id['id']);
    print(pass['password']);
    if (id['id'] == _srn.text && pass['password'] == _pass.text) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Login'),
        backgroundColor: Colors.indigo,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://www.majhimaitrin.in/img/studlogin.png',
              height: 100,
              width: 100,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Enter Your SRN',
              style: TextStyle(
                  fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),
            ),
            Center(
              child: Container(
                width: 250,
                child: TextField(
                  controller: _srn,
                  decoration: InputDecoration(hintText: 'enter your srn'),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'Enter Your Password',
              style: TextStyle(
                  fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),
            ),
            Center(
              child: Container(
                width: 250,
                child: TextField(
                  controller: _pass,
                  decoration: InputDecoration(hintText: 'Enter password'),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            FlatButton.icon(
                onPressed: () async {
                  bool check = await oncheck();
                  if (check == true)
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DashBoard(
                              uid: _srn.text,
                            )));
                  else
                    Navigator.of(context).pushNamed('/register');
                },
                icon: Icon(Icons.login),
                color: Colors.indigo,
                label: Text('Login', style: TextStyle(color: Colors.white))),
            SizedBox(
              height: 20,
            ),
            Text("Haven't Registered yet?",
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(
              height: 15,
            ),
            FlatButton.icon(
              onPressed: () => Navigator.of(context).pushNamed('/register'),
              icon: Icon(Icons.app_registration),
              label: Text(
                'Register Now',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.indigo,
            )
          ],
        ),
      ),
    );
  }
}
