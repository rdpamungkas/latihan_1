import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:latihan_1/data_model.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  
  bool isLoading = false;
  int page = 1;
  bool hasMore = true;
  List<DataModel> items=[];

  Future fetch() async {
    if (isLoading) return;

    isLoading = true;

    final url = Uri.parse(
        'https://script.google.com/macros/s/AKfycbxSW2d_VuQzc-GoYTy0WU4g8zoKk6-OwT0z_xu3NEWb9sBquieXheDSJDcbRSf8K8db/exec?page=$page');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var result = json.decode(response.body);

      var data = result['data'] as List;

      final newItems = data.map((json) => DataModel.fromJson(json)).toList();

      setState(() {
        page++;

        isLoading = false;

        if (newItems.isEmpty) {
          hasMore = false;
        }

        items.addAll(newItems);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Judul Halaman'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (() {
            setState(() {
              fetch();
            });
          }),
          child: const Icon(Icons.add),
        ),
        body: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: ((context, index) {
                return Card(
                  child: ListTile(title: Text('${items[index].name}')),
                );
              }),
            )));
  }
}
