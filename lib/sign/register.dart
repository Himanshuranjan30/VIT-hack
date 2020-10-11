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
      appBar: AppBar(
          title: Text('Student Registration'), backgroundColor: Colors.indigo),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                'https://www.majhimaitrin.in/img/studlogin.png',
                height: 100,
                width: 100,
              ),
              SizedBox(
                height: 15,
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
              SizedBox(height: 20),
              Text(
                'Choose a Password',
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
                onPressed: () => onsave(),
                label: Text('Register', style: TextStyle(color: Colors.white)),
                icon: Icon(Icons.app_registration),
                color: Colors.indigo,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                'Already Have an Account?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              FlatButton.icon(
                onPressed: () => Navigator.of(context).pushNamed('/login'),
                label: Text(
                  'Login',
                  style: TextStyle(color: Colors.white),
                ),
                icon: Icon(Icons.login),
                color: Colors.indigo,
              )
            ],
          ),
        ),
      ),
    );
  }
}
