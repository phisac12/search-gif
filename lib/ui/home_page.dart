
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hunters_gif/ui/gif_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String _search = '';

  int _offset = 0;

  Future<Map> _getGifs() async {
    http.Response response;

    if(_search == '') {
      response = await http.get("https://api.giphy.com/v1/gifs/search?api_key=G96quVulzHPDkFczotW1hS9LAlzS3zjJ&q=dogs&limit=20&offset=25&rating=g&lang=pt");
    } else {
      response = await http.get("https://api.giphy.com/v1/gifs/search?api_key=G96quVulzHPDkFczotW1hS9LAlzS3zjJ&q=$_search&limit=19&offset=$_offset&rating=g&lang=pt");
    }

    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();

    _getGifs().then((map) {
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.network("https://developers.giphy.com/branch/master/static/header-logo-0fec0225d189bc0eae27dac3e3770582.gif"),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Pesquise aqui!',
                labelStyle: TextStyle(color: Colors.white),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)
                )
              ),
              style: const TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
              onSubmitted: (text){
                setState(() {
                  _search = text;
                  _offset = 0;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              builder: (context, snapshot) {
                switch(snapshot.connectionState){
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200,
                      height: 200,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
                        strokeWidth: 5.0,
                      ),
                    );
                  default:
                    if(snapshot.hasError) return Container();
                    else return _createGifTable(context, snapshot);
                }
              },
            ),
          )
        ],
      ),
    );
  }

  int _getCount(List data) {
    if (_search == '') {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10
        ),
        itemCount: _getCount(snapshot.data['data']),
        itemBuilder: (context, index) {
          if(_search == '' || index < snapshot.data['data'].length) {
            return GestureDetector(
              child: Image.network(snapshot.data['data'][index]['images']['fixed_height']['url'],
                height: 300.0,
                fit: BoxFit.cover,),
              onTap: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => GifPage.withData(snapshot.data['data'][index],))
                );
              },
            );
          } else {
            return GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Icon(Icons.add, color: Colors.deepPurple, size: 70.0,),
                  Text('Carregar mais ..', style: TextStyle(color: Colors.white, fontSize: 22.0),)
                ],
              ),
              onTap: (){
                setState(() {
                  _offset += 19;
                });
              },
            );
          }
        }
    );
  }
}