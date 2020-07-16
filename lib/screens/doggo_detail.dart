import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DoggoDetailScreen extends StatelessWidget {

  DoggoDetailScreen(this.doggoBreed);

  final String doggoBreed;

  Future<List<dynamic>> getDoggoImages() async {

    final String imagesUrl = "https://dog.ceo/api/breed/${doggoBreed}/images";
    var imagesResultArr = await http.get(imagesUrl);
    return json.decode(imagesResultArr.body)['message'];
  }

  Future<String> getDoggoDesc() async {

    final String descUrl = "https://en.wikipedia.org/api/rest_v1/page/summary/${doggoBreed}_dog";
    var descResult = await http.get(descUrl);
    return json.decode(descResult.body)['extract'];

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(doggoBreed),
        backgroundColor: Color(0xFFb26972),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FutureBuilder<List<dynamic>>(
              future: getDoggoImages(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if(snapshot.hasData){
                  return Expanded(
                    flex: 2,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index){
                          return Card(
                            margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                            child: Image.network(
                              snapshot.data[index],
                            ),
                          );
                        }),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
            SizedBox(height: 20,),
            Expanded(
              flex: 4,
              child: Card(
                child: FutureBuilder<String>(
                  future: getDoggoDesc(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if(snapshot.hasData){
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          snapshot.data,
                          style: TextStyle(
                            fontSize: 18
                          ),
                        ),
                      );
                    } else {
                      return Center(child: Text('Loading Desc ...'));
                    }
                  }
                ),
              ),
            )
          ],
        ),
      ),

    );
  }
}
