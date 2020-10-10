import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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

  onsave() async {
    coll = db.collection(_srn.text);
    await coll.insert({"id": _srn.text, "password": _pass.text});
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
            FlatButton(onPressed: () => onsave(), child: Text('Register')),
            FlatButton(
                onPressed: () => Navigator.of(context).pushNamed('/login'),
                child: Text('Login'))
          ],
        ),
      ),
    );
  }
}
