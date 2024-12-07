import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:later_app/src/Controllers/HomeViewController.dart';
import 'package:later_app/src/Services/ContentStreamService.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeViewControllerProvider);

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
            // Add search functionality here
          },
        ),
        title: const Center(
          child: Text('Later'),
        ),
        actions: const [SizedBox(width: 48)], // To balance the AppBar with the leading icon
        backgroundColor: Colors.white,
      ),
      body: state.when(
        data: (state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                // Page title aligned to the left
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 16, right: 16.0, bottom: 16.0),
                  child: Align(
                    alignment: Alignment.centerLeft, // Align text to the left
                    child: const Text(
                      'Shared Content',
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
                // Show the ad area
                Padding(
                  padding: EdgeInsets.only(left: 16.0, top: 0, right: 16.0, bottom: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0), // Border radius for the ad area
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Stack(
                        alignment: Alignment.bottomLeft, // Align title to the left-bottom
                        children: [
                          Image.network(
                            'https://via.placeholder.com/400x180', // Placeholder ad image, replace with actual ad
                            width: double.infinity,
                            height: 180,
                            fit: BoxFit.cover,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0), // Padding for title inside the ad
                            child: Container(
                              color: Colors.black.withOpacity(0.1), // Background for title text
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
                // If there's no data, display 'No Data' message
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
                // List of shared content if data exists
                if (state.sharedContent.isNotEmpty)
                  ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: state.sharedContent.length, // Remove the +1 here, to avoid index out of range error
                    shrinkWrap: true, // Ensure the ListView doesn't take up all available space
                    physics: NeverScrollableScrollPhysics(), // Disable internal scroll for ListView
                    itemBuilder: (context, index) {
                      // For other items, display shared content
                      final message = state.sharedContent[index];
                      return InkWell(
                        onTap: () {
                          // Open the URL when the list item is clicked
                          _launchURL(Uri.parse(message['url']));
                        },
                        splashColor: Colors.grey.withOpacity(0.2), // Custom splash effect
                        highlightColor: Colors.grey.withOpacity(0.1), // Highlight color when tapping
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center, // Center vertically
                            children: [
                              // Text Section (Title & Description)
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      message['title'],
                                      maxLines: 2, // Limit to 3 lines
                                      overflow: TextOverflow.ellipsis, // Ellipsis for overflow
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      message['description'],
                                      maxLines: 3, // Limit to 3 lines
                                      overflow: TextOverflow.ellipsis, // Ellipsis for overflow
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              // Image Section
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12.0), // Add border radius
                                child: Image.network(
                                  message['image'],
                                  width: 110, // Set width to 100
                                  height: 110, // Set height to 100
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    // Separator line with horizontal padding of 16.0
                    separatorBuilder: (context, index) => const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Divider(height: 1, thickness: 1),
                    ),
                  ),
              ],
            ),
          );
        },
        error: (error, stackTrace) => Center(
          child: Text('Error: ${error.toString()}'),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}



