import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import '../models/item.dart';
import './connected_items.dart';

mixin ProductsModel on ConnectedItemsModel {
  List<Item> _products = [];

  bool _showFavorite = false;

  List<Item> get allProducts {
    return List.from(_products
        .reversed); // .reversed, return data in the reversed order, from new to old.. default is old to new
  }

  List<Item> get displayFavoriteProducts {
    return _products.reversed
        .where((Item product) => product.isFavorite)
        .toList();
  }

  List<Item> get userCreatedProducts {
    return _products.reversed.where((Item product) {
      return product.userId == authenticatedUser.id;
    }).toList();
  }

  int get selectedProductIndex {
    return _products.indexWhere((Item product) {
      return product.id == selectedItemId;
    });
  }

  String get selectedProductId {
    return selectedItemId;
  }

  Item get selectedProduct {
    if (selectedProductId == null) {
      return null;
    }
    return _products.firstWhere((Item product) {
      return product.id == selectedItemId;
    });
  }

  bool get displayFavoritesOnly {
    return _showFavorite;
  }

  //future because it is not happening immediately, it takes some timeStamp(few seconds)
  //Future<Null> doesn't return any data
  Future<bool> addProduct(
      String title,
      String description,
      File image,
      File image1,
      File image2,
      File image3,
      File image4,
      String price,
      String locationAddress,
      double latitude,
      double longitude) async {
    loading = true;
    notifyListeners();
    final uploadData = await uploadImage(image);

    final uploadData1 = await uploadImage(image1).catchError((error) {});
    final uploadData2 = await uploadImage(image2).catchError((error) {});
    final uploadData3 = await uploadImage(image3).catchError((error) {});
    final uploadData4 = await uploadImage(image4).catchError((error) {});

    if (uploadData == null) {
      print('Upload failed');
      return false;
    }

    final num timeStamp = DateTime.now().millisecondsSinceEpoch;

    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'price': price,
      'imagePath': uploadData['imagePath'],
      'imageUrl': uploadData['imageUrl'],
      //if no image is selected it will assign null and it won't be part of the uploaded data to the database
      'imagePath1': uploadData1 == null ? null : uploadData1['imagePath'],
      'imageUrl1': uploadData1 == null ? null : uploadData1['imageUrl'],
      'imagePath2': uploadData2 == null ? null : uploadData2['imagePath'],
      'imageUrl2': uploadData2 == null ? null : uploadData2['imageUrl'],
      'imagePath3': uploadData3 == null ? null : uploadData3['imagePath'],
      'imageUrl3': uploadData3 == null ? null : uploadData3['imageUrl'],
      'imagePath4': uploadData4 == null ? null : uploadData4['imagePath'],
      'imageUrl4': uploadData4 == null ? null : uploadData4['imageUrl'],
      //if no image is selected it will assign null and it won't be part of the uploaded data to the database
      'locationAddress': locationAddress,
      'loc_lat': 5.596962,
      'loc_lng': -0.223282,
      'userEmail': authenticatedUser.email,
      'userId': authenticatedUser.id,
      'timePosted' : timeStamp,
    };
    try {
      final http.Response response = await http.post(
          'https://.......json', //firebase backend url /products.json
          body: json.encode(productData));

      //successful response codes are 200 and 201
      //checking if the post request is not successful
      if (response.statusCode != 200 && response.statusCode != 201) {
        loading = false;
        notifyListeners();
        return false; //if not successful
      }
      //will proceed if successful
      final Map<String, dynamic> responseData = json.decode(response.body);
      final Item newProduct = Item(
          id: responseData[
              'name'], //name, value provided by firebase //print(responseData);
          title: title,
          description: description,
          image: uploadData['imageUrl'],
          imagePath: uploadData['imagePath'],
          //
          image1: uploadData1 == null ? null : uploadData1['imageUrl'],
          imagePath1: uploadData1 == null ? null : uploadData1['imagePath'],
          image2: uploadData2 == null ? null : uploadData2['imageUrl'],
          imagePath2: uploadData2 == null ? null : uploadData2['imagePath'],
          image3: uploadData3 == null ? null : uploadData3['imageUrl'],
          imagePath3: uploadData3 == null ? null : uploadData3['imagePath'],
          image4: uploadData4 == null ? null : uploadData4['imageUrl'],
          imagePath4: uploadData4 == null ? null : uploadData4['imagePath'],
          //
          price: price,
          locationAddress: locationAddress,
          latitude: latitude,
          longitude: longitude,
          userEmail: authenticatedUser.email,
          userId: authenticatedUser.id,
          timeStamp: timeStamp);
      _products.add(newProduct);
      loading = false;
      notifyListeners();
      return true; //if successful
    } catch (error) {
      loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProduct(
      String title,
      String description,
      File image,
      File image1,
      File image2,
      File image3,
      File image4,
      String price,
      String locationAddress,
      double latitude,
      double longitude) async {
    try {
      loading = true;
      notifyListeners();

      String imageUrl = selectedProduct.image;
      String imagePath = selectedProduct.imagePath;
      //
      String imageUrl1 = selectedProduct.image1;
      String imagePath1 = selectedProduct.imagePath1;
      String imageUrl2 = selectedProduct.image2;
      String imagePath2 = selectedProduct.imagePath2;
      String imageUrl3 = selectedProduct.image3;
      String imagePath3 = selectedProduct.imagePath3;
      String imageUrl4 = selectedProduct.image4;
      String imagePath4 = selectedProduct.imagePath4;
      //
      if (image != null) {
        final uploadData = await uploadImage(image);

        imageUrl = uploadData['imageUrl'];
        imagePath = uploadData['imagePath'];
      }
      //
      if (image1 != null) {
        final uploadData1 = await uploadImage(image1).catchError((error) {});

        imageUrl1 = uploadData1['imageUrl'];
        imagePath1 = uploadData1['imagePath'];
      }
      if (image2 != null) {
        final uploadData2 = await uploadImage(image2).catchError((error) {});

        imageUrl2 = uploadData2['imageUrl'];
        imagePath2 = uploadData2['imagePath'];
      }
      if (image3 != null) {
        final uploadData3 = await uploadImage(image3).catchError((error) {});

        imageUrl3 = uploadData3['imageUrl'];
        imagePath3 = uploadData3['imagePath'];
      }
      if (image4 != null) {
        final uploadData4 = await uploadImage(image4).catchError((error) {});

        imageUrl4 = uploadData4['imageUrl'];
        imagePath4 = uploadData4['imagePath'];
      }
      //

      final Map<String, dynamic> updateData = {
        'title': title,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
        'imagePath': imagePath,
        //
        'imageUrl1': imageUrl1,
        'imagePath1': imagePath1,
        'imageUrl2': imageUrl2,
        'imagePath2': imagePath2,
        'imageUrl3': imageUrl3,
        'imagePath3': imagePath3,
        'imageUrl4': imageUrl4,
        'imagePath4': imagePath4,
        //
        'locationAddress': locationAddress,
        'loc_lat': 5.596962,
        'loc_lng': -0.223282,
        'userEmail': selectedProduct.userEmail,
        'userId': selectedProduct.userId,
        'timePosted': selectedProduct.timeStamp
      };
      //put is used to update existing record
      try {
        await http.put(
            'https://....../${selectedProduct.id}.json',
            body: json.encode(updateData));
        loading = false;
        final Item updatedProduct = Item(
            id: selectedProduct.id,
            title: title,
            description: description,
            image: imageUrl,
            imagePath: imagePath,
            //
            image1: imageUrl1,
            imagePath1: imagePath1,
            image2: imageUrl2,
            imagePath2: imagePath2,
            image3: imageUrl3,
            imagePath3: imagePath3,
            image4: imageUrl4,
            imagePath4: imagePath4,
            //
            price: price,
            locationAddress: locationAddress,
            latitude: latitude,
            longitude: longitude,
            userEmail: selectedProduct.userEmail,
            userId: selectedProduct.userId,
            timeStamp: selectedProduct.timeStamp);
        _products[selectedProductIndex] = updatedProduct;
        notifyListeners();
        return true; //if successful
      } catch (error) {
        loading = false;
        notifyListeners();
        return false; //if not successful
      }
    } catch (error) {
      return null;
    }
  }

  Future<bool> deleteProduct() {
    try {
      loading = true;
      String deletedProductId = selectedProduct.id;
      _products.removeAt(selectedProductIndex);
      notifyListeners();
      selectedItemId = null; //no product selected

      return http
          .delete(
              'https://..../$deletedProductId.json')
          .then((http.Response response) {
        Fluttertoast.showToast(msg: "Product Deleted");

        loading = false;
        notifyListeners();
        return true; //if successful
      }).catchError(
        (error) {
          loading = false;
          notifyListeners();
          return false; //if not successful
        },
      );
    } catch (error) {
      return null;
    }
  }

  Future<bool> deleteProductImage(String imagepath) {
    try {
      return http
          .delete(
              'https://....../${selectedProduct.id}/$imagepath.json')
          .then((http.Response response) {
        Fluttertoast.showToast(msg: "Image Deleted");
        return true; //if successful
      }).catchError(
        (error) {
          return false; //if not successful
        },
      );
    } catch (error) {
      return null;
    }
  }

  //fetching data from the server
  Future<Null> fetchProducts() {
    loading = true;
    notifyListeners();
    return http
        .get('https://.......json')
        .then<Null>((http.Response response) {
      final List<Item> fetchedProductList = [];
      final Map<String, dynamic> productListData = json.decode(response.body);
      if (productListData == null) {
        loading = false;
        notifyListeners();
        return;
      }
      productListData.forEach((String productId, dynamic productData) {
        final Item product = Item(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            image: productData['imageUrl'],
            imagePath: productData['imagePath'],
            //
            image1: productData['imageUrl1'],
            imagePath1: productData['imagePath1'],
            image2: productData['imageUrl2'],
            imagePath2: productData['imagePath2'],
            image3: productData['imageUrl3'],
            imagePath3: productData['imagePath3'],
            image4: productData['imageUrl4'],
            imagePath4: productData['imagePath4'],
            //
            price: productData['price'],
            locationAddress: productData['locationAddress'],
            latitude: productData['latitude'],
            longitude: productData['longitude'],
            userEmail: productData['userEmail'],
            userId: productData['userId'],
            timeStamp: productData['timePosted'],
            isFavorite: productData['wishlistUsers'] == null
                ? false
                : (productData['wishlistUsers'] as Map<String, dynamic>)
                    .containsKey(authenticatedUser.id));
        fetchedProductList.add(product);
      });
      _products = fetchedProductList;
      loading = false;
      notifyListeners();
    }).catchError((error) {
      loading = false;
      notifyListeners();
      return;
    });
  }

  Future<Null> fetchProductsRefreshed() {
    return http
        .get('https://.......json')
        .then<Null>((http.Response response) {
      final List<Item> fetchedProductList = [];
      final Map<String, dynamic> productListData = json.decode(response.body);
      if (productListData == null) {
        return;
      }
      productListData.forEach((String productId, dynamic productData) {
        final Item product = Item(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            image: productData['imageUrl'],
            imagePath: productData['imagePath'],
            //
            image1: productData['imageUrl1'],
            imagePath1: productData['imagePath1'],
            image2: productData['imageUrl2'],
            imagePath2: productData['imagePath2'],
            image3: productData['imageUrl3'],
            imagePath3: productData['imagePath3'],
            image4: productData['imageUrl4'],
            imagePath4: productData['imagePath4'],
            //
            price: productData['price'],
            locationAddress: productData['locationAddress'],
            latitude: productData['latitude'],
            longitude: productData['longitude'],
            userEmail: productData['userEmail'],
            userId: productData['userId'],
            timeStamp: productData['timePosted'],
            isFavorite: productData['wishlistUsers'] == null
                ? false
                : (productData['wishlistUsers'] as Map<String, dynamic>)
                    .containsKey(authenticatedUser.id));
        fetchedProductList.add(product);
      });
      _products = fetchedProductList;
      notifyListeners();
    }).catchError((error) {
      return;
    });
  }

  void favoriteProductStatus(Item toggledProduct) async {
    try {
      final bool isCurrentlyFavorite = toggledProduct.isFavorite;
      final bool newFavoriteStatus = !isCurrentlyFavorite;
      // Get the index of the product passed into the method
      final int toggledProductIndex = _products.indexWhere((Item product) {
        return product.id == toggledProduct.id;
      });
      final Item updatedProduct = Item(
          id: toggledProduct.id,
          title: toggledProduct.title,
          description: toggledProduct.description,
          price: toggledProduct.price,
          image: toggledProduct.image,
          imagePath: toggledProduct.imagePath,
          //
          image1: toggledProduct.image1,
          imagePath1: toggledProduct.imagePath1,
          image2: toggledProduct.image2,
          imagePath2: toggledProduct.imagePath2,
          image3: toggledProduct.image3,
          imagePath3: toggledProduct.imagePath3,
          image4: toggledProduct.image4,
          imagePath4: toggledProduct.imagePath4,
          //
          locationAddress: toggledProduct.locationAddress,
          latitude: toggledProduct.latitude,
          longitude: toggledProduct.longitude,
          userEmail: toggledProduct.userEmail,
          userId: toggledProduct.userId,
          timeStamp: toggledProduct.timeStamp,
          isFavorite: newFavoriteStatus);
      _products[toggledProductIndex] = updatedProduct;
      notifyListeners(); //updates the state, re-renders the app visually
      http.Response response;
      if (newFavoriteStatus) {
        response = await http.put(
            'https://......./${toggledProduct.id}/wishlistUsers/${authenticatedUser.id}.json',
            body: json.encode(true));
      } else {
        response = await http.delete(
            'https://......./${toggledProduct.id}/wishlistUsers/${authenticatedUser.id}.json');
      }
      if (response.statusCode != 200 && response.statusCode != 201) {
        final Item updatedProduct = Item(
            id: toggledProduct.id,
            title: toggledProduct.title,
            description: toggledProduct.description,
            price: toggledProduct.price,
            image: toggledProduct.image,
            imagePath: toggledProduct.imagePath,
            //
            image1: toggledProduct.image1,
            imagePath1: toggledProduct.imagePath1,
            image2: toggledProduct.image2,
            imagePath2: toggledProduct.imagePath2,
            image3: toggledProduct.image3,
            imagePath3: toggledProduct.imagePath3,
            image4: toggledProduct.image4,
            imagePath4: toggledProduct.imagePath4,
            //
            locationAddress: toggledProduct.locationAddress,
            latitude: toggledProduct.latitude,
            longitude: toggledProduct.longitude,
            userEmail: toggledProduct.userEmail,
            userId: toggledProduct.userId,
            timeStamp: toggledProduct.timeStamp,
            isFavorite: !newFavoriteStatus);
        _products[toggledProductIndex] = updatedProduct;
        notifyListeners(); //updates the state, re-renders the app visually

      }
    } catch (error) {
      //print(error);
    }
  }

  void toggleProductDisplayMode() {
    _showFavorite = !_showFavorite;
    notifyListeners();
  }
}
