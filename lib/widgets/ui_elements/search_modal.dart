import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/item.dart';
import '../../main.dart';

class SearchModalBottomSheet extends StatefulWidget {
  SearchModalBottomSheetState createState() => SearchModalBottomSheetState();
}

class SearchModalBottomSheetState extends State<SearchModalBottomSheet> {
  SharedPreferences _prefs;
  static const String titlePrefKey = 'title_pref';
  static const String pricePrefKey = 'price_pref';
  static const String locationPrefKey = 'location_pref';
  static const String searchStartPrefKey = 'searchStart_pref';
  static const String searchContainPrefKey = 'searchContain_pref';
  static bool title = true;
  static bool price = false;
  static bool location = false;
  static bool searchStart = true;
  static bool searchContain = false;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance()
      ..then((prefs) {
        setState(() => this._prefs = prefs);

        _loadTitleBooleanPref();
        _loadPriceBooleanPref();
        _loadLocationBooleanPref();
        _loadSearchStartBooleanPref();
        _loadSearchContainBooleanPref();
      });
  }

  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            LinearProgressIndicator(backgroundColor: Colors.green[300]),
            Center(
              child: Text(
                  'Choose how you want to search \n      Title is active by default'),
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Flexible(child: Text('Search by Title')),
                Switch(
                  activeColor: Colors.blue,
                  onChanged: (bool val) {
                    setState(() {
                      //title = val;
                      price = false;
                      location = false;
                      if (price == false && location == false) {
                        title = true;
                      } else {
                        title = false;
                      }
                      _setTitleBooleanPref(title);
                      _setPriceBooleanPref(price);
                      _setLocationBooleanPref(location);
                    });
                  },
                  value: title,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Flexible(child: Text('Search by Price')),
                Switch(
                  activeColor: Colors.blue,
                  onChanged: (bool val) {
                    setState(() {
                      price = val;

                      location = false;
                      if (price == false && location == false) {
                        title = true;
                      } else {
                        title = false;
                      }

                      _setPriceBooleanPref(price);
                      _setTitleBooleanPref(title);
                      _setLocationBooleanPref(location);
                    });
                  },
                  value: price,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Flexible(child: Text('Search by Location')),
                Switch(
                  activeColor: Colors.blue,
                  onChanged: (bool val) {
                    setState(() {
                      location = val;

                      price = false;
                      if (location == false && price == false) {
                        title = true;
                      } else {
                        title = false;
                      }
                      _setLocationBooleanPref(location);
                      _setTitleBooleanPref(title);
                      _setPriceBooleanPref(price);
                    });
                  },
                  value: location,
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Center(child: Text('Choose your prefered search behaviour')),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ChoiceChip(
                  onSelected: (bool value) {
                    setState(() {
                      //searchStart = value;
                      searchContain = false;
                      if (searchContain == false) {
                        searchStart = true;
                      } else {
                        searchStart = false;
                      }
                      _setSearchStartBooleanPref(searchStart);
                      _setSearchContainBooleanPref(searchContain);
                    });
                  },
                  selected: searchStart,
                  label: Text(
                    'Starts with search',
                    style: TextStyle(
                        color: MyAppState.darkmode == false
                            ? Colors.black
                            : Colors.white),
                  ),
                  selectedColor: Colors.blue,
                  backgroundColor: MyAppState.darkmode == false
                      ? Colors.white
                      : Colors.black12,
                ),
                SizedBox(
                  width: 20.0,
                ),
                ChoiceChip(
                  onSelected: (bool value) {
                    setState(() {
                      //searchContain = value;
                      searchStart = false;
                      if (searchStart == false) {
                        searchContain = true;
                      } else {
                        searchContain = false;
                      }
                      _setSearchContainBooleanPref(searchContain);
                      _setSearchStartBooleanPref(searchStart);
                    });
                  },
                  selected: searchContain,
                  selectedColor: Colors.blue,
                  label: Text('Contains search',
                      style: TextStyle(
                          color: MyAppState.darkmode == false
                              ? Colors.black
                              : Colors.white)),
                  backgroundColor: MyAppState.darkmode == false
                      ? Colors.white
                      : Colors.black12,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // Loads boolean preference into this.title.
  void _loadTitleBooleanPref() {
    setState(() {
      title = this._prefs.getBool(titlePrefKey) ?? true;
    });
  }

  Future<Null> _setTitleBooleanPref(bool val) async {
    await this._prefs.setBool(titlePrefKey, val);
    _loadTitleBooleanPref();
  }

  // Loads boolean preference into this.price.
  void _loadPriceBooleanPref() {
    setState(() {
      price = this._prefs.getBool(pricePrefKey) ?? false;
    });
  }

  Future<Null> _setPriceBooleanPref(bool val) async {
    await this._prefs.setBool(pricePrefKey, val);
    _loadPriceBooleanPref();
  }

  // Loads boolean preference into this.location.
  void _loadLocationBooleanPref() {
    setState(() {
      location = this._prefs.getBool(locationPrefKey) ?? false;
    });
  }

  Future<Null> _setLocationBooleanPref(bool val) async {
    await this._prefs.setBool(locationPrefKey, val);
    _loadLocationBooleanPref();
  }

  // Loads boolean preference into this.searchStart.
  void _loadSearchStartBooleanPref() {
    setState(() {
      searchStart = this._prefs.getBool(searchStartPrefKey) ?? true;
    });
  }

  Future<Null> _setSearchStartBooleanPref(bool val) async {
    await this._prefs.setBool(searchStartPrefKey, val);
    _loadSearchStartBooleanPref();
  }

  // Loads boolean preference into this.searchContain.
  void _loadSearchContainBooleanPref() {
    setState(() {
      searchContain = this._prefs.getBool(searchContainPrefKey) ?? false;
    });
  }

  Future<Null> _setSearchContainBooleanPref(bool val) async {
    await this._prefs.setBool(searchContainPrefKey, val);
    _loadSearchContainBooleanPref();
  }

//searchtype, search by title, price or location based on selected switch
  static searchType(List<Item> item, var query) {
    if (title == true) {
      if (searchStart) {
        return item.where((Item i) => i.title.toLowerCase().startsWith(query));
      } else if (searchContain) {
        return item.where((Item i) => i.title.toLowerCase().contains(query));
      } else {
        return item.where((Item i) => i.title.toLowerCase().startsWith(query));
      }
    } else if (price == true) {
      if (searchStart) {
        return item.where((Item i) => i.price.startsWith(query));
      } else if (searchContain) {
        return item.where((Item i) => i.price.contains(query));
      } else {
        return item.where((Item i) => i.price.startsWith(query));
      }
    } else if (location == true) {
      if (searchStart) {
        return item.where((Item i) => i.locationAddress.toLowerCase().startsWith(query));
      } else if (searchContain) {
        return item.where((Item i) => i.locationAddress.toLowerCase().contains(query));
      } else {
        return item.where((Item i) => i.locationAddress.toLowerCase().startsWith(query));
      }
    } else {
      return item.where((Item i) => i.title.toLowerCase().startsWith(query));
    }
  }

//searchSuggestionsType, search suggestions based on selected switch
  static searchSuggestionsType(Iterable<Item> suggestions) {
    if (title == true) {
      return suggestions.map<String>((Item i) => i.title.toLowerCase()).toList();
    } else if (price == true) {
      return suggestions.map<String>((Item i) => i.price.toString()).toList();
    } else if (location == true) {
      return suggestions.map<String>((Item i) => i.locationAddress.toLowerCase()).toList();
    } else {
      return suggestions.map<String>((Item i) => i.title.toLowerCase()).toList();
    }
  }

//subtitleText, search suggestions subtitle text of the ListTile based on selected switch
  static subtitleText(Item itemSuggestion) {
    if (title == true) {
      return 'GH₵ ' + itemSuggestion.price.toString();
    } else if (price == true) {
      return itemSuggestion.title;
    } else if (location == true) {
      return itemSuggestion.title;
    } else {
      return itemSuggestion.price.toString();
    }
  }

//trailingText, search suggestions trailing text of the ListTile based on selected switch
  static trailingText(Item itemSuggestion) {
    if (title == true) {
      return itemSuggestion.locationAddress;
    } else if (price == true) {
      return itemSuggestion.locationAddress;
    } else if (location == true) {
      return 'GH₵ ' + itemSuggestion.price;
    } else {
      return itemSuggestion.locationAddress;
    }
  }

//trailingIcon, search suggestions trailing icon of the ListTile based on selected switch
  static trailingIcon(Widget icon) {
    if (title == true) {
      return Icon(Icons.location_on);
    } else if (price == true) {
      return Icon(Icons.location_on);
    } else if (location == true) {
      return Icon(null);
    } else {
      return Icon(Icons.location_on);
    }
  }

//titleWidget, leading widget of search suggestions based on selected switch
  static titleWidget(Widget leadingTitleWidget) {
    if (title == true) {
      return Container();
    } else if (price == true) {
      return Text('GH₵ ');
    } else if (location == true) {
      return Icon(
        Icons.location_on,
        color: Colors.green,
      );
    } else {
      return Container();
    }
  }
}
