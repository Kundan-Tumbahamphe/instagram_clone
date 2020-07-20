import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/models/models.dart';
import 'package:instagram_clone/services/services.dart';
import 'package:provider/provider.dart';

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  File _postImage;
  final _captionController = TextEditingController();
  String _caption = '';
  bool _isLoading = false;

  _handelImage(ImageSource source) async {
    PickedFile pickedFile = await ImagePicker().getImage(source: source);

    if (pickedFile != null) {
      File image = File(pickedFile.path);

      File croppedImage = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Instagram Cropper',
          toolbarColor: Colors.blue,
          toolbarWidgetColor: Colors.white,
          backgroundColor: Colors.white,
          activeControlsWidgetColor: Colors.blue,
        ),
      );

      setState(() {
        _postImage = croppedImage;
      });
    }
  }

  _submit() async {
    if (!_isLoading && _postImage != null && _caption.isNotEmpty) {
      setState(() => _isLoading = true);

      String postImageUrl =
          await Provider.of<StorageService>(context, listen: false)
              .uploadPostImageAndGetDownloadUrl(_postImage);

      final post = Post(
        postImageUrl: postImageUrl,
        caption: _caption,
        likeCount: null,
        authorId: Provider.of<UserData>(context, listen: false).currentUserID,
        timestamp: Timestamp.fromDate(DateTime.now()),
      );

      await Provider.of<DatabaseService>(context, listen: false)
          .createPost(post);

      _captionController.clear();

      setState(() {
        _caption = '';
        _postImage = null;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Create Post',
            style: const TextStyle(color: Colors.black, fontSize: 18.0),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: _submit,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            height: 500.0,
            child: Column(
              children: <Widget>[
                _isLoading
                    ? LinearProgressIndicator(
                        backgroundColor: Colors.blue,
                        valueColor:
                            const AlwaysStoppedAnimation(Colors.white70),
                      )
                    : SizedBox.shrink(),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                      ),
                      context: context,
                      builder: (context) {
                        return Container(
                          padding: const EdgeInsets.all(20.0),
                          height: 155.0,
                          child: Column(
                            children: <Widget>[
                              Text(
                                'Add Photo',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 20.0,
                                ),
                              ),
                              const SizedBox(height: 12.0),
                              SizedBox(
                                height: 0.5,
                                child: Container(color: Colors.grey),
                              ),
                              const SizedBox(height: 12.0),
                              InkWell(
                                onTap: () {
                                  _handelImage(ImageSource.camera);
                                  Navigator.pop(context);
                                },
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.camera_alt,
                                      size: 27.0,
                                      color: Colors.redAccent,
                                    ),
                                    const SizedBox(width: 20.0),
                                    Text(
                                      'Use Camera',
                                      style: const TextStyle(fontSize: 18.0),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12.0),
                              InkWell(
                                onTap: () {
                                  _handelImage(ImageSource.gallery);
                                  Navigator.pop(context);
                                },
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.photo,
                                      size: 27.0,
                                      color: Colors.redAccent,
                                    ),
                                    const SizedBox(width: 20.0),
                                    Text(
                                      'Upload from Gallery',
                                      style: const TextStyle(fontSize: 18.0),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    height: width,
                    width: width,
                    color: Colors.grey[300],
                    child: _postImage == null
                        ? Icon(
                            Icons.add_a_photo,
                            color: Colors.white70,
                            size: 120.0,
                          )
                        : Image(
                            image: FileImage(_postImage),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                SizedBox(height: 18.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextField(
                    controller: _captionController,
                    decoration:
                        InputDecoration(labelText: 'Write a caption here :)'),
                    onChanged: (input) => _caption = input,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }
}
