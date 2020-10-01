import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

var profile = AssetImage('images/linkedin');

var mykey, myvalue;

help() async {
  var url = "https://www.javatpoint.com/linux-commands";
  if (await canLaunch(url)) {
    await launch(
      url,
    );
  } else {
    throw 'Could not launch $url';
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  var fs = FirebaseFirestore.instance;
  var out;
  String command;
  myweb(mykey, myvalue) async {
    await fs.collection("command").add({
      '$mykey': '$myvalue',
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.pink,
            title: Text('LINUX COMMANDS'),
            leading: Image.asset('images/linux.jpeg'),
            actions: <Widget>[
              IconButton(icon: Icon(Icons.help), onPressed: help),
              GestureDetector(
                onTap: () async {
                  var url = "https://www.linkedin.com/in/ayush-gupta-31182a196";
                  if (await canLaunch(url)) {
                    await launch(
                      url,
                    );
                  }
                },
                child: Image.asset('images/linkedin.jpeg'),
              ),
            ],
          ),
          body: Container(
            alignment: Alignment.center,
            height: double.infinity,
            width: double.infinity,
            color: Colors.blue[200],
            child: Center(
              child: Container(
                alignment: Alignment.center,
                height: 800,
                width: 400,
                color: Colors.pink,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 180,
                        width: 180,
                        margin: EdgeInsets.only(top: 7),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                            image: AssetImage('images/icon.jpeg'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      Card(
                        margin:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 4),
                        child: TextField(
                          onChanged: (val) {
                            command = val;
                          },
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.comment,
                                color: Colors.redAccent[700],
                              ),
                              hintStyle: TextStyle(
                                  color: Colors.redAccent[700],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                              hintText: "Enter Your Command",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                  style: BorderStyle.solid,
                                ),
                              )),
                        ),
                      ),
                      Card(
                          child: FlatButton(
                        onPressed: () async {
                          var url =
                              "http://192.168.29.222/cgi-bin/com.py?x=$command";

                          var r = await http.get(url);
                          setState(() {
                            out = r.body;
                          });

                          myweb(command, out);
                        },
                        child: Text(
                          "RUN COMMAND",
                          style: TextStyle(
                            color: Colors.redAccent[700],
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )),
                      Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              color: Colors.white,
                              child: Text(
                                out ?? "\n COMMAND OUTPUT \n",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent[700],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Card(
                          child: FlatButton(
                        onPressed: () async {
                          /**var data = await fs.collection('command').get();

                          //print(data.docs[0].data());
                          for (var i in data.docs) {
                            print(i.data());
                          }
                          **/
                          await for (var i
                              in fs.collection('command').snapshots()) {
                            for (var j in i.docs) {
                              print(j.data());
                            }
                          }
                        },
                        child: Text(
                          "   GET OUTPUT  ",
                          style: TextStyle(
                            color: Colors.redAccent[700],
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
              ),
            ),
          ),
          backgroundColor: Colors.yellow[300],
        ));
  }
}
