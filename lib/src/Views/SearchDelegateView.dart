import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:later_app/src/Support/Database/DB.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';
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
    // Function to open the URL
    Future<void> launchURL(Uri url) async {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $url';
      }
    }

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

            if (snapshot.hasData) {
              final suggestions = snapshot.data!;
              if (suggestions.isEmpty) {
                return const Center(child: Text('No result found.'));
              }
            }

            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final suggestions = snapshot.data!;
                  if (suggestions.isEmpty) {
                    return const Center(child: Text('No result found.'));
                  }
                  final suggestion = suggestions[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: InkWell(
                      onTap: () {
                        launchURL(Uri.parse(suggestion['url']));
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  suggestion['title'] ?? 'Untitled',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  suggestion['description'] ?? '',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Image.network(
                              suggestion['image'] ?? 'https://via.placeholder.com/110',
                              width: 110,
                              height: 110,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return const Center(child: Text('No result found.'));
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