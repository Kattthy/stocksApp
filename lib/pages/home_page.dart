import 'package:flutter/material.dart';
import 'package:stock/api/finnhub_api.dart';
import '../models/stock.dart';
import '../widgets/stock_list.dart';
import 'package:url_launcher/url_launcher.dart';

List<String> fav_list = [];

class Home_Page extends StatefulWidget{
  @override
  _Home_PageState createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page>{
  @override
  void initState() {
    //refresh the page here
    super.initState();
  }

  @override
  Widget buildFavList(BuildContext context) =>
      FutureBuilder<List<String>>(
        // query is needed to be process
          //future: FinnhubApi.getStock_list(symbols: fav_list),
          future: FinnhubApi.getStock_list(symbols: fav_list),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(Colors.purple)));
              default:
                if (snapshot.hasError || snapshot.data == null || snapshot.data == []) {
                  return Container(
                      color: Colors.black,
                      alignment: Alignment.center,
                      child: Column(
                        children:[
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                          ),
                          Text('Empty', style: TextStyle(fontSize: 26, color: Colors.white,fontWeight:FontWeight.bold))],
                      )
                  );
                }
                else {
                  print(snapshot.data);
                  return buildFavListSuccess(snapshot.data);
                }
            }
          }
      );

  @override
  Widget buildFavListSuccess(List<String>? fav_suggestions){
    if(fav_suggestions!.length == 0){
      return Container(
        color: Colors.black,
        alignment: Alignment.center,
        child: Column(
                children:[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                  ),
                  Text('Empty', style: TextStyle(fontSize: 26, color: Colors.white,fontWeight:FontWeight.bold))],
                )
      );
    }
    return ListView.separated(
        itemBuilder: (context, index){
          final stock_info = fav_suggestions![index].split(', ');
          final symbol = stock_info[1];
          final company = stock_info[0];
          return Dismissible(
            key: Key(symbol),
              confirmDismiss: (DismissDirection direction) async {
                return await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Delete Confirmation",style:TextStyle(color:Colors.white)),
                      content: const Text("Are you sure you want to delete this item?",style:TextStyle(color:Colors.white)),
                      backgroundColor: Colors.grey[850],
                      actions: <Widget>[
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text("Delete",style:TextStyle(color:Colors.white))
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text("Cancel",style:TextStyle(color:Colors.white)),
                        ),
                      ],
                    );
                  },
                );
              },
            onDismissed: (direction) {
                // Remove the item from the data source.
                setState(() {
                  fav_list.remove(symbol);
                });
                // Then show a snackbar.
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(backgroundColor:Colors.white,content: Text(
                    '$symbol was removed from watchlist',style:TextStyle(color:Colors.black))));
              },
              // Show a red background as the item is swiped away.
              background: Container(color: Colors.red, child:Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children:[Icon(Icons.delete,color:Colors.white)]
              )),
            child:ListTile(
                contentPadding: EdgeInsets.all(5),
                title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:<Widget>[
                      Text("${symbol}",style:TextStyle(color: Colors.white, fontSize:16,
                          fontWeight:FontWeight.w500)),
                      Text("${company}",style:TextStyle(color: Colors.white, fontSize:12,
                          fontWeight:FontWeight.w500)),
                    ]),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder:(context)=>ResultPage(suggestion:fav_suggestions![index],result_stock:null)));
                }
            )
          );
          /*
            ListTile(
              contentPadding: EdgeInsets.all(10),
              title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:<Widget>[
                    Text("${symbol}",style:TextStyle(color: Colors.white, fontSize:20,
                        fontWeight:FontWeight.w500)),
                    Text("${company}",style:TextStyle(color: Colors.white, fontSize:14,
                        fontWeight:FontWeight.w500)),
                  ]),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder:(context)=>ResultPage(suggestion:fav_suggestions![index],result_stock:null)));
              }
          );*/
        },
        separatorBuilder: (context, index){
          return Divider(color: Colors.white, thickness:2);
        },
        itemCount: fav_suggestions!.length);
  }


  @override
  Widget build(BuildContext context){
    //List<Stock> fav_stocks = get_fav_stocks(fav_list);
    return Scaffold(
      appBar:AppBar(
        title: Text("Stock"),
        backgroundColor: Colors.purple,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              showSearch(context:context, delegate:stock_search());
            },
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
                    Text("STOCK WATCH ",
                        textAlign:TextAlign.right,
                        style:TextStyle(color:Colors.white,
                            fontWeight:FontWeight.bold,
                            fontSize:25)),
                ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(get_date(),
                          textAlign:TextAlign.right,
                          style:TextStyle(color:Colors.white,
                              fontWeight:FontWeight.bold,
                              fontSize:25)),
                ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child:Text("Favorites",
                          textAlign:TextAlign.left,
                          style:TextStyle(color:Colors.white,
                              fontSize:22))
                    )]),
              Divider(color: Colors.white, thickness:2),
              SizedBox(
                height: MediaQuery.of(context).size.height - 350,
                child:buildFavList(context),
              )
                //Stock_List(stocks: Stock.getAll())
          ])
          )
        )
      ])

    );

  }

  @override
  String get_date(){
    var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
    DateTime now = DateTime.now();
    return months[now.month-1]+" "+now.day.toString()+" ";
  }
}
class ResultPage extends StatefulWidget {
  final String suggestion;
  Stock? result_stock;
  ResultPage({required this.suggestion, required this.result_stock});

