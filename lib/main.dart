import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './scoped-models/main.dart';
import './models/item.dart';

import './pages/main_pages/auth.dart';
import './pages/drawer/drawer.dart';
import './pages/main_pages/accommodation_page.dart';
import './pages/main_pages/events.dart';
import './pages/main_pages/home.dart';
import './pages/main_pages/products.dart';
import './pages/main_pages/internship_jobs.dart';
import './pages/bottom_nav_pages/add.dart';
import './pages/bottom_nav_pages/fav.dart';
import './pages/bottom_nav_pages/my_items.dart';
import './pages/bottom_nav_pages/search.dart';
import './pages/main_pages/chat/chats_with.dart';

import './pages/main_pages/page_detail/page_details.dart';
import './widgets/helpers/custom_route.dart';

void main() {
  runApp(MaterialApp(
    title: 'Tersh',
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  final MainModel _model = MainModel();
  bool _isAuthenticated = false;
  TershDrawer tershDrawer = TershDrawer();
  SharedPreferences _prefs;
  static const String darkModePrefKey = 'darkMode_pref';
  static bool darkmode = false;
  bool home = false;
  bool products = false;
  bool accommodation = false;
  bool jobs = false;
  bool events = false;
  @override
  void initState() {
    super.initState();
    //check for existing token when the app starts
    _model.autoAuthenticate();

    _model.userSubject.listen((bool isAuthenticated) {
      setState(() {
        _isAuthenticated = isAuthenticated;
      });
    });
    SharedPreferences.getInstance()
      ..then((prefs) {
        setState(() => this._prefs = prefs);

        _loadDarkModeBooleanPref();
      });
    _model.fetchProducts();
    _model.fetchAccommodation();
    _model.fetchJob();
    _model.fetchEvent();
    _model.fetchUsers();
    _model.fetchUsersPhoto();
    _model.fetchAgents().then((_) {
      _model.fetchNewUser();
      _model.fetchUserPhoto();
      _model.fetchAgent();
    });
  }

  homeActive() {
    setState(() {
      home = true;
      products = false;
      accommodation = false;
      jobs = false;
      events = false;
    });
  }

  productsActive() {
    setState(() {
      home = false;
      products = true;
      accommodation = false;
      jobs = false;
      events = false;
    });
  }

  accommodationActive() {
    setState(() {
      home = false;
      products = false;
      accommodation = true;
      jobs = false;
      events = false;
    });
  }

  jobsActive() {
    setState(() {
      home = false;
      products = false;
      accommodation = false;
      jobs = true;
      events = false;
    });
  }

  eventsActive() {
    setState(() {
      home = false;
      products = false;
      accommodation = false;
      jobs = false;
      events = true;
    });
  }

  changeBottomBar() {
    if (home == true) {
      return Home();
    } else if (products == true) {
      return ProductsPage();
    } else if (accommodation == true) {
      return AccommodationsPage();
    } else if (jobs == true) {
      return InternshipJobsPage();
    } else if (events == true) {
      return EventsPage();
    } else {
      return Home();
    }
  }

  changeBottomBarIcon() {
    if (home == true) {
      return Icon(Icons.home);
    } else if (products == true) {
      return Icon(Icons.shopping_basket);
    } else if (accommodation == true) {
      return Icon(Icons.hotel);
    } else if (jobs == true) {
      return Icon(Icons.work);
    } else if (events == true) {
      return Icon(Icons.event);
    } else {
      return Icon(Icons.home);
    }
  }

  changeBottomBarText() {
    if (home == true) {
      return Text('Home');
    } else if (products == true) {
      return Text('Products');
    } else if (accommodation == true) {
      return Text('Accommodation');
    } else if (jobs == true) {
      return Text('Internships & Jobs');
    } else if (events == true) {
      return Text('Events');
    } else {
      return Text('Home');
    }
  }

  //change darkmode when drawer is long pressed
  changeDarkMode() {
    if (darkmode == false) {
      setState(() {
        darkmode = true;
        _setDarkModeBooleanPref(darkmode);
      });
    } else {
      setState(() {
        darkmode = false;
        _setDarkModeBooleanPref(darkmode);
      });
    }
  }

  darkModeWidget() {
    return SwitchListTile(
      activeColor: Colors.blue,
      value: darkmode,
      title: Text('Dark Mode'),
      onChanged: (bool val) {
        setState(() {
          darkmode = val;
          _setDarkModeBooleanPref(darkmode);
        });
      },
    );
  }

  changeAppBar() {
    if (home == true && tershDrawer.selectedIndex == 0) {
      return Text('Tersh');
    } else if (products == true && tershDrawer.selectedIndex == 0) {
      return Text('Products');
    } else if (accommodation == true && tershDrawer.selectedIndex == 0) {
      return Text('Accommodation');
    } else if (jobs == true && tershDrawer.selectedIndex == 0) {
      return Text('Internships & Jobs');
    } else if (events == true && tershDrawer.selectedIndex == 0) {
      return Text('Events');
    } else if (tershDrawer.selectedIndex == 1) {
      return Text('Favorite');
    } else if (tershDrawer.selectedIndex == 4) {
      return Text('My Items');
    } else {
      return Text('Tersh');
    }
  }

  mainPage() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      List<Item> allItems = model.allProducts +
          model.allAccommodation +
          model.allJobs +
          model.allEvents;

      return Scaffold(
        drawer: tershDrawer.drawer(
            homeActive,
            productsActive,
            accommodationActive,
            jobsActive,
            eventsActive,
            darkModeWidget,
            changeDarkMode),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              tershDrawer.selectedIndex != 3
                  ? SliverAppBar(
                      actions: <Widget>[
                        IconButton(
                          tooltip: 'Messages',
                          icon: ChatsWithState.newMessage == true ? Icon(Icons.mail,color: Colors.red[300]) : Icon(Icons.mail),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatsWith()));
                          },
                        )
                      ],
                      forceElevated: true,
                      floating: true,
                      snap: true,
                      title: changeAppBar(),
                    )
                  : MySearchState.searchSliverAppBar(context, allItems),
            ];
          },
          body: Center(
            child: [
              changeBottomBar(),
              Fav(model),
              AddPage(),
              MySearch(),
              MyItems()
            ].elementAt(tershDrawer.selectedIndex),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: changeBottomBarIcon(), title: changeBottomBarText()),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border),
                activeIcon: Icon(Icons.favorite),
                title: Text('Favorite')),
            BottomNavigationBarItem(
              icon: GestureDetector(
                child: Icon(Icons.add_circle),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Add()),
                  );
                },
              ),
              title: GestureDetector(
                child: Text('Add'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Add()),
                  );
                },
              ),
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.search), title: Text('Search')),
            BottomNavigationBarItem(
                icon: Icon(Icons.list), title: Text('My Items')),
          ],
          currentIndex: tershDrawer.selectedIndex,
          fixedColor: Colors.black,
          onTap: _onItemTapped,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
        title: 'Tersh',
        theme: ThemeData(
          textTheme: TextTheme(title: TextStyle(color: Colors.black)),
          brightness: darkmode == false ? Brightness.light : Brightness.dark,
          accentColor: darkmode == false ? Colors.blue : Colors.black,
        ),
        home: !_isAuthenticated ? AuthPage() : mainPage(),

