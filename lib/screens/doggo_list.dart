import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'doggo_detail.dart';

class DoggoBreedsList extends StatelessWidget {

  final String apiUrl = "https://dog.ceo/api/breeds/list/all";

  Future<List<dynamic>> getDoggos() async {

    var result = await http.get(apiUrl);
    List<dynamic> doggoList = [];

    var decoded = json.decode(result.body)['message'];
    for (var doggo in decoded.keys) {
     // print(doggo);
      doggoList.add(doggo);
    }

    return doggoList;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Color(0xFFb26972),
          child: Column(
            children: [
              Center(
                child: Lottie.asset(
                  'assets/happy_doggo.json',
                  width: 200,
                  height: 200,
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(height: 20,),
              Text(
                'Doggo Lingo',
                style: TextStyle(
                    fontFamily: 'BungeeShade',
                    fontSize: 35,
                    color: Colors.white
                ),
              ),
              SizedBox(height: 20,),
              FutureBuilder<List<dynamic>>(
                future: getDoggos(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if(snapshot.hasData){
                    return Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          padding: EdgeInsets.all(8),
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index){
                            return GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (BuildContext context) =>  DoggoDetailScreen(snapshot.data[index]),
                                  ));
                                },
                                child: Card(
                                  child: Column(
                                    children: <Widget>[
                                      ListTile(
                                        title: Text(snapshot.data[index]),
                                      )
                                    ],
                                  ),
                                ),
                              );
                          }),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}