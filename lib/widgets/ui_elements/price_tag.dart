import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PriceTag extends StatelessWidget {
  final String price;

  PriceTag(this.price);

  @override
  Widget build(BuildContext context) {
    var f = new NumberFormat("###,###.0#", "en_US");
    var formatedPrice = f.format(int.parse(price));

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.5),
      child: Text(
        'GH₵ ' + formatedPrice.toString(),
        softWrap: true,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
