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
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    LocalUser currentUser = ref.watch(userProvider);
    _nameController.text = currentUser.user.name;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF28a9e0)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
              child: Column(
                //alignment: Alignment.bottomCenter,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(currentUser.user.profilePic),
                    radius: 150,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(136, 136, 134, 134),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "Tap to change",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            const Text("Profile Settings",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Container(
              margin: EdgeInsets.fromLTRB(15, 30, 15, 0),
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: "Enter your Name",
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your Name";
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 250,
              decoration: BoxDecoration(
                color: Color(0xFF28a9e0),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ref
                        .read(userProvider.notifier)
                        .updateName(_nameController.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Profile updated successfully!"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                child: const Text("Update Profile",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
