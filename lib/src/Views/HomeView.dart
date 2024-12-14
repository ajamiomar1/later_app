import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:later_app/src/Controllers/HomeViewController.dart';
import 'package:later_app/src/Services/ContentStreamService.dart';
import 'package:later_app/src/Views/SearchDelegateView.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:later_app/src/Views/SearchView.dart';

class HomeView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeViewControllerProvider);
    final homeViewController = ref.watch(homeViewControllerProvider.notifier);

    // Function to open the URL
    Future<void> _launchURL(Uri url) async {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            showSearch(context: context, delegate: SearchDelegateView());
          },
        ),
        title: const Center(
          child: Text('Later'),
        ),
        actions: const [SizedBox(width: 48)],
        backgroundColor: Colors.white,
      ),
      body: state.when(
        data: (state) => RefreshIndicator(
          onRefresh: () async {
            homeViewController.pagingController.refresh();
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    // Page title
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 16, right: 16.0, bottom: 16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Shared Content',
                          style: TextStyle(
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),

                    // Ad area
                    Padding(
                      padding: EdgeInsets.only(left: 16.0, top: 0, right: 16.0, bottom: 25.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              Image.network(
                                'https://via.placeholder.com/400x180',
                                width: double.infinity,
                                height: 180,
                                fit: BoxFit.cover,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Container(
                                  color: Colors.black.withOpacity(0.1),
                                  child: const Text(
                                    'Title for something I do not know',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // No Data message
                    if (state.sharedContent.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Text(
                            'No Data',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Paginated list of shared content
              PagedSliverList<int, Map<String, dynamic>>(
                pagingController: homeViewController.pagingController,
                builderDelegate: PagedChildBuilderDelegate<Map<String, dynamic>>(
                  itemBuilder: (context, message, index) {
                    return InkWell(
                      onTap: () {
                        _launchURL(Uri.parse(message['url']));
                      },
                      splashColor: Colors.grey.withOpacity(0.2),
                      highlightColor: Colors.grey.withOpacity(0.1),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    message['title'],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    message['description'],
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
                                message['image'],
                                width: 110,
                                height: 110,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  firstPageErrorIndicatorBuilder: (context) => Center(
                    child: Text('Error loading content'),
                  ),
                  noItemsFoundIndicatorBuilder: (context) => Center(
                    child: Text('No shared content found'),
                  ),
                  newPageErrorIndicatorBuilder: (context) => Center(
                    child: Text('Error loading more content'),
                  ),
                  firstPageProgressIndicatorBuilder: (context) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  newPageProgressIndicatorBuilder: (context) => Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ],
          ),
        ),
        error: (error, stackTrace) => Center(
          child: Text('Error: ${error.toString()}'),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}



