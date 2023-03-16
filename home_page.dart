import 'package:flutter/material.dart';

import '../models/stock.dart';
import '../widgets/stock_list.dart';

class Home_Page extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar:AppBar(
        title: Text("Stocks"),
        backgroundColor: Colors.purple,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(children: <Widget>[
        Container(
          padding: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          color: Colors.black,
          child: SafeArea(
              child:Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text("STOCK WATCH",
                        textAlign:TextAlign.right,
                        style:TextStyle(color:Colors.white,
                            fontWeight:FontWeight.bold,
                            fontSize:32)),
                ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text("April 23",
                          textAlign:TextAlign.right,
                          style:TextStyle(color:Colors.white,
                              fontWeight:FontWeight.bold,
                              fontSize:32)),
                ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child:Text("Favorites",
                          textAlign:TextAlign.left,
                          style:TextStyle(color:Colors.white,
                              fontSize:25))
                    )]),
              Divider(color: Colors.white, thickness:2),
              SizedBox(
                height: MediaQuery.of(context).size.height - 500,
                child:Stock_List(stocks: Stock.getAll())
              )
                //Stock_List(stocks: Stock.getAll())
          ])
          )
        )
      ])

    );

  }
}