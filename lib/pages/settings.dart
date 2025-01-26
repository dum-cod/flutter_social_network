import 'dart:io';
import 'package:demo/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class Settings extends ConsumerStatefulWidget {
  const Settings({super.key});

  @override
  ConsumerState<Settings> createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<Settings> {
  final TextEditingController _nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    LocalUser currentUser = ref.watch(userProvider);
    _nameController.text = currentUser.user.name;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(children: [
          GestureDetector(
            onTap: () async {
              final ImagePicker picker = ImagePicker();
              final XFile? pickedImage = await picker.pickImage(
                  source: ImageSource.gallery, requestFullMetadata: false);
              if (pickedImage != null) {
                ref
                    .read(userProvider.notifier)
                    .updateImage(File(pickedImage.path));
              }
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(currentUser.user.profilePic),
              radius: 100,
            ),
          ),
          SizedBox(height: 10),
          Text("Tap image to change"),
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Enter Your Name",
            ),
            controller: _nameController,
          ),
          TextButton(
              onPressed: () {
                ref
                    .read(userProvider.notifier)
                    .updateName(_nameController.text);
              },
              child: const Text("Update")),
        ]),
      ),
    );
  }
}
