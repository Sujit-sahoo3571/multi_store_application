import 'package:flutter/foundation.dart';
import 'product_class.dart';

class Cart extends ChangeNotifier {
  final List<Product> _list = [];
  List<Product> get getItems => _list;
  int? get count => _list.length;

  void addItems(
    String name,
    double price,
    int qty,
    int qntty,
    List imageUrl,
    String documentid,
    String suppid,
  ) {
    final product = Product(
        name: name,
        price: price,
        qntty: qntty,
        qty: qty,
        imageUrl: imageUrl,
        documentid: documentid,
        suppid: suppid);

    _list.add(product);
    notifyListeners();
  }

  void increment(Product product) {
    product.increase();
    notifyListeners();
  }

  void reduceByOne(Product product) {
    product.decrease();
    notifyListeners();
  }

  void removeItem(Product product) {
    _list.remove(product);
    notifyListeners();
  }

  void clearCart() {
    _list.clear();
    notifyListeners();
  }

  double get totalPrice {
    double total = 0.0;
    for (var item in _list) {
      total += item.price * item.qty;
    }
    return total;
  }
}
