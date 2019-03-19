import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../models/item.dart';
import '../../scoped-models/main.dart';
import '../../widgets/ui_elements/platform_progress_indicator.dart';

import '../../widgets/ui_elements/item_card.dart';

class ProductsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProductsPageState();
  }
}

class _ProductsPageState extends State<ProductsPage> {
  Widget _buildProductList() {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
     

          Future refreshProducts() {
        return model.fetchProductsRefreshed().then((_) {
          model.fetchUsers();
          model.fetchUsersPhoto();
          Fluttertoast.showToast(msg: "Products Refreshed");
        });
      }

   

        for (var x = 0; x < model.allProducts.length; x++) {
        for (var y = 0; y < model.allUsersName.length; y++) {
          if (model.allProducts[x].userId == model.allUsersName[y].id) {
            model.allProducts[x].userName = model.allUsersName[y].userName;
          }
        }
      }

      for (var x = 0; x < model.allProducts.length; x++) {
        for (var y = 0; y < model.allUsersPhoto.length; y++) {
          if (model.allProducts[x].userId == model.allUsersPhoto[y].id) {
            model.allProducts[x].userPhotoUrl = model.allUsersPhoto[y].userPhotoUrl;
          }
        }
      }

      

      Widget content = Center(child: Text('No Products Found'));
      if (model.allProducts.length > 0 && !model.isLoading) {
        content = _Products(model.allProducts);
      } else if (model.isLoading) {
        content = Center(child: PlatformProgressIndicator());
      }
      return RefreshIndicator(
        onRefresh: refreshProducts,
        child: content,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(child: _buildProductList());
  }
}

class _Products extends StatelessWidget {
  final List<Item> products;

  _Products(this.products);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        void favIconPressed(Item item) {
          model.favoriteProductStatus(item);
        }

        Widget productCard;
        if (products.length > 0) {
          productCard = ListView.builder(
            itemBuilder: (BuildContext context, int index) =>
                ItemCard(products[index], favIconPressed),
            itemCount: products.length,
          );
        }
        return productCard;
      },
    );
  }
}
