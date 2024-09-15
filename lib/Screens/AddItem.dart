import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For uploading and clicking live images
import 'package:permission_handler/permission_handler.dart'; // For permission handling
import 'package:http/http.dart' as http; // For making HTTP requests

class AddPostPage extends StatefulWidget {
  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _portionSizeController = TextEditingController();
  final TextEditingController _captionController = TextEditingController(); // Caption field

  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    if (source == ImageSource.gallery) {
      if (Platform.isAndroid) {
        if (await _requestGalleryPermission()) {
          final pickedFile = await _picker.pickImage(source: source);
          setState(() {
            _imageFile = pickedFile;
          });
        } else {
          print('Permission to access gallery denied');
        }
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

  Future<bool> _requestGalleryPermission() async {
    if (Platform.isAndroid && Platform.operatingSystemVersion.contains("13")) {
      var status = await Permission.photos.request();
      return status.isGranted;
    } else {
      var status = await Permission.storage.request();
      return status.isGranted;
    }
  }

  Future<void> _postData() async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please select an image.'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    final uri = Uri.parse('http://172.29.96.140:5020/process_food');
    final request = http.MultipartRequest('POST', uri)
      ..fields['description'] = _descriptionController.text
      ..fields['portion_size'] = _portionSizeController.text
      ..fields['caption'] = _captionController.text
      ..files.add(await http.MultipartFile.fromPath('file', _imageFile!.path));

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final data = json.decode(responseString);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Post successful: ${data['detected_food']}'),
          backgroundColor: Colors.green,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Request failed with status: ${response.statusCode}'),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occurred: $e'),
        backgroundColor: Colors.red,
      ));
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
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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

            // Description field
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Description of the Image Along with Ingredient Details',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            const SizedBox(height: 20),

            // Caption field
            TextFormField(
              controller: _captionController,
              decoration: InputDecoration(
                labelText: 'Caption (Optional)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            const SizedBox(height: 20),

            // Portion Size field
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
                  onPressed: _postData,
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
// import 'package:image_picker/image_picker.dart'; // For uploading and clicking live images
// import 'package:permission_handler/permission_handler.dart'; // For permission handling

// class AddPostPage extends StatefulWidget {
//   @override
//   _AddPostPageState createState() => _AddPostPageState();
// }

// class _AddPostPageState extends State<AddPostPage> {
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _portionSizeController = TextEditingController();
//   final TextEditingController _captionController = TextEditingController(); // Caption field

//   XFile? _imageFile;
//   final ImagePicker _picker = ImagePicker();

//   Future<void> _pickImage(ImageSource source) async {
//     if (source == ImageSource.gallery) {
//       if (Platform.isAndroid) {
//         if (await _requestGalleryPermission()) {
//           final pickedFile = await _picker.pickImage(source: source);
//           setState(() {
//             _imageFile = pickedFile;
//           });
//         } else {
//           print('Permission to access gallery denied');
//         }
//       }
//     } else if (source == ImageSource.camera) {
//       var status = await Permission.camera.request();
//       if (status.isGranted) {
//         final pickedFile = await _picker.pickImage(source: source);
//         setState(() {
//           _imageFile = pickedFile;
//         });
//       } else {
//         print('Permission to access camera denied');
//       }
//     }
//   }

//   Future<bool> _requestGalleryPermission() async {
//     if (Platform.isAndroid && Platform.operatingSystemVersion.contains("13")) {
//       var status = await Permission.photos.request();
//       return status.isGranted;
//     } else {
//       var status = await Permission.storage.request();
//       return status.isGranted;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Add New Post', style: TextStyle(color: Colors.white)),
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
//                     ? const Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
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

//             // Description field
//             TextFormField(
//               controller: _descriptionController,
//               maxLines: 3,
//               decoration: InputDecoration(
//                 labelText: 'Description of the Image Along with Ingredient Details',
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                 filled: true,
//                 fillColor: Colors.grey[100],
//               ),
//             ),
//             const SizedBox(height: 20),

//             // Caption field
//             TextFormField(
//               controller: _captionController,
//               decoration: InputDecoration(
//                 labelText: 'Caption (Optional)',
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                 filled: true,
//                 fillColor: Colors.grey[100],
//               ),
//             ),
//             const SizedBox(height: 20),

//             // Portion Size field
//             TextFormField(
//               controller: _portionSizeController,
//               decoration: InputDecoration(
//                 labelText: 'Portion Size',
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                 filled: true,
//                 fillColor: Colors.grey[100],
//               ),
//             ),
//             const SizedBox(height: 40),

//             // Buttons
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton.icon(
//                   onPressed: () {
//                     // Clock-in logic here
//                   },
//                   icon: const Icon(Icons.timer, color: Colors.white),
//                   label: const Text('Personal Clock In'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.orange,
//                     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                   ),
//                 ),
//                 ElevatedButton.icon(
//                   onPressed: () {
//                     // Post logic here
//                   },
//                   icon: const Icon(Icons.send, color: Colors.white),
//                   label: const Text('Post It'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                   ),
//                 ),
//               ],
//             ),
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
