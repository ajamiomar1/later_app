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
        appBar: AppBar(
          title: const Text('Shared Content Example'),
        ),
        body: state.when(data: (state) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: state.sharedContent.length,
              itemBuilder: (context, index) {
                final message = state.sharedContent[index];
                return Card(
                  child: Column(
                    children: [
                      Image.network(message['image']),
                      SizedBox(height: 10),
                      Text(message['title']),
                      SizedBox(height: 10),
                      Text(message['description']),
                    ],
                  ),
                );
              },
            ),
          );
        }, error: (error,stackTrace) => Text(error.toString()), loading: () => const CircularProgressIndicator()));
  }
}
