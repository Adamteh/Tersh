import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../models/item.dart';
import '../../scoped-models/main.dart';
import '../../main.dart';

import '../../widgets/ui_elements/search_modal.dart';
import '../../widgets/ui_elements/search_image_popup.dart';

class MySearch extends StatefulWidget {
  @override
  MySearchState createState() => MySearchState();
}

class MySearchState extends State<MySearch> {
  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static searchSliverAppBar(context, allItems) {
    final _SearchDemoSearchDelegate _delegate =
        _SearchDemoSearchDelegate(allItems);

    final orientation = MediaQuery.of(context).orientation;
    return SliverAppBar(
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.arrow_downward),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return SearchModalBottomSheet();
              },
            );
          },
        )
      ],
      forceElevated: true,
      floating: true,
      snap: true,
      backgroundColor:
          MyAppState.darkmode == false ? Colors.white : Colors.black12,
      iconTheme: IconThemeData(
          color: MyAppState.darkmode == false ? Colors.black : Colors.white,
          size: 30),
      flexibleSpace: FlexibleSpaceBar(
        title: GestureDetector(
          child: Container(
            width: orientation == Orientation.portrait ? 250 : 500,
            padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.5),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                border:
                    Border.all(color: Colors.black.withOpacity(.1), width: 1.0),
                borderRadius: BorderRadius.circular(20.0)),
            child: Row(
              children: <Widget>[
                Text(
                  'Search',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontStyle: FontStyle.italic),
                ),
                SizedBox(width: 20),
                Icon(
                  Icons.search,
                  color: Colors.black,
                )
              ],
            ),
          ),
          onTap: () async {
            final dynamic selected = await showSearch(
              context: context,
              delegate: _delegate,
            );
            if (selected != null) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('You have selected the word: $selected'),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        List<Item> allItems = model.allProducts +
            model.allAccommodation +
            model.allJobs +
            model.allEvents;

        //allItems.shuffle();
        Widget content;
        if (allItems.length > 0) {
          content = CustomScrollView(
            slivers: <Widget>[
              SliverGrid(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 180.0,
                  mainAxisSpacing: 3.0,
                  crossAxisSpacing: 3.0,
                  childAspectRatio: 1.0,
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return SearchItemImage(allItems[index]);
                  },
                  childCount: allItems.length,
                ),
              ),
            ],
          );
        } else {
          content = Center(child: Text('No Items Found'));
        }
        return content;
      },
    );
  }
}

class _SearchDemoSearchDelegate extends SearchDelegate<dynamic> {
  final List<Item> _data;

  final List<Item> _history;
  _SearchDemoSearchDelegate(List<Item> data)
      : _data = data,
        _history = <Item>[],
        super();

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var searchdata = SearchModalBottomSheetState.searchType(_data, query);

    final Iterable<Item> suggestions = query.isEmpty ? _history : searchdata;

    final Iterable<Item> itemSuggestions = searchdata;

    return _SuggestionList(
      query: query,
      suggestions:
          SearchModalBottomSheetState.searchSuggestionsType(suggestions),
      onSelected: (String suggestion) {
        query = suggestion;

        showResults(context);
      },
      item: itemSuggestions.map<Item>((Item i) => i).toList(),
      onnSelected2: (Item ssuggestion) {
        _history.insert(0, ssuggestion);
        showResults(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      query.isEmpty
          ? IconButton(
              tooltip: 'Voice Search',
              icon: const Icon(Icons.mic),
              onPressed: () {
                query = 'TODO: implement voice input';
              },
            )
          : IconButton(
              tooltip: 'Clear',
              icon: const Icon(Icons.clear),
              onPressed: () {
                query = '';
                showSuggestions(context);
              },
            )
    ];
  }
}

class _SuggestionList extends StatelessWidget {
  const _SuggestionList(
      {this.suggestions,
      this.query,
      this.onSelected,
      this.item,
      this.onnSelected2});

  final List<String> suggestions;
  final String query;
  final ValueChanged<String> onSelected;
  final List<Item> item;
  final ValueChanged<Item> onnSelected2;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (BuildContext context, int i) {
          final String suggestion = suggestions[i];
          Item itemSuggestion = item[i];
          Widget icon;
          Widget leadingTitleWidget;
          return Container(
            child: ListTile(
              leading: query.isEmpty
                  ? const Icon(Icons.history)
                  : CircleAvatar(
                      backgroundImage: NetworkImage(itemSuggestion.image),
                    ),
              title: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SearchModalBottomSheetState.titleWidget(leadingTitleWidget),
                    RichText(
                      text: TextSpan(
                        //the text n the search box
                        text: suggestion.substring(0, query.length),
                        style: theme.textTheme.subhead
                            .copyWith(fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(
                            //remaining of the suggested text
                            text: suggestion.substring(query.length),
                            style: theme.textTheme.subhead,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              subtitle: Text(
                SearchModalBottomSheetState.subtitleText(itemSuggestion),
                overflow: TextOverflow.ellipsis,
              ),
              trailing: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    SearchModalBottomSheetState.trailingIcon(icon),
                    Text(
                      SearchModalBottomSheetState.trailingText(itemSuggestion),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              onTap: () {
                model.selectItem(itemSuggestion.id);
                Navigator.pushNamed(context, '/detailpage/' + itemSuggestion.id)
                    .then((_) => model.selectItem(null));
                onSelected(suggestion);
                onnSelected2(itemSuggestion);
              },
            ),
          );
        },
      );
    });
  }
}
