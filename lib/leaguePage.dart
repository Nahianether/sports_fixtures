import 'dart:convert';
import 'dart:ui';

import 'package:appcoder_assignment/searchData.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class LeaguePage extends StatefulWidget {
  var country;

  LeaguePage({Key key, this.country}) : super(key: key);

  @override
  _LeaguePageState createState() => _LeaguePageState();
}

class _LeaguePageState extends State<LeaguePage> {
  List info = [], sports = [];
  final searchcontroller = TextEditingController();
  var thumb;

  Future leagueData() async {
    var url =
        'https://www.thesportsdb.com/api/v1/json/1/search_all_leagues.php?c=${widget.country}';
    final response = await http
        .get(url)
        .timeout(Duration(seconds: 10))
        .catchError((onError) {
      print(onError);
    });
    var result = json.decode(response.body);
    print(result);
    if (result['countrys'] != null) {
      setState(() {
        info = result['countrys'];
        print(info[0]['strFacebook']);
        // if (info.length != null) {
        //   Navigator.pop(context, true);
        // }
        //print(info);
      });
    } else if (result['countrys'] == null) {
      print("error");
    }
  }

  hello() {
    for (int i = 0; i < sports.length; i++) {
      if (sports[i]['strSport'] == info[0]['strSport']) {
        thumb = sports[i]['strSportThumb'];
      }
    }
    return thumb;
  }

  Future allSports() async {
    var url = 'https://www.thesportsdb.com/api/v1/json/1/all_sports.php';
    final response = await http
        .get(url)
        .timeout(Duration(seconds: 10))
        .catchError((onError) {
      print(onError);
    });
    var result = json.decode(response.body);
    print(result);
    if (result['sports'] != null) {
      setState(() {
        sports = result['sports'];
        if (sports.length == null) {
          Navigator.pop(context, true);
          //hello();
        }
        //print(sports);
      });
    } else if (result['sports'] == null) {
      print("error");
    }
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    leagueData();
    allSports();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
              child: Container(
          height: size.height * 1,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                  height: size.height * 0.1,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 40,
                          width: 280,
                          child: TextField(
                            controller: searchcontroller,
                            decoration: InputDecoration(
                              labelText: "Search Leagues",
                              labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                  fontSize: 15),
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(5.0),
                                ),
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      RaisedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchData(
                                      searchinfo:
                                          '${searchcontroller.text.toString()}',
                                      country: '${widget.country}')));
                        },
                        child: Text("Search"),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: size.height * 0.88,
                ///color: Colors.greenAccent,
                child: ListView.builder(
                  itemCount: info.length,
                  itemBuilder: (context, index) {
                    //List sports = sports[index]['strSport'];
                    //print(sports[index]['strSport']);
                    if (sports[index]['strSport'] == info[index]['strSport']) {
                      print('ok');
                      thumb = sports[index]['strSportThumb'];
                    }
                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(image: NetworkImage(
                                  //sports[0]['strSportThumb'],
                                  //thumb
                                  hello()), fit: BoxFit.cover),
                              borderRadius: BorderRadius.all(
                                Radius.circular(15.0),
                              ),
                            ),
                            child: ClipRRect(
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                                child: Container(
                                  alignment: Alignment.center,
                                  color: Colors.grey.withOpacity(0.1),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          //"Blur Background ",
                                          info[index]['strLeague']== null
                                                        ? ""
                                                        : info[index]['strLeague'],
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          height: 80,
                                          width: 150,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                    info[index]['strLogo'] == null
                                                        ? 'No Image'
                                                        : info[index]['strLogo'],
                                                  ),
                                                  fit: BoxFit.fitWidth)),
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Text(
                                            info[index]['strFacebook'] == null
                                            ? ""
                                            : info[index]['strFacebook'],
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            info[index]['strTwitter']== null
                                            ? ""
                                            : info[index]['strTwitter'],
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),

                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
