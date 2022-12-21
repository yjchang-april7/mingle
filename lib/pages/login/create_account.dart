import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mingle/pages/home/home_page.dart';
import 'package:mingle/providers/user_data.dart';
import 'package:mingle/themes.dart';

class CreateAccountPage extends ConsumerStatefulWidget {
  static const routename = '/create-account';

  const CreateAccountPage({Key? key}) : super(key: key);
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateAccountPageState();
}

class _CreateAccountPageState extends ConsumerState<CreateAccountPage> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _bio = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();

  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  bool _isLoading = false;

  Future<void> pickImage(ImagePicker picker) async {
    // If requestFullMetadata is set to true, the plugin tries to get the full image metadata
    // which may require extra permission requests on some platforms
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      requestFullMetadata: false,
    );
    setState(() {
      _image = image;
    });
    log(_image!.path);
  }

  late final _userData = ref.watch(userDataClassProvider);

  Future<void> createUser() async {
    _isLoading = true;
    if (!_formKey.currentState!.validate()) {
      _isLoading = false;
      return;
    }

    try {
      Uint8List? imageBytes =
          _image == null ? null : await _image!.readAsBytes();
      log(_userData.toString());
      _image != null
          ? await _userData
              .uploadProfilePicture(_image!.path, _image!.name, imageBytes!)
              .then((imgId) =>
                  _userData.addUser(_name.text, _bio.text, imgId ?? ''))
          : await _userData.addUser(
              _name.text, _bio.text, 'assets/images/avatar.png');
      log('_userData.getCurrentUser');
      final userData = await _userData.getCurrentUser();
      ref.watch(currentLoggedUserProvider.notifier).update((state) => userData);

      if (!mounted) {
        return;
      }

      await Navigator.of(context).pushReplacementNamed(HomePage.routename);
    } on Exception catch (e) {
      log('createUser Error \n ${(e as AppwriteException).message}');
      _isLoading = false;
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _bio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (FocusScope.of(context).hasFocus) {
          FocusScope.of(context).unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 50,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Create Your Profile',
                    style: Theme.of(context).textTheme.headline4?.copyWith(
                          fontSize: 24,
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Center(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(50),
                      enableFeedback: true,
                      onTap: () => pickImage(_picker),
                      child: Stack(
                        children: [
                          CircleAvatar(
                              radius: 56,
                              backgroundColor: MingleTheme.whiteShade1,
                              child: CircleAvatar(
                                radius: 52,
                                backgroundImage: _image == null
                                    ? const AssetImage(
                                            'assets/images/avatar.png')
                                        as ImageProvider<Object>
                                    : FileImage(File(_image!.path)),
                              )),
                          Positioned(
                            bottom: 2,
                            right: 0,
                            child: CircleAvatar(
                              backgroundColor: MingleTheme.whiteShade1,
                              radius: 15,
                              child: const Icon(
                                Icons.add,
                                size: 24,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: TextFormField(
                    autocorrect: true,
                    enableSuggestions: true,
                    controller: _name,
                    keyboardType: TextInputType.name,
                    onSaved: (newValue) {},
                    decoration: const InputDecoration(
                      hintText: 'Name',
                      alignLabelWithHint: true,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: MingleTheme.whiteShade1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextFormField(
                    autocorrect: true,
                    controller: _bio,
                    enableSuggestions: true,
                    maxLines: 7,
                    maxLength: 100,
                    keyboardType: TextInputType.text,
                    onSaved: (newValue) {},
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Bio',
                      alignLabelWithHint: true,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'It must not be empty';
                      }
                      return null;
                    },
                  ),
                ),
                const Spacer(),
                _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        padding: const EdgeInsets.only(top: 48.0),
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        width: double.infinity,
                        child: MaterialButton(
                          onPressed: createUser,
                          textTheme: ButtonTextTheme.primary,
                          minWidth: 100,
                          padding: const EdgeInsets.all(18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                            side: BorderSide(color: MingleTheme.whiteShade1),
                          ),
                          child: const Text(
                            'Create User',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                const Spacer(
                  flex: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
