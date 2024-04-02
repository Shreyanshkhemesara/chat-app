import "dart:developer";
import "dart:io";

import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:google_sign_in/google_sign_in.dart";
import "package:image_picker/image_picker.dart";
import "package:kittie_chat/helper/dialogs.dart";
import "package:kittie_chat/main.dart";
import "package:kittie_chat/model/chat_user.dart";
import "package:kittie_chat/screens/api.dart";
import "package:kittie_chat/screens/auth/login_scren.dart";

class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _image;
  final _formKey = GlobalKey<FormState>();
  var about = APIs.me.about;
  var name = APIs.me.name;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Screen'),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton.extended(
          onPressed: () async {
            Dialogs.ShowProgressBar(context);
            await APIs.auth.signOut().then((value) async {
              await GoogleSignIn().signOut();
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()));
            });
          },
          icon: const Icon(Icons.logout),
          label: const Text('Logout'),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(
              width: mq.width,
              height: mq.height * .03,
            ),
            Stack(
              children: [
                _image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(mq.height * .1),
                        child: Image.file(
                          File(_image!),
                          width: mq.height * .2,
                          height: mq.height * .2,
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(mq.height * .1),
                        child: CachedNetworkImage(
                          width: mq.height * .2,
                          height: mq.height * .2,
                          imageUrl: widget.user.image,
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: MaterialButton(
                    onPressed: () {
                      _showBottomSheet();
                    },
                    shape: CircleBorder(),
                    child: const Icon(Icons.edit),
                    color: Colors.white,
                  ),
                )
              ],
            ),
            SizedBox(
              height: mq.height * .03,
            ),
            Text(
              widget.user.email,
              style: const TextStyle(color: Colors.black54, fontSize: 16),
            ),
            SizedBox(
              height: mq.height * .05,
            ),
            TextFormField(
              initialValue: widget.user.name,
              onSaved: (val) =>
                  APIs.me = APIs.me.copyWith(name: name = val ?? ''),
              validator: (val) =>
                  val != null && val.isNotEmpty ? null : 'Required Field',
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  hintText: 'eg. ABc efg',
                  label: Text('Name ')),
            ),
            SizedBox(
              height: mq.height * .02,
            ),
            TextFormField(
              initialValue: widget.user.about,
              onSaved: (val) =>
                  APIs.me = APIs.me.copyWith(about: about = val ?? ''),
              validator: (val) =>
                  val != null && val.isNotEmpty ? null : 'Required Field',
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.cloud),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  hintText: 'eg. Hey! I am using kittie chat',
                  label: Text('About')),
            ),
            SizedBox(
              height: mq.height * .05,
            ),
            ElevatedButton.icon(
                // style: ElevatedButton.styleFrom(
                //     shape: const StadiumBorder(),
                //     minimumSize: Size(mq.width * .5, mq.height * .06)),
                onPressed: () async {
                  _formKey.currentState!.save();
                  APIs.updateUserInfo(name, about).then((value) {
                    Dialogs.ShowSnackBar(
                        context, 'Profile Updated Successfully!');
                  });
                },
                icon: const Icon(
                  Icons.edit,
                  size: 30,
                ),
                label: const Text('Update')),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet() {
    // show bottom sheets ko koi scaffold gesture handle BT horhi hai - modalSheets then;
    // https://howtoflutter.dev/how-to-solve-no-scaffold-widget-found-error-in-flutter-when-using-showbottomsheet/
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ElevatedButton(
              onPressed: () async {
                final ImagePicker picker = ImagePicker();
                // Pick an image.
                final XFile? image = await picker.pickImage(
                    source: ImageSource.camera, imageQuality: 80);
                if (image != null) {
                  log('imagepath: ${image.path} -- MimeType : ${image.mimeType}');
                  setState(() {
                    _image = image.path;
                  });
                  APIs.updateProfilePicture(File(_image!));
                }
                Navigator.pop(context);
              },
              child: ListTile(
                leading: Icon(IconData(0xf60b, fontFamily: 'MaterialIcons')),
                title: Text('Camera'),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final ImagePicker picker = ImagePicker();
                // Pick an image.
                final XFile? image = await picker.pickImage(
                    source: ImageSource.gallery, imageQuality: 80);
                if (image != null) {
                  log('imagepath: ${image.path} -- MimeType : ${image.mimeType}');
                  setState(() {
                    _image = image.path;
                  });
                  APIs.updateProfilePicture(File(_image!));
                }
                Navigator.pop(context);
              },
              child: ListTile(
                leading: Icon(Icons.photo),
                title: Text('pick from photos'),
              ),
            ),
          ],
        );
      },
    );

    // showModalBottomSheet(
    //     context: context,
    //     builder: (_) {
    //       return SizedBox();
    //     });
  }
}
