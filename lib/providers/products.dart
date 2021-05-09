import 'dart:convert';
import 'package:Shop_App/models/http_exception.dart';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

import './product.dart';

class Products with ChangeNotifier {
  final String authToken;

  final String userId;

  Products(this.authToken, this._items, this.userId);
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://contents.mediadecathlon.com/p1801131/k\$2200827453693d21bdb02658cd88cf38/men-s-travel-trekking-trousers-travel-100-khaki.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Hat',
    //   description: 'A good Hat',
    //   price: 29.99,
    //   imageUrl:
    //       'https://images-na.ssl-images-amazon.com/images/I/61o1NRcxDhL._UX679_.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'Pan',
    //   description: 'Prepare your Meal',
    //   price: 49.99,
    //   imageUrl:
    //       'https://5.imimg.com/data5/RD/WX/MY-16236155/die-cast-frying-pan-500x500.jpg',
    // ),
  ];

  List<Product> get items {
    //this _items is reference types so if_items is changed
    // then main products item is changed

    // if (_showFavouritesOnly) {
    //filter only favourites
    //   return _items.where((prodItem) => prodItem.isFavourite).toList();
    // }
    return [..._items];
  }

  List<Product> get favouriteItems {
    return _items.where((prodItem) => prodItem.isFavourite).toList();
  }

  Product findById(String id) {
    return items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';

    var url =
        'https://shop-app-6986c-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString';

    try {
      final response = await http.get(url);
      // print(response.body);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData == null) {
        return;
      }
      url =
          "https://shop-app-6986c-default-rtdb.firebaseio.com/userFavourites/$userId.json?auth=$authToken";
      final favResponse = await http.get(url);
      final favData = json.decode(favResponse.body);

      final List<Product> loadedProducts = [];

      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          isFavourite: favData == null ? false : favData[prodId] ?? false,
        ));
      });

      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product prod) async {
    final url =
        "https://shop-app-6986c-default-rtdb.firebaseio.com/products.json?auth=$authToken";
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': prod.title,
          'description': prod.description,
          'imageUrl': prod.imageUrl,
          'price': prod.price,
          'creatorId': userId,
        }),
      );

      // _items.add(value);
      final newProd = Product(
        title: prod.title,
        price: prod.price,
        description: prod.description,
        imageUrl: prod.imageUrl,
        id: json.decode(response.body)['name'],
      );
      // _items.add(newProd);
      _items.insert(0, newProd);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProducts(String id, Product newProd) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);

    if (prodIndex >= 0) {
      final url =
          "https://shop-app-6986c-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken";

      await http.patch(url,
          body: json.encode({
            'title': newProd.title,
            'description': newProd.description,
            'imageUrl': newProd.imageUrl,
            'price': newProd.price,
          }));
      _items[prodIndex] = newProd;
      notifyListeners();
    } else {}
  }

  Future<void> deleteProduct(String id) async {
    final url =
        "https://shop-app-6986c-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken";

    final exisitingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[exisitingProductIndex];
    _items.removeAt(exisitingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    // print(response.statusCode);
    if (response.statusCode >= 400) {
      _items.insert(exisitingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException("Could not delete the product !!");
    }
    existingProduct = null;
  }
}
