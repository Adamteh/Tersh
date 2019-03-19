import 'package:flutter/material.dart';

import '../../../models/item.dart';

class PicViewPage extends StatelessWidget {
  final Item item;

  PicViewPage(this.item);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(item.title),
      ),
      body: Scrollbar(
        child: PageView(
          children: <Widget>[
            Hero(
              tag: item.id,
              child: Container(
                color: Colors.black,
                child: FadeInImage(
                  image: NetworkImage(item.image, scale: 2 / 5),
                  fadeInDuration: Duration(milliseconds: 380),
                  fadeOutDuration: Duration(seconds: 0),
                  placeholder: AssetImage('assets/placeholderimage.png'),
                ),
              ),
            ),
            Container(
              color: Colors.black,
              child: item.image1 == null
                  ? Center(
                      child: Text(
                        'No Image',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    )
                  : FadeInImage(
                      image: NetworkImage(item.image1, scale: 2 / 5),
                      fadeInDuration: Duration(milliseconds: 380),
                      fadeOutDuration: Duration(seconds: 0),
                      placeholder: AssetImage('assets/placeholderimage.png'),
                    ),
            ),
            Container(
              color: Colors.black,
              child: item.image2 == null
                  ? Center(
                      child: Text(
                        'No Image',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    )
                  : FadeInImage(
                      image: NetworkImage(item.image2, scale: 2 / 5),
                      fadeInDuration: Duration(milliseconds: 380),
                      fadeOutDuration: Duration(seconds: 0),
                      placeholder: AssetImage('assets/placeholderimage.png'),
                    ),
            ),
            Container(
              color: Colors.black,
              child: item.image3 == null
                  ? Center(
                      child: Text(
                        'No Image',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    )
                  : FadeInImage(
                      image: NetworkImage(item.image3, scale: 2 / 5),
                      fadeInDuration: Duration(milliseconds: 380),
                      fadeOutDuration: Duration(seconds: 0),
                      placeholder: AssetImage('assets/placeholderimage.png'),
                    ),
            ),
            Container(
              color: Colors.black,
              child: item.image4 == null
                  ? Center(
                      child: Text(
                        'No Image',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    )
                  : FadeInImage(
                      image: NetworkImage(item.image4, scale: 2 / 5),
                      fadeInDuration: Duration(milliseconds: 380),
                      fadeOutDuration: Duration(seconds: 0),
                      placeholder: AssetImage('assets/placeholderimage.png'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
