import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

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
      appBar: AppBar(),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _srn,
              decoration: InputDecoration(hintText: 'enter your srn'),
            ),
            TextField(
              controller: _pass,
              decoration: InputDecoration(hintText: 'Enter password'),
            ),
            SizedBox(
              height: 20,
            ),
            FlatButton(
                onPressed: () async {
                  bool check = await oncheck();
                  if (check == true)
                    Navigator.of(context)
                        .pushNamed('/dashboard', arguments: _srn.text);
                  else
                    Navigator.of(context).pushNamed('/register');
                },
                child: Text('Login')),
            FlatButton(
                onPressed: () => Navigator.of(context).pushNamed('/register'),
                child: Text('Register'))
          ],
        ),
      ),
    );
  }
}