  @override
  _ResultPageState createState() => _ResultPageState(suggestion:suggestion,result_stock:result_stock);
}
class _ResultPageState extends State<ResultPage>{
  final String suggestion;
  Stock? result_stock;

  _ResultPageState({required this.suggestion, required this.result_stock});
  bool a = false;
  @override
  Widget stock_p_widget(Stock? stock){
    final d = stock!.d;
    if(d > 0){
      return Text('+'+stock.d.toString(),
          style: TextStyle(
            fontSize: 25,
            color: Colors.green,
          ));
    }
    else if(d == 0){
      return Text(stock.d.toString(),
          style: TextStyle(
            fontSize: 25,
            color: Colors.white70,
          ));
    }
    else{
      return Text(stock.d.toString(),
          style: TextStyle(
            fontSize: 25,
            color: Colors.red,
          ));
    }
  }


  @override
  Widget buildResults(BuildContext context) =>
      FutureBuilder<Stock>(
        // query is needed to be process
          future: FinnhubApi.getStock_suggestion(suggestion: suggestion),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(Colors.purple)));
              default:
                if (snapshot.hasError || snapshot.data == null) {
                  return new Scaffold(
                      appBar: AppBar(
                          title:Text('Details'),
                          backgroundColor: Colors.black54,
                          leading: new IconButton (
                              icon: new Icon(Icons.arrow_back_ios),
                              onPressed: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(builder: (BuildContext context) => new Home_Page()),
                                        (route)=>route == null
                                );
                              }
                          ),
                          actions: <Widget>[
                            IconButton(
                              icon: Icon(Icons.star_border_outlined, color: Colors.white),
                              onPressed: () {},
                            )]
                      ),
                      body: Stack(children: <Widget>[
                        Container(
                          //padding: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width,
                            color: Colors.black,
                            child: SafeArea(
                                child:  Container(
                                  color: Colors.black,
                                  alignment: Alignment.center,
                                  child: Text('Failed to fetch stock data',
                                      style: TextStyle(fontSize: 28, color: Colors.white)),
                                )
                            )
                        )
                      ])
                  );
                  /*
                  return Container(
                    color: Colors.black,
                    alignment: Alignment.center,
                    child: Text('Failed to fetch stock data',
                        style: TextStyle(fontSize: 28, color: Colors.white)),
                  );*/
                }
                else {
                  //bool now_favorite = snapshot.data!.favorite;
                  a = fav_list.contains(snapshot.data!.symbol);
                  return new Scaffold(
                      appBar: AppBar(
                          title:Text('Details'),
                          backgroundColor: Colors.black54,
                          leading: new IconButton (
                            icon: new Icon(Icons.arrow_back_ios),
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (BuildContext context) => new Home_Page()),
                                      (route)=>route == null
                              );
                            }
                          ),
                          actions: <Widget>[
                            IconButton(
                              //icon: Icon(snapshot.data!.favorite ? Icons.star:Icons.star_border_outlined, color: Colors.white),
                              icon: Icon(a ? Icons.star : Icons.star_border_outlined, color: Colors.white),
                              onPressed: () {
                                // TODO: Favorite
                                setState(() {
                                  a = !a;
                                  if(a == true){
                                    fav_list.add(snapshot.data!.symbol);
                                    String symbol = snapshot.data!.symbol;
                                    if (symbol != null){
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(backgroundColor:Colors.white,content: Text('$symbol was added to watchlist',style:TextStyle(color:Colors.black))));
                                    }
                                  }
                                  else{
                                    fav_list.remove(snapshot.data!.symbol);
                                    String symbol = snapshot.data!.symbol;
                                    if (symbol != null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(backgroundColor:Colors.white,content: Text(
                                          '$symbol was removed from watchlist',style:TextStyle(color:Colors.black))));
                                    }

                                  }

                                  //snapshot.data!.favorite = !snapshot.data!.favorite;
                                  //print(snapshot.data!.favorite);
                                });
                                /*
                                print(snapshot.data!.symbol);
                                print(snapshot.data!.favorite);
                                //snapshot.data!.favorite != !snapshot.data!.favorite;
                                if (a == true) {
                                  a = false;
                                  fav_list.add(snapshot.data!);
                                }
                                else if (a == false) {
                                  a = true;
                                  fav_list.remove(snapshot.data!);
                                }*/
                              },


                            )]
                      ),
                      body: Stack(children: <Widget>[
                        Container(
                          //padding: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width,
                            color: Colors.black,
                            child: SafeArea(
                                child: buildResultSuccess(snapshot.data)
                            )
                        )
                      ])
                  );
                  //return buildResultSuccess(snapshot.data);

                }
            }
          }
      );

  @override
  Widget buildResultSuccess(Stock? stock){
    return Container(
      color: Colors.black,
      child: ListView(
        padding: EdgeInsets.all(25),
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                Text(stock!.symbol+'  ',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                  ),),
                Text(stock.company,
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white70,
                  ),
                ),
              ]
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                Text(stock!.price.toString()+'  ',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                  ),),
                stock_p_widget(stock),
              ]
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                Text('Stats',style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                ))
              ]
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:[
                Column(
                    children:[
                      Text('Open',style:TextStyle(color:Colors.white, fontSize:20)),
                      Text('Low',style:TextStyle(color:Colors.white, fontSize:20)),
                    ]
                ),
                Column(
                    children:[
                      Text(stock.open.toString(),style:TextStyle(color:Colors.white70, fontSize:18)),
                      Text(stock.low.toString(),style:TextStyle(color:Colors.white70, fontSize:18)),
                    ]
                ),
                Column(
                    children:[
                      Text('High',style:TextStyle(color:Colors.white, fontSize:20)),
                      Text('Prev',style:TextStyle(color:Colors.white, fontSize:20)),
                    ]
                ),
                Column(
                    children:[
                      Text(stock.high.toString(),style:TextStyle(color:Colors.white70, fontSize:18)),
                      Text(stock.prev.toString(),style:TextStyle(color:Colors.white70, fontSize:18)),
                    ]
                )
              ]
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                Text('About',style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                ))
              ]
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:[
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      Text('Start date',style:TextStyle(color:Colors.white, fontSize:14)),
                      Text('Industry',style:TextStyle(color:Colors.white, fontSize:14)),
                      Text('Website',style:TextStyle(color:Colors.white, fontSize:14)),
                      Text('Exchange',style:TextStyle(color:Colors.white, fontSize:14)),
                      Text('Market Cap',style:TextStyle(color:Colors.white, fontSize:14)),
                    ]
                ),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      Text(stock.startdate,style:TextStyle(color:Colors.white70, fontSize:14)),
                      Text(stock.industry,style:TextStyle(color:Colors.white70, fontSize:14)),
                      //Text(stock.website,style:TextStyle(color:Colors.blue, fontSize:15)),
                      InkWell(
                        child:Text(stock.website,style:TextStyle(color:Colors.blue, fontSize:14)),
                        onTap: () => launch(stock.website)
                      ),
                      Text(stock.exchange,style:TextStyle(color:Colors.white70, fontSize:14)),
                      Text(stock.marketcap.toString(),style:TextStyle(color:Colors.white70, fontSize:14)),
                    ]
                )
              ]
          )
        ],
      ),
    );
  }
  @override
  Widget fav_icon(Stock? stock) {
    if(stock == null){
      print('null');
      return IconButton(
        icon: Icon(Icons.star_border_outlined, color: Colors.white),
        onPressed: () {},
      );
    }
    else if(stock!.favorite == false){
      print('false');
      print(stock!.symbol);
      print(stock!.favorite);
      return IconButton(
        icon: Icon(stock!.favorite?Icons.star:Icons.star_border_outlined, color: Colors.white),
        onPressed: () {
          // TODO: Favorite
          stock!.favorite=true;
          fav_list.add(stock!.symbol);
          print(stock!.favorite);
        },
      );
    }
    else{
      return IconButton(
        icon: Icon(stock!.favorite?Icons.star:Icons.star_border_outlined, color: Colors.white),
        onPressed: () {
          // TODO: Favorite
          fav_list.remove(stock);
          stock!.favorite=false;
        },
      );
    }
  }
  @override
  Widget build(BuildContext context){
    return buildResults(context);
    /*
    return new Scaffold(
      appBar: AppBar(
        title:Text('Details'),
        backgroundColor: Colors.black54,
        actions: <Widget>[
          fav_icon()]
      ),
      body: Stack(children: <Widget>[
        Container(
          //padding: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          color: Colors.black,
          child: SafeArea(
            child: buildResults(context);
          )
        )
      ])
    );*/
  }

  
}



