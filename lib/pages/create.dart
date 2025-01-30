import 'package:demo/providers/tweet_provider.dart';
import 'package:demo/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateTweet extends ConsumerStatefulWidget {
  const CreateTweet({super.key});

  @override
  ConsumerState<CreateTweet> createState() => _CreateTweetState();
}

class _CreateTweetState extends ConsumerState<CreateTweet> {
  late TextEditingController _tweetController;
  int _remainingChars = 280;

  @override
  void initState() {
    super.initState();
    _tweetController = TextEditingController();
    _tweetController.addListener(_updateCharCount);
  }

  void _updateCharCount() {
    setState(() {
      _remainingChars = 280 - _tweetController.text.length;
    });
  }

  @override
  void dispose() {
    _tweetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(userProvider).user;
    final isValidTweet =
        _tweetController.text.isNotEmpty && _remainingChars >= 0;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, size: 28, color: Colors.grey),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Image(
          image: AssetImage('assets/tweeter_logo.png'),
          width: 80,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Builder(
                  builder: (innerContext) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: GestureDetector(
                        onTap: () => Scaffold.of(innerContext).openDrawer(),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundImage:
                                NetworkImage(currentUser.profilePic),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _tweetController,
                    maxLines: null,
                    autofocus: true,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "What's happening?",
                      hintStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                    ),
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // IconButton(
                //   icon: const Icon(Icons.image, color: Colors.blue, size: 28),
                //   onPressed: () {}, // Add image functionality
                // ),
                Row(
                  children: [
                    Text(
                      '$_remainingChars',
                      style: TextStyle(
                        color: _remainingChars < 0
                            ? Colors.red
                            : _remainingChars < 20
                                ? Colors.orange
                                : Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: isValidTweet
                          ? () {
                              ref
                                  .read(tweetProvider)
                                  .postTweet(_tweetController.text);
                              Navigator.pop(context);
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF28a9e0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      child: const Text(
                        'Tweet',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
