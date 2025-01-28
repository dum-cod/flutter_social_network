import 'package:demo/pages/create.dart';
import 'package:demo/pages/settings.dart';
import 'package:demo/pages/signin.dart';
import 'package:demo/providers/tweet_provider.dart';
import 'package:demo/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/tweet.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    LocalUser currentUser = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: Container(
              color: Colors.grey,
              height: 1,
            )),
        title: const Image(
          image: AssetImage('assets/tweeter_logo.png'),
          width: 80,
        ),
        leading: Builder(builder: (context) {
          return GestureDetector(
            onTap: () => Scaffold.of(context).openDrawer(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                  backgroundImage: NetworkImage(currentUser.user.profilePic)),
            ),
          );
        }),
      ),
      body: ref.watch(feedProvider).when(
          data: (List<Tweet> tweets) {
            return ListView.separated(
                separatorBuilder: (context, index) => const Divider(
                      color: Colors.grey,
                    ),
                itemCount: tweets.length,
                itemBuilder: (context, count) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(tweets[count].profilePic),
                    ),
                    title: Text(
                      tweets[count].name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      tweets[count].tweet,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  );
                });
          },
          error: (error, stackTrace) => const Center(
                child: Text("Error fetching tweets"),
              ),
          loading: () => const Center(
                child: CircularProgressIndicator(),
              )),
      drawer: Drawer(
        child: Column(
          children: [
            Image.network(
              currentUser.user.profilePic,
              scale: 0.2,
            ),
            ListTile(
                title: Text(
              "Hello, ${currentUser.user.name}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            )),
            ListTile(
              title: const Text("Settings"),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Settings()));
              },
            ),
            ListTile(
              title: const Text("Sign Out"),
              onTap: () {
                FirebaseAuth.instance.signOut();
                ref.read(userProvider.notifier).logout();

                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => SignIn()));
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => CreateTweet()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