//        routes: {
//          //Navigation
//          '/': (BuildContext context) =>
//              !_isAuthenticated ? AuthPage() : HomeBar(),
//        },
        onGenerateRoute: (RouteSettings settings) {
          if (!_isAuthenticated) {
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) => AuthPage(),
            );
          }

          final List<String> pathElements = settings.name.split('/');
          if (pathElements[0] != '') {
            return null;
          }
          if (pathElements[1] == 'detailpage') {
            final String itemId = pathElements[2];
            List<Item> allItems = _model.allProducts +
                _model.allAccommodation +
                _model.allJobs +
                _model.allEvents;
            final Item item = allItems.firstWhere((Item item) {
              return item.id == itemId;
            });
            return CustomRoute<bool>(
              builder: (BuildContext context) =>
                  !_isAuthenticated ? AuthPage() : DetailsPage(item),
            );
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            builder: (BuildContext context) =>
                !_isAuthenticated ? AuthPage() : MyApp(),
          );
        },
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      tershDrawer.selectedIndex = index;
    });
  }

  // Loads boolean preference into darkmode.
  void _loadDarkModeBooleanPref() {
    setState(() {
      darkmode = this._prefs.getBool(darkModePrefKey) ?? false;
    });
  }

  Future<Null> _setDarkModeBooleanPref(bool val) async {
    await this._prefs.setBool(darkModePrefKey, val);
    _loadDarkModeBooleanPref();
  }
}
