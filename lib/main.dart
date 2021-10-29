import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterlayout/UserDataModel.dart';
import 'package:flutter/services.dart' as rootBundle;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User List Data',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrangeAccent,
      appBar: AppBar(
        elevation: 5,
        title: const Text(
          "BeSquare RocketChat",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("picture/bg.jpg"), fit: BoxFit.cover),
        ),
        child: FutureBuilder(
          future: ReadJsonData(),
          builder: (context, data) {
            if (data.hasError) {
              return Center(child: Text("${data.error}"));
            } else if (data.hasData) {
              var items = data.data as List<UserDataModel>;
              return ListView.builder(
                  itemCount: items == null ? 0 : items.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 3,
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              child: Image(
                                image: NetworkImage(
                                  items[index].avatar == null
                                      ? 'https://cdn1.iconfinder.com/data/icons/robots-avatars-set/354/Cute_robot___robot_robo_cute_cyborg-512.png'
                                      : items[index].avatar.toString(),
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(left: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // First name
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 8, right: 8),
                                      child: Text(
                                        items[index].first_name.toString() +
                                            " " +
                                            items[index].last_name.toString(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.amber[900],
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    // Username
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 8, right: 8),
                                      child: Text(
                                        items[index].username.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    // Status
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 8, right: 8),
                                      child: Text("Status : " +
                                          items[index].status.toString()),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: 80,
                              height: 60,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Lastseen
                                  Padding(
                                    padding: EdgeInsets.only(left: 8, right: 8),
                                    child: Text(
                                      items[index].last_seen_time.toString(),
                                      style: TextStyle(
                                          fontSize: 14,
                                          // color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  // Messages
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 5, left: 8, right: 8),
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        items[index].messages == null
                                            ? ""
                                            : items[index].messages.toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      width: 35,
                                      height: 35,
                                      decoration: new BoxDecoration(
                                        color: Colors.amber[900],
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            offset: Offset(0.0, 1.0), //(x,y)
                                            blurRadius: 6.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      // ),
    );
  }

  Future<List<UserDataModel>> ReadJsonData() async {
    final jsondata =
        await rootBundle.rootBundle.loadString('jsonfile/userlist.json');
    final list = json.decode(jsondata) as List<dynamic>;

    return list.map((e) => UserDataModel.fromJson(e)).toList();
  }
}
