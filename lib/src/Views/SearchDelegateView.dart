import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:later_app/src/Support/Database/DB.dart';
import 'package:logger/logger.dart';
// import 'package:meilisearch/meilisearch.dart';

class SearchDelegateView extends SearchDelegate {

  SearchDelegateView();

  @override
  String get searchFieldLabel => query;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {

    return FutureBuilder(
          future: DB.instance.searchQuery('shared_content', query),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              Logger().e(snapshot.error);
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  Logger().e(snapshot.error);
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final suggestions = snapshot.data!;
                  if (suggestions.isEmpty) {
                    return Center(child: Text('No suggestions found.'));
                  }
                  return ListTile(
                    title: Text(snapshot.data?[index]['title']),
                    onTap: () {
                      // query = suggestionList[index].name;
                      // showResults(context);
                    },
                  );



                }else{
                  return Center(child: Text('No suggestions found.'));
                }
              },
            );
          },
  );
    // var index = meiliSearchClient.index('products');
    //
    // var result = index.search('معمول');
    //
    // List products = [];
    //
    // result.asSearchResult().then((value) {
    //   Logger().i(value.hits);
    //   products.addAll(value.hits);
    // });
    //
    // return ListView.builder(
    //   itemCount: products.length,
    //   itemBuilder: (context, index) {
    //     return ListTile(
    //       title: Text(products[index]['name_en']),
    //       onTap: () {
    //         // query = suggestionList[index].name;
    //         // showResults(context);
    //       },
    //     );
    //   },
    // );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);

    // var index = meiliSearchClient.index('products');
    //
    // var result = index.search(query);
    //
    // return FutureBuilder(
    //   future: result.asSearchResult(),
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     }
    //
    //     if (snapshot.hasError) {
    //       return Center(
    //         child: Text('Error: ${snapshot.error}'),
    //       );
    //     }
    //
    //     return ListView.builder(
    //       itemCount: snapshot.data?.hits.length,
    //       itemBuilder: (context, index) {
    //         if (snapshot.connectionState == ConnectionState.waiting) {
    //           return Center(child: CircularProgressIndicator());
    //         } else if (snapshot.hasError) {
    //           return Center(child: Text('Error: ${snapshot.error}'));
    //         } else if (snapshot.hasData) {
    //           final suggestions = snapshot.data!;
    //           if (suggestions.hits.isEmpty) {
    //             return Center(child: Text('No suggestions found.'));
    //           }
    //           return ListTile(
    //             title: Text(snapshot.data?.hits[index]['name_en']),
    //             onTap: () {
    //               // query = suggestionList[index].name;
    //               // showResults(context);
    //             },
    //           );
    //
    //
    //
    //         }else{
    //           return Center(child: Text('No suggestions found.'));
    //         }
    //       },
    //     );
    //   },
    // );
  }
}