import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:testproject/model/product_model.dart';

class ProductListBloc {
  List<ProductModel> list =
      new List<ProductModel>.generate(20, (id) => ProductModel(id));

  List<ProductModel> favouriteList = [];

  //StreamCOntroller to control the list stream and Behavior Subject to listen to the stream that has already been listened
  final _listcontroller = BehaviorSubject<List<ProductModel>>();



// get the latest productlist added to the stream
  Stream<List<ProductModel>> get productListStream => _listcontroller.stream;

//adds the list to stream that is recently modifed
  StreamSink<List<ProductModel>> get productListSink => _listcontroller.sink;

 like_product => _product_liked.stream;

  ProductListBloc() {
    // initializes the list with ProductModels
    print("list not generated");
    

  


  void _updateList(List<ProductModel> list) {
    favouriteList = list;
  }
// it is important to close all the streams that have been opened so as to avoid memory leaks or breaks

  void dispose() {
    _listcontroller.close();
    
  }
}