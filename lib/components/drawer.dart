import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../constants.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({super.key});

  @override
  State<MenuDrawer> createState() => MenuDrawerState();
}

class MenuDrawerState extends State<MenuDrawer> {
  final _auth = FirebaseAuth.instance;
  String? newName;

  Future<void> pickImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 75,
    );
    if (image != null) {
      Reference reference = FirebaseStorage.instance
          .ref()
          .child('${_auth.currentUser!.uid}profilepic.jpg');

      await reference.putFile(File(image.path));
      reference.getDownloadURL().then((value) {
        setState(() {
          _auth.currentUser!.updatePhotoURL(value);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF15222b),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(50),
                          splashColor: const Color(0xFF4467A3),
                          onTap: () {
                            pickImage();
                          },
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                border:
                                    Border.all(width: 2, color: Colors.white24),
                                borderRadius: BorderRadius.circular(360)),
                            child: _auth.currentUser!.photoURL == null
                                ? const Icon(
                                    Icons.person,
                                    size: 50,
                                    color: Colors.white,
                                  )
                                : ClipOval(
                                    child: Image(
                                    image: NetworkImage(
                                      _auth.currentUser!.photoURL!,
                                    ),
                                    fit: BoxFit.cover,
                                  )),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 80,
                        top: 80,
                        child: InkWell(
                          onTap: () {
                            pickImage();
                          },
                          child: const Icon(
                            Icons.add_a_photo,
                            color: Color(0xD7FFFFFF),
                            shadows: [
                              Shadow(
                                blurRadius: 20,
                                color: Colors.black,
                                offset: Offset(-2, -4),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    child: Text(
                      newName != null
                          ? newName!
                          : _auth.currentUser!.displayName.toString(),
                      style: const TextStyle(
                        color: Color(0xFF23A3A3),
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    _auth.currentUser!.email.toString(),
                    style:
                        const TextStyle(color: Colors.blueGrey, fontSize: 20),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Image.asset(
                'assets/images/flash.png',
                opacity: const AlwaysStoppedAnimation(0.7),
              ),
            ),
            SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  drawerButtons(
                      text: 'Verify email',
                      onPressed: () {
                        if (_auth.currentUser!.emailVerified != true) {
                          _auth.currentUser!.sendEmailVerification();
                        }
                        Alert(
                          context: context,
                          style: KAlertStyle,
                          title: _auth.currentUser!.emailVerified
                              ? 'Yahoo'
                              : 'Check your Inbox',
                          desc: _auth.currentUser!.emailVerified
                              ? 'Your email has already verified'
                              : 'We have sent a verification link to your email adress.',
                          buttons: [
                            DialogButton(
                                child: Text(
                                  'OK',
                                  style: KAlertButtonTextStyle,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                })
                          ],
                        ).show();
                      }),
                  drawerButtons(
                      text: 'Change user name',
                      onPressed: () {
                        Alert(
                          context: context,
                          style: KAlertStyle,
                          content: Column(
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: TextFormField(
                                  onChanged: (value) {
                                    setState(() {
                                      newName = value;
                                    });
                                  },
                                  style: KTextFieldTextStyle,
                                  decoration: KTextFieldDecoration.copyWith(
                                    hintText: 'Enter your name',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          buttons: [
                            DialogButton(
                              color: Colors.blueGrey,
                              child: Text(
                                'Cancel',
                                style: KAlertButtonTextStyle,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            DialogButton(
                              child: Text(
                                'Update',
                                style: KAlertButtonTextStyle,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                setState(() async {
                                  await _auth.currentUser!
                                      .updateDisplayName(newName);
                                });
                              },
                            ),
                          ],
                        ).show();
                      }),
                  drawerButtons(
                    text: 'Logout',
                    color: const Color(0xFFBC4444),
                    onPressed: () {
                      KAlertDialogBox(
                        context: context,
                        titleText: 'Are you sure!',
                        descriptionText: 'You want to logout?',
                        buttonText: 'Logout',
                        buttonColor: Colors.redAccent,
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(context, 'welcome');
                        },
                      ).show();
                    },
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Found any issue!',
                        style: TextStyle(
                            color: Color.fromARGB(255, 96, 143, 166),
                            fontSize: 16),
                      ),
                      const SizedBox(width: 4),
                      InkWell(
                        borderRadius: BorderRadius.circular(20),
                        splashColor: Colors.black,
                        onTap: () {
                          String url =
                              'https://github.com/ahmad-dev7/Flash_Chat';
                          Uri uri = Uri.parse(url);
                          launchUrl(mode: LaunchMode.externalApplication, uri);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 0.2, color: Colors.blueGrey),
                              borderRadius: BorderRadius.circular(20)),
                          child: const Row(
                            children: [
                              Text(
                                'Report here',
                                style: TextStyle(color: Colors.blueAccent),
                              ),
                              SizedBox(width: 2),
                              FaIcon(
                                FontAwesomeIcons.arrowUpRightFromSquare,
                                color: Colors.blueAccent,
                                size: 14,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
