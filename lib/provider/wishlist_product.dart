import 'package:flutter/foundation.dart';
import 'product_class.dart';

class Wish extends ChangeNotifier {
  final List<Product> _list = [];
  List<Product> get getwishItems => _list;
  int? get count => _list.length;

  void addWishItems(
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

  void removeItem(Product product) {
    _list.remove(product);
    notifyListeners();
  }

  void clearWishList() {
    _list.clear();
    notifyListeners();
  }

  void removeThis(String id) {
    _list.removeWhere((element) => element.documentid == id);
    notifyListeners();
  }
}
