
import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:core';
import '../model/product_model.dart';
import 'package:http/http.dart' as http;

enum ProductAction{
  fetch,delete
}
class NewsBlock{
  final _stateStreamController =StreamController<Data>();
  StreamSink<Data?> get productSink=>_stateStreamController.sink;
  Stream<Data> get newsStream=>_stateStreamController.stream;

  final _eventStreamController =StreamController<ProductAction>();
  StreamSink<ProductAction> get eventSink=>_eventStreamController.sink;
  Stream<ProductAction> get _eventStream=>_eventStreamController.stream;

  NewsBlock(){
    _eventStream.listen((event)async {
      if(event==ProductAction.fetch){
        try {
          var news= await getNews();
          if(news.data !=null){
            productSink.add(news.data);
          }
          else{
            productSink.addError("wrong output");
          }

        } on Exception catch (e) {
          productSink.addError("wrong output");
        }

      }
    });
  }
  Future<Welcome> getNews() async {
    var welCome;

    var response = await http.get(Uri.parse(
        "https://panel.supplyline.network/api/product/search-suggestions/?limit=10&offset=10&search=rice"));
    print("======>${response.statusCode}");
    if (response.statusCode == 200) {
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);
      print("======>$jsonMap");
      welCome = Welcome.fromJson(jsonMap);
    }
    return welCome;
  }
}