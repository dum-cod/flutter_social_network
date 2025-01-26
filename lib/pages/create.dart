import 'package:demo/providers/tweet_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateTweet extends ConsumerWidget {
  const CreateTweet({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController tweetController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post a Tweet"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: TextField(
                maxLines: 4,
                controller: tweetController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter Your Tweet",
                ),
                maxLength: 280,
              ),
            ),
            TextButton(
              onPressed: () {
                ref.read(tweetProvider).postTweet(tweetController.text);
                Navigator.pop(context);
              },
              child: const Text("Post Tweet"),
            ),
          ],
        ),
      ),
    );
  }
}
