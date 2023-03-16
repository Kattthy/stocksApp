class Stock {
  final String symbol;
  final String? company;
  final double? price;
  Stock({required this.symbol, this.company, this.price});
  static List<Stock> getAll() {
    List<Stock> stocks = <Stock>[];
    stocks.add(Stock(company:"Apple Computers",symbol:"APPLE",price:258));
    stocks.add(Stock(company:"Microsoft",symbol:"MSOFT",price:400));
    return stocks;
  }
}