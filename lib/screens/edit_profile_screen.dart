import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/models/user_model.dart';

import 'package:instagram_clone/services/services.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;

  const EditProfileScreen({@required this.user});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name, _bio;
  File _profileImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _name = widget.user.name;
    _bio = widget.user.bio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Edit Profile',
          style: const TextStyle(color: Colors.black, fontSize: 18.0),
        ),
      ),
      body: Builder(
        builder: (context) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height -
                    Scaffold.of(context).appBarMaxHeight,
                width: double.infinity,
                child: Column(
                  children: <Widget>[
                    _isLoading
                        ? LinearProgressIndicator(
                            backgroundColor: Colors.blue,
                            valueColor:
                                const AlwaysStoppedAnimation(Colors.white70),
                          )
                        : const SizedBox.shrink(),
                    Stack(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: _displayProfileImage(),
                            radius: 52.0,
                          ),
                        ),
                        Positioned(
                          bottom: 4.0,
                          right: 0.0,
                          child: InkWell(
                            onTap: _handelImageFromGallery,
                            child: Container(
                              width: 34.0,
                              height: 34.0,
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(70, 0, 0, 255),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 20.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: TextFormField(
                              initialValue: _name,
                              decoration: InputDecoration(
                                icon: const Icon(
                                  Icons.person,
                                  size: 28.0,
                                ),
                                labelText: 'Name',
                              ),
                              validator: (inputValue) =>
                                  inputValue.trim().isEmpty
                                      ? 'Invalid name'
                                      : null,
                              onSaved: (inputValue) => _name = inputValue,
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: TextFormField(
                              initialValue: _bio,
                              decoration: InputDecoration(
                                icon: const Icon(
                                  Icons.book,
                                  size: 28.0,
                                ),
                                labelText: 'Bio',
                              ),
                              validator: (inputValue) =>
                                  inputValue.trim().length > 100
                                      ? 'Exceed more than 100 characters'
                                      : null,
                              onSaved: (inputValue) => _bio = inputValue,
                              maxLines: 5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    FlatButton(
                      color: Colors.blue,
                      onPressed: _submit,
                      child: Text(
                        'Save',
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  _submit() async {
    if (_formKey.currentState.validate() && !_isLoading) {
      _formKey.currentState.save();

      setState(() => _isLoading = true);

      final user = User(
        id: widget.user.id,
        email: widget.user.email,
        name: _name,
        bio: _bio,
        profileImageUrl: _profileImage == null
            ? widget.user.profileImageUrl
            : await Provider.of<StorageService>(context, listen: false)
                .uploadProfileImageAndGetDownloadUrl(
                    imageFile: _profileImage, url: widget.user.profileImageUrl),
      );

      await Provider.of<DatabaseService>(context, listen: false)
          .updateUser(user);

      Navigator.pop(context);
    }
  }

  _handelImageFromGallery() async {
    PickedFile pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  _displayProfileImage() {
    if (_profileImage == null) {
      if (widget.user.profileImageUrl.isEmpty) {
        return AssetImage('assets/images/user_placeholder.jpg');
      } else {
        return CachedNetworkImageProvider(widget.user.profileImageUrl);
      }
    } else {
      return FileImage(_profileImage);
    }
  }
}
