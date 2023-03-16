import 'package:flutter/material.dart';
import 'package:stock/models/stock.dart';

class Stock_List extends StatelessWidget {

  final List<Stock> stocks;

  Stock_List({required this.stocks});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (Context, index){
          final stock = stocks[index];
          return ListTile(
              contentPadding: EdgeInsets.all(10),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children:<Widget>[
                Text("${stock.symbol}",style:TextStyle(color: Colors.white, fontSize:20,
                    fontWeight:FontWeight.w500)),
                Text("${stock.company}",style:TextStyle(color: Colors.white, fontSize:14,
                    fontWeight:FontWeight.w500)),
              ])
          );
        },
        separatorBuilder: (context, index){
          return Divider(color: Colors.white, thickness:2);
        },
        itemCount: stocks.length);
  }
}

