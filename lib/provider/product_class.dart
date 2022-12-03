class Product {
  String name;
  double price;
  int qty = 1;
  int qntty;
  List imageUrl;
  String documentid;
  String suppid;

  Product({
    required this.name,
    required this.price,
    required this.qntty,
    required this.qty,
    required this.imageUrl,
    required this.documentid,
    required this.suppid,
  });

  void increase() {
    qty++;
  }

  void decrease() {
    qty--;
  }
}
