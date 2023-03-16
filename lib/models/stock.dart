class Stock {
  final String symbol;
  final String company;
  double price;
  double d; // change
  double open;
  double low;
  double high;
  double prev;
  final String startdate;
  final String industry;
  final String website;
  final String exchange;
  final double marketcap;
  bool favorite;
  Stock({required this.symbol, required this.company, required this.price, required this.d,
        required this.open, required this.low, required this.high, required this.prev,
        required this.startdate, required this.industry, required this.website,
        required this.exchange, required this.marketcap, required this.favorite});
  void set_favorite(){
    this.favorite = true;
  }
  void cancel_favorite(){
    this.favorite = false;
  }
  //bool? get isEmpty => null;
  static List<Stock> getAll() {
    List<Stock> stocks = <Stock>[];
    //stocks.add(Stock(company:"Apple Computers",symbol:"APPLE"));
    //stocks.add(Stock(company:"Microsoft",symbol:"MSOFT"));
    return stocks;
  }
}