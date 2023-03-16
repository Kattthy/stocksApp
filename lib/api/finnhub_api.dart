import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:stock/models/stock.dart';

class FinnhubApi {
  static const apiKey = 'c9ie2mqad3i9bpe2gb00';
  static Future<List<String>> searchStocks({required String query}) async {
    final url = 'https://finnhub.io/api/v1/search?q=$query&token=$apiKey';
    final response = await http.get(Uri.parse(url));
    final body = json.decode(response.body)['result'];
    return body.map<String>((json) {
      final company = json['description'];
      final symbol = json['symbol'];
      return '$company, $symbol';
    }).toList();
  }
  static Future<Stock> getStock_suggestion({required String suggestion}) async {
    // suggetion: company, symbol
    final symbol_ = suggestion.split(', ')[1];
    final url_price = 'https://finnhub.io/api/v1/quote?symbol=$symbol_&token=c9ie2mqad3i9bpe2gb00';
    final url_info = 'https://finnhub.io/api/v1/stock/profile2?symbol=$symbol_&token=c9ie2mqad3i9bpe2gb00';
    final response_price = await http.get(Uri.parse(url_price));
    final price = json.decode(response_price.body);
    final response_info = await http.get(Uri.parse(url_info));
    final info = json.decode(response_info.body);
    return convert_stock(price, info);
  }
  static Future<Stock> getStock({required String symbol}) async {
    final url_price = 'https://finnhub.io/api/v1/quote?symbol=$symbol&token=c9ie2mqad3i9bpe2gb00';
    final url_info = 'https://finnhub.io/api/v1/stock/profile2?symbol=$symbol&token=c9ie2mqad3i9bpe2gb00';
    final response_price = await http.get(Uri.parse(url_price));
    final price = json.decode(response_price.body);
    final response_info = await http.get(Uri.parse(url_info));
    final info = json.decode(response_info.body);
    return convert_stock(price, info);
  }

  static Future<List<String>> getStock_list({required List<String> symbols}) async {
    // return suggestions
    List<String> result = [];
    for(var index = 0; index < symbols.length; index++) {
      String symbol = symbols[index];
      final url_info = 'https://finnhub.io/api/v1/stock/profile2?symbol=$symbol&token=c9ie2mqad3i9bpe2gb00';
      final response_info = await http.get(Uri.parse(url_info));
      final info = json.decode(response_info.body);
      result.add(info['name']+', '+info['ticker']);
    }
    return result;
  }

  static Stock convert_stock(price_json, info_json){
    final symbol = info_json['ticker'];
    final company = info_json['name'];
    final price = price_json['c'].toDouble();
    final d = price_json['d'].toDouble();
    final open = price_json['o'].toDouble();
    final low = price_json['l'].toDouble();
    final high = price_json['h'].toDouble();
    final prev = price_json['pc'].toDouble();
    final startdate = info_json['ipo'];
    final industry = info_json['finnhubIndustry'];
    final website = info_json['weburl'];
    final exchange = info_json['exchange'];
    final marketcap = info_json['marketCapitalization'].toDouble();
    /*
    print('symbol');print(symbol);print(symbol.runtimeType);
    print('company');print(company);print(company.runtimeType);
    print('price');print(price);print(price.runtimeType);
    print('d');print(d);print(d.runtimeType);
    print('open');print(open);print(open.runtimeType);
    print('low');print(low);print(low.runtimeType);
    print('prev');print(prev);print(prev.runtimeType);
    print('startdate');print(startdate);print(startdate.runtimeType);
    print('industry');print(industry);print(industry.runtimeType);
    print('website');print(website);print(website.runtimeType);
    print('exchange');print(exchange);print(exchange.runtimeType);
    print('marketcap');print(marketcap);print(marketcap.runtimeType);
    */
    return Stock(symbol:symbol, company:company, price:price, d:d, open:open, low:low, high:high, prev:prev,
                 startdate:startdate, industry:industry, website:website, exchange:exchange, marketcap: marketcap,
                 favorite:false);

  }

}
