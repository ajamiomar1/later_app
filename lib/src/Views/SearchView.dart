import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:later_app/src/Controllers/SearchViewController.dart';
import 'package:later_app/src/Services/ContentStreamService.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class SearchView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(searchViewControllerProvider);

    final PagingController<int, Map<String, dynamic>> _pagingController =
    PagingController(firstPageKey: 0);

    String _currentQuery = "";

    Future<void> _fetchPage(int pageKey) async {
      try {
        final newItems = await ref
            .read(searchViewControllerProvider.notifier)
            .fetchPage(_currentQuery, pageKey);

        final isLastPage =
            newItems.length < ref.read(searchViewControllerProvider.notifier).pageSize;
        if (isLastPage) {
          _pagingController.appendLastPage(newItems);
        } else {
          _pagingController.appendPage(newItems, pageKey + 1);
        }
      } catch (error) {
        _pagingController.error = error;
      }
    }

    // Add a listener for page requests
    _pagingController.addPageRequestListener(_fetchPage);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Search'),
        backgroundColor: Colors.white,
      ),
      body: state.when(
        data: (state) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  onChanged: ref.read(searchViewControllerProvider.notifier).search,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    suffixIcon: const Icon(Icons.search),
                  ),
                ),
              ),
              Expanded(
                child: PagedListView<int, Map<String, dynamic>>(
                  pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate<Map<String, dynamic>>(
                    noItemsFoundIndicatorBuilder: (context) => const Center(
                      child: Text(
                        'No results found',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    itemBuilder: (context, item, index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Text Section (Title & Description)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['title'],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  item['description'],
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Image Section
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Image.network(
                              item['image'],
                              width: 110,
                              height: 110,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        error: (error, stackTrace) => Center(
          child: Text('Error: ${error.toString()}'),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      )
    );
  }

  // @override
  // void dispose() {
  //   _pagingController.dispose();
  //   super.dispose();
  // }
}


