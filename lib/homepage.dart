import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';

enum ImageShape { original, heart, square, circle, rectangle }

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  final ImagePicker _picker = ImagePicker();
  File? imagePost;
  ImageShape selectedShape = ImageShape.original;

  Future<void> _imageUpload() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      File? croppedImage = await _cropImage(image.path);
      if (croppedImage != null) {
        setState(() {
          imagePost = croppedImage;
        });
        _showShapeSelectionDialog();
      }
    }
  }

  Future<File?> _cropImage(String imagePath) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePath,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Crop Image',
        )
      ],
    );
    return croppedFile != null ? File(croppedFile.path) : null;
  }

  void _showShapeSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Uploaded Image'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (imagePost != null) Image.file(imagePost!, height: 200),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildShapeButton(ImageShape.original, 'assets/images/user_image_frame_2.png'),
                    _buildShapeButton(ImageShape.heart, 'assets/images/user_image_frame_1.png'),
                    _buildShapeButton(ImageShape.square, 'assets/images/user_image_frame_2.png'),
                    _buildShapeButton(ImageShape.circle, 'assets/images/user_image_frame_3.png'),
                    _buildShapeButton(ImageShape.rectangle, 'assets/images/user_image_frame_4.png'),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {});
                },
                child: const Text('Use this image'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShapeButton(ImageShape shape, String assetPath) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedShape = shape;
        });
      },
      child: Image.asset(assetPath, height: 50, width: 50),
    );
  }

  Widget _buildShapedImage() {
    if (imagePost == null) return Container();

    Widget image = Image.file(imagePost!, fit: BoxFit.cover);

    switch (selectedShape) {
      case ImageShape.original:
        return Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              width: double.infinity,
              child: Image.asset('assets/images/user_image_frame_2.png', fit: BoxFit.cover),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              width: double.infinity,
              child: image,
            ),
          ],
        );
      case ImageShape.heart:
        return Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              width: double.infinity,
              child: Image.asset('assets/images/user_image_frame_1.png', fit: BoxFit.cover),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              width: double.infinity,
              child: ClipPath(
                clipper: HeartClipper(),
                child: image,
              ),
            ),
          ],
        );
      case ImageShape.square:
        return Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              width: double.infinity,
              child: Image.asset('assets/images/user_image_frame_2.png', fit: BoxFit.cover),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: image,
              ),
            ),
          ],
        );
      case ImageShape.circle:
        return Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              width: double.infinity,
              child: Image.asset('assets/images/user_image_frame_3.png', fit: BoxFit.cover),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              width: double.infinity,
              child: ClipOval(
                child: image,
              ),
            ),
          ],
        );
      case ImageShape.rectangle:
        return Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              width: double.infinity,
              child: Image.asset('assets/images/user_image_frame_4.png', fit: BoxFit.cover),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: image,
              ),
            ),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "Image",
                style: TextStyle(color: Colors.white, fontFamily: "Mulish"),
              ),
            ),
            SizedBox(height: 5),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.19,
                      width: MediaQuery.of(context).size.width * 0.41,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                      child: imagePost == null
                          ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset('assets/images/images (7).png'),
                      )
                          : Container(),
                    ),
                    InkWell(
                      onTap: _imageUpload,
                      child: const Padding(
                        padding: EdgeInsets.only(top: 114, left: 100, right: 20),
                        child: CircleAvatar(
                          backgroundColor: Colors.blue,
                          maxRadius: 15,
                          child: Icon(
                            Icons.camera_alt,
                            size: 17,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20), // Add some space between the widgets
            if (imagePost != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: double.infinity,
                  child: _buildShapedImage(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class HeartClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width / 2, size.height / 5);
    path.cubicTo(
        size.width / 5, 0, 0, size.height / 3.5, size.width / 2, size.height);
    path.cubicTo(size.width, size.height / 3.5, 4 * size.width / 5, 0,
        size.width / 2, size.height / 5);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
