import 'package:flutter/material.dart';

class GifPage extends StatelessWidget {
  GifPage({Key? key}) : super(key: key);

  var gifData;

  GifPage.withData(this.gifData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(gifData != null ? gifData['title'] : ''),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(gifData['images']['fixed_height']['url']),
      ),
    );
  }
}
