import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


void main() {
  runApp(const MaterialApp(home: MyApp()));
  }

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List> data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data = api.GetData();
    print(data);
  }
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        title: const Text("News App"),
      ),
      body: Container(
        child: FutureBuilder<List>(
          future: data,
          builder: (context, snapshot){
            if(snapshot.hasData){
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, i){
                  
                  return Card(
                    child: ListTile(
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children:[
                          Text(snapshot.data![i]['title'], style: const TextStyle(fontSize: 20)),  
                          Text(snapshot.data![i]['description'], style: const TextStyle(fontSize: 15)), 
                      ]),
                    ),
                  );
                }
                );
            }
            else{
              return const Center(
                child: Text("Pas de données"),
              );
            }
          },
        ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/ajout');
          },
          child: const Text("+"),
      ),  
    );
  }
}

class api {

  static Future<List> GetData() async {
        try{
      var res = await http.get(Uri.parse("https://newsapi.org/v2/everything?q=web&sortBy=popularity&apiKey=94c1146e556f439a848ace47c3cb5bfa"));
      if(res.statusCode == 200){
        print(jsonDecode(res.body)['articles']);
        return jsonDecode(res.body)['articles'];
      }
      else{
        return Future.error("erreur serveur");
      }
    }
    catch(err){
      return Future.error(err);
    }
  }

  

   
}