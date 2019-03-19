import 'dart:async';

import 'package:flutter/material.dart';

import '../add_pages/products.dart';
import '../add_pages/accommodation.dart';
import '../add_pages/job.dart';
import '../add_pages/event.dart';
import '../../main.dart';

class Add extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                snap: true,
                floating: true,
                forceElevated: true,
                backgroundColor:
                    MyAppState.darkmode == false ? Colors.white : Colors.black,
                leading: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: MyAppState.darkmode == false
                        ? Colors.black
                        : Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                title: Row(
                  children: <Widget>[
                    Text(
                      'Create',
                      style: TextStyle(
                          color: MyAppState.darkmode == false
                              ? Colors.black
                              : Colors.white),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Icon(Icons.create,
                        color: MyAppState.darkmode == false
                            ? Colors.black
                            : Colors.white)
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: <Widget>[
              ProductsAddPage(),
              AccommodationAddPage(),
              JobsAddPage(),
              EventsAddPage()
            ],
          ),
        ),
        bottomNavigationBar: TabBar(
          isScrollable: orientation == Orientation.portrait ? true : false,
          labelColor:
              MyAppState.darkmode == false ? Colors.black : Colors.white,
          indicatorColor:
              MyAppState.darkmode == false ? Colors.black : Colors.white,
          tabs: <Widget>[
            Tab(
              text: "Product",
            ),
            Tab(
              text: "Accomodation",
            ),
            Tab(
              text: "Internship & Jobs",
            ),
            Tab(
              text: "Event",
            ),
          ],
        ),
      ),
    );
  }
}

class AddPage extends StatefulWidget {
  @override
  AddPageState createState() {
    return new AddPageState();
  }
}

class AddPageState extends State<AddPage> {
  @override
  void initState() {
    super.initState();

    // The delay fixes it
    Future.delayed(Duration(milliseconds: 10)).then((_) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Add()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