class stock_search extends SearchDelegate<String> {
  final stocks = [
    'Amazon',
    'Facebook',
    'Microsoft',
    'Google',
    'Netflix',
    'Amazon2'
  ];
  final recentStocks = [
    'Amazon',
    'Facebook',
    'Microsoft',
  ];
  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Colors.purple, //thereby
      ),
      textTheme: TextTheme(
        headline6: TextStyle(fontSize: 24.0, color: Colors.white),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.black54,

      ),
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: TextStyle(fontSize: 24.0, color: Colors.grey),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) =>
      [
        IconButton(
          icon: Icon(Icons.clear, color: Colors.grey),
          onPressed: () {
            if (query.isEmpty) {
              close(context, '');
            }
            else {
              query = '';
              showSuggestions(context);
            }
          },
        )
      ];

  @override
  Widget buildLeading(BuildContext context) =>
      IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Colors.grey),
        onPressed: () => close(context, ''),
        //onPressed: () => Navigator.pop(context, true),
      );

  @override
  Widget buildResults(BuildContext context) =>
      FutureBuilder<Stock>(
          // query is needed to be process
          future: FinnhubApi.getStock_suggestion(suggestion: query),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(Colors.purple)));
              default:
                if (snapshot.hasError || snapshot.data == null) {
                  return Container(
                    color: Colors.black,
                    alignment: Alignment.center,
                    child: Text('Failed to fetch stock data',
                        style: TextStyle(fontSize: 28, color: Colors.white)),
                  );
                }
                else {
                  return buildResultSuccess(snapshot.data);
                }
            }
          }
      );

  @override
  Widget buildSuggestions(BuildContext context) =>
      Container(
        color: Colors.black,
        child: FutureBuilder<List<String>>(
          future: FinnhubApi.searchStocks(query: query),
          builder: (context, snapshot) {
            if (query.isEmpty) return buildNoSuggestions();
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(Colors.purple)));
              default:
                if (snapshot.hasError || snapshot.data == null) {
                  return buildNoSuggestions();
                } else {
                  //print(snapshot.data);
                  return buildSuggestionsSuccess(snapshot.data);
                }
            }
          },
        ),
      );

  Widget buildNoSuggestions() =>
      Center(
        child: Text(
          'No suggestions found!',
          style: TextStyle(fontSize: 28, color: Colors.white),
        ),
      );


  Widget buildSuggestionsSuccess(List<String>? suggestions) =>
      ListView.builder(
        itemCount: suggestions!.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          final suggestion_ = suggestion.split(', ');
          final company = ' | '+suggestion_[0];
          final symbol = suggestion_[1];
          return ListTile(
            onTap: () {
              query = suggestion;
              // 1. Show Results
              //showResults(context);

              // 2. Close Search & Return Result
              // close(context, suggestion);

              // 3. Navigate to Result Page
              Navigator.push(
                 context,
                 MaterialPageRoute(
                   builder: (BuildContext context) => new ResultPage(suggestion:suggestion,result_stock:null),
                 ),
              );
            },
            // title: Text(suggestion),
            title: RichText(
              text: TextSpan(
                text: symbol,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: [
                  TextSpan(
                    text: company,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
  Widget stock_p_widget(Stock? stock){
    final d = stock!.d;
    if(d > 0){
      return Text('+'+stock.d.toString(),
          style: TextStyle(
            fontSize: 27,
            color: Colors.green,
          ));
    }
    else if(d == 0){
        return Text(stock.d.toString(),
            style: TextStyle(
            fontSize: 27,
            color: Colors.white70,
        ));
    }
    else{
      return Text(stock.d.toString(),
          style: TextStyle(
            fontSize: 27,
            color: Colors.red,
          ));
    }
  }
  Widget buildResultSuccess(Stock? stock){
      return Container(
        color: Colors.black,
        child: ListView(
          padding: EdgeInsets.all(25),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                Text(stock!.symbol+'  ',
                  style: TextStyle(
                    fontSize: 27,
                    color: Colors.white,
                  ),),
                Text(stock.company,
                  style: TextStyle(
                    fontSize: 27,
                    color: Colors.white70,
                  ),
                ),
              ]
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  Text(stock!.price.toString()+'  ',
                    style: TextStyle(
                      fontSize: 27,
                      color: Colors.white,
                    ),),
                  stock_p_widget(stock),
                ]
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  Text('Stats',style: TextStyle(
                    fontSize: 27,
                    color: Colors.white,
                  ))
                ]
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:[
                Column(
                  children:[
                    Text('Open',style:TextStyle(color:Colors.white, fontSize:23)),
                    Text('Low',style:TextStyle(color:Colors.white, fontSize:23)),
                  ]
                ),
                Column(
                    children:[
                      Text(stock.open.toString(),style:TextStyle(color:Colors.white70, fontSize:22)),
                      Text(stock.low.toString(),style:TextStyle(color:Colors.white70, fontSize:22)),
                    ]
                ),
                Column(
                    children:[
                      Text('High',style:TextStyle(color:Colors.white, fontSize:23)),
                      Text('Prev',style:TextStyle(color:Colors.white, fontSize:23)),
                    ]
                ),
                Column(
                    children:[
                      Text(stock.high.toString(),style:TextStyle(color:Colors.white70, fontSize:22)),
                      Text(stock.prev.toString(),style:TextStyle(color:Colors.white70, fontSize:22)),
                    ]
                )
              ]
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  Text('About',style: TextStyle(
                    fontSize: 27,
                    color: Colors.white,
                  ))
                ]
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
            ),
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  Text('Start date',style:TextStyle(color:Colors.white, fontSize:15)),
                  Text('Industry',style:TextStyle(color:Colors.white, fontSize:15)),
                  Text('Website',style:TextStyle(color:Colors.white, fontSize:15)),
                  Text('Exchange',style:TextStyle(color:Colors.white, fontSize:15)),
                  Text('Market Cap',style:TextStyle(color:Colors.white, fontSize:15)),
                ]
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  Text(stock.startdate,style:TextStyle(color:Colors.white70, fontSize:15)),
                  Text(stock.industry,style:TextStyle(color:Colors.white70, fontSize:15)),
                  Text(stock.website,style:TextStyle(color:Colors.blue, fontSize:15)),
                  Text(stock.exchange,style:TextStyle(color:Colors.white70, fontSize:15)),
                  Text(stock.marketcap.toString(),style:TextStyle(color:Colors.white70, fontSize:15)),
                ]
              )
            ]
            )
           ],
        ),
      );
}
}
