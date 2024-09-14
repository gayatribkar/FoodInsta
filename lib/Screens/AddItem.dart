
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For uploading and clicking live images
import 'package:permission_handler/permission_handler.dart'; // For permission handling

class AddPostPage extends StatefulWidget {
  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _portionSizeController = TextEditingController();

  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    // Request permissions first
    if (source == ImageSource.gallery) {
      var status = await Permission.photos.request();
      if (status.isGranted) {
        final pickedFile = await _picker.pickImage(source: source);
        setState(() {
          _imageFile = pickedFile;
        });
      } else {
        print('Permission to access gallery denied');
      }
    } else if (source == ImageSource.camera) {
      var status = await Permission.camera.request();
      if (status.isGranted) {
        final pickedFile = await _picker.pickImage(source: source);
        setState(() {
          _imageFile = pickedFile;
        });
      } else {
        print('Permission to access camera denied');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Post', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green, // Theme color
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () => _showImageSourceDialog(),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.green),
                ),
                child: _imageFile == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.camera_alt, size: 50, color: Colors.green),
                          SizedBox(height: 10),
                          Text('Tap to upload or click an image', style: TextStyle(color: Colors.green)),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.file(
                          File(_imageFile!.path),
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _ingredientsController,
              decoration: InputDecoration(
                labelText: 'Food Ingredients',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _portionSizeController,
              decoration: InputDecoration(
                labelText: 'Portion Size',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            const SizedBox(height: 40),
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Clock-in logic here
                  },
                  icon: const Icon(Icons.timer, color: Colors.white),
                  label: const Text('Personal Clock In'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Post logic here
                  },
                  icon: const Icon(Icons.send, color: Colors.white),
                  label: const Text('Post It'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Show dialog for picking image source
  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(15),
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Upload from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}



// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Image Upload Landing Page',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const AddPostPage(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// class AddPostPage extends StatefulWidget {
//   const AddPostPage({super.key});

//   @override
//   _AddPostPageState createState() => _AddPostPageState();
// }

// class _AddPostPageState extends State<AddPostPage> {
//   XFile? _imageFile;
//   final ImagePicker _picker = ImagePicker();

// Future<void> _pickImage(ImageSource source) async {
//   print('Attempting to pick image from $source');
//   try {
//     if (source == ImageSource.gallery) {
//       var status = await Permission.photos.request();
//       print('Gallery permission status: $status');
//       if (status.isGranted) {
//         final pickedFile = await _picker.pickImage(source: source);
//         print('Picked file: $pickedFile');
//         if (pickedFile != null) {
//           setState(() {
//             _imageFile = pickedFile;
//           });
//         }
//       } else {
//         print('Permission to access gallery denied');
//       }
//     } else if (source == ImageSource.camera) {
//       var status = await Permission.camera.request();
//       print('Camera permission status: $status');
//       if (status.isGranted) {
//         final pickedFile = await _picker.pickImage(source: source);
//         print('Picked file: $pickedFile');
//         if (pickedFile != null) {
//           setState(() {
//             _imageFile = pickedFile;
//           });
//         }
//       } else {
//         print('Permission to access camera denied');
//       }
//     }
//   } catch (e) {
//     print('Error picking image: $e');
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Image Upload Landing Page'),
//         backgroundColor: Colors.green, // Theme color
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             GestureDetector(
//               onTap: () => _showImageSourceDialog(),
//               child: Container(
//                 height: 200,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[200],
//                   borderRadius: BorderRadius.circular(15),
//                   border: Border.all(color: Colors.green),
//                 ),
//                 child: _imageFile == null
//                     ? Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: const [
//                           Icon(Icons.camera_alt, size: 50, color: Colors.green),
//                           SizedBox(height: 10),
//                           Text('Tap to upload or click an image', style: TextStyle(color: Colors.green)),
//                         ],
//                       )
//                     : ClipRRect(
//                         borderRadius: BorderRadius.circular(15),
//                         child: Image.file(
//                           File(_imageFile!.path),
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             // Additional UI elements (text fields, buttons) can be added here
//           ],
//         ),
//       ),
//     );
//   }

//   // Show dialog for picking image source
//   void _showImageSourceDialog() {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return Container(
//           padding: const EdgeInsets.all(15),
//           child: Wrap(
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.photo_library),
//                 title: const Text('Upload from Gallery'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _pickImage(ImageSource.gallery);
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.camera_alt),
//                 title: const Text('Take a Photo'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _pickImage(ImageSource.camera);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
