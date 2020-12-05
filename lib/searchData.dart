import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class SearchData extends StatefulWidget {
  var country, searchinfo;

  SearchData({Key key, this.country, this.searchinfo}) : super(key: key);

  @override
  _SearchDataState createState() => _SearchDataState();
}

class _SearchDataState extends State<SearchData> {
  List search = [], sports = [];

  Future searchSports() async {
    var url =
        'https://www.thesportsdb.com//api/v1/json/1/search_all_leagues.php?s=${widget.searchinfo}&c=${widget.country}';
    final response = await http
        .get(url)
        .timeout(Duration(seconds: 10))
        .catchError((onError) {
      print(onError);
      print(url);
    });
    var result = json.decode(response.body);
    print(result);
    if (result['countrys'] != null) {
      setState(() {
        search = result['countrys'];
        if (search.length == null) {
          Navigator.pop(context, true);
        }
        print(url);
        print(search);
      });
    } else if (result['countrys'] == null) {
      print("error");
      print(url);
    }
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
        }
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
    searchSports();
    allSports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: search.length,
        itemBuilder: (context, index) {
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                          sports[index]['strSportThumb'],
                        ),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  child: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.grey.withOpacity(0.1),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                //"Blur Background ",
                                search[index]['strLeague'] == null
                                    ? ""
                                    : search[index]['strLeague'],
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
                                          search[index]['strLogo'] == null
                                              ? 'No Image'
                                              : search[index]['strLogo'],
                                        ),
                                        fit: BoxFit.fitWidth)),
                              ),
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
    );
  }
}
