import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_catalog/common/widget/page_template.dart';
import 'package:movie_catalog/user/authentication.dart';

class AuthDetailsPage extends StatefulWidget {
  const AuthDetailsPage({super.key});

  @override
  State<AuthDetailsPage> createState() => _AuthDetailsPage();
}

class _AuthDetailsPage extends State<AuthDetailsPage> {
  final _userNameController = TextEditingController();
  final _userEmailController = TextEditingController();
  final _userPhotoUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser!;

    _userEmailController.text = user.email!;
    _userNameController.text =
        user.displayName != null ? user.displayName! : "";
    _userPhotoUrlController.text = user.photoURL != null ? user.photoURL! : "";
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return PageTemplate(
        title: "Auth details",
        child: Padding(
          padding: const EdgeInsets.only(right: 25.0, left: 25.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () async => {
                            await Authentication.signOut(context),
                            if (context.mounted)
                              {Navigator.pushReplacementNamed(context, "/")}
                          },
                      child: const Text("Sign Out")),
                  const SizedBox(
                    width: 20.0,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white),
                      onPressed: () async {
                        final response = await showDialog<bool?>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: const Text(
                                    "Do you really want to delete your account ? All data will be lost"),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text("No"),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.redAccent,
                                        foregroundColor: Colors.white),
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: const Text("Yes"),
                                  ),
                                ],
                              );
                            });
                        if (response != null && response == true) {
                          await user.delete();
                          if (context.mounted) {
                            Navigator.pushReplacementNamed(context, "/");
                          }
                        }
                      },
                      child: const Text("Delete account")),
                ],
              ),
              const SizedBox(
                height: 35.0,
              ),
              CircleAvatar(
                backgroundColor: const Color(0xffE6E6E6),
                foregroundImage: user.photoURL != null
                    ? Image.network(user.photoURL!).image
                    : null,
                radius: 30.0,
                child: const Icon(
                  Icons.person,
                  color: Color(0xffCCCCCC),
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              TextField(
                decoration:
                    const InputDecoration(hintText: "Email (*required)"),
                controller: _userEmailController,
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                decoration: const InputDecoration(hintText: "Name"),
                controller: _userNameController,
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                decoration: const InputDecoration(hintText: "Photo URL"),
                controller: _userPhotoUrlController,
              ),
              const SizedBox(
                height: 16.0,
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (user.email != _userEmailController.text) {
                      if (_userEmailController.text.isEmpty) return;
                      await user.updateEmail(_userEmailController.text);
                    }
                    if (user.displayName != _userNameController.text) {
                      await user.updateDisplayName(
                          _userNameController.text.isEmpty
                              ? null
                              : _userNameController.text);
                    }
                    if (user.photoURL != _userPhotoUrlController.text) {
                      await user.updatePhotoURL(
                          _userPhotoUrlController.text.isEmpty
                              ? null
                              : _userPhotoUrlController.text);
                    }
                    setState(() {});
                  },
                  child: const Text("Edit"))
            ],
          ),
        ));
  }
}
