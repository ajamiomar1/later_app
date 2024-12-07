import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:later_app/src/Controllers/HomeViewController.dart';
import 'package:later_app/src/Services/ContentStreamService.dart';

class HomeView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeViewControllerProvider);

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
          return ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: state.sharedContent.length,
            itemBuilder: (context, index) {
              final message = state.sharedContent[index];
              return Padding(
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
              );
            },
            // Separator line with horizontal padding of 16.0
            separatorBuilder: (context, index) => const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider(height: 1, thickness: 1),
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
