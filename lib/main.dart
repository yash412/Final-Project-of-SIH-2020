import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:mongo_dart/mongo_dart.dart' as dart_mongo;

final TextEditingController _pass = TextEditingController();
final TextEditingController _confirmPass = TextEditingController();
String _email;
var name;
var dob;
var phone;
var email;
var pass;
var cPass;
var loc;
void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Form Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Registration(),
    );
  }
}

class Registration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text('Registration form'),
      ),
      body: new SafeArea(
          top: false,
          bottom: false,
          child: new Form(
              autovalidate: true,
              child: new ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: <Widget>[
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Enter your first and last name',
                      labelText: 'Name',
                    ),
                    onFieldSubmitted: (text) {
                      print("First text field: $text");
                      name = text;
                      print(name);
                    },
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.calendar_today),
                      hintText: 'Enter your date of birth',
                      labelText: 'Dob',
                    ),
                    keyboardType: TextInputType.datetime,
                    onFieldSubmitted: (text) {
                      print("First text field: $text");
                      dob = text;
                      print(dob);
                    },
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.phone),
                      hintText: 'Enter a phone number',
                      labelText: 'Phone',
                    ),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                    onFieldSubmitted: (text) {
                      print("First text field: $text");
                      phone = text;
                      print(phone);
                    },
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.email),
                      hintText: 'Enter a email address',
                      labelText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) =>
                    !val.contains('@') ? 'Invalid Email' : null,
                    onSaved: (val) => _email = val,
                    onFieldSubmitted: (text) {
                      print("First text field: $text");
                      email = text;
                      print(email);
                    },
                  ),
                  new TextFormField(
                    controller: _pass,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.add_circle_outline),
                      hintText: 'Enter password',
                      labelText: 'Password',
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    onFieldSubmitted: (text) {
                      print("First text field: $text");
                      pass = text;
                      print(pass);
                    },
                  ),
                  new TextFormField(
                    controller: _confirmPass,
                    validator: (val) {
                      if (val != _pass.text) return 'Not Match';
                      return null;
                    },
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.add_circle_outline),
                      hintText: 'Confirm password',
                      labelText: 'Confirm password',
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    onFieldSubmitted: (text) {
                      print("First text field: $text");
                      cPass = text;
                      print(cPass);
                    },
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.add_location),
                      hintText: 'Enter your office location',
                      labelText: 'Office location',
                    ),
                    onFieldSubmitted: (text) {
                      print("First text field: $text");
                      loc = text;
                      print(loc);
                    },
                  ),
                  new Container(
                    padding: const EdgeInsets.only(top: 40.0),
                    width: 250.0,
                    height: 85.0,
                    child: new RaisedButton(
                        child: Text('Add Faces'),
                        onPressed: () {

                        }),
                  ),
                  new Container(
                    padding: const EdgeInsets.only(top: 40.0),
                    width: 250.0,
                    height: 85.0,
                    child: new RaisedButton(
                      color: Colors.red,
                      child: Text(
                        "Submit",
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w700),
                      ),
                      elevation: 9.0,
                      onPressed: () {
                        bookFlight(context);
                        DataColl();
                      },
                    ),
                  ),
                ],
              ))),
    );
  }

  void bookFlight(BuildContext context) {
    var alertDialog = AlertDialog(
      title: Text("Form submitted successfully!"),
    );

    showDialog(
        context: context, builder: (BuildContext context) => alertDialog);
  }

  void DataColl() async {
    Db db = new Db("mongodb://localhost:27017/people");
    await db.open();
    print('connected to database');
    DbCollection coll = db.collection("students");
    await coll.insert({
      "name": name,
      "dob": dob,
      "phone": phone,
      "email": email,
      "password": pass,
      "cPass": cPass,
      "location": loc
    });
    var student = await coll.find().toList();
    print(student);
    await db.close();
  }
}
