import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'firebase_options.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'download_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

// Main app scaffold
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Upload',
      theme: ThemeData(
        primarySwatch: Colors.indigo
      ),
      home: const HomePage(),
    );
  }
}

// The main screen that lists the images in firebase
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseStorage storage = FirebaseStorage.instance;

  // Display a message in a Snackbar widget
  void displaySnackbarMessage(String message) {
    var snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Upload an image via camera or gallery app on mobile to
  // a storage bucket in Firebase
  Future<void> _upload(String input) async {
    final picker = ImagePicker();
    XFile? pickedImage;

    try {
      // Wait for the user to grab an image
      pickedImage = await picker.pickImage(
        source: input == 'camera' ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 1440,
      );

      // Get metadata of image file to pass to Firebase
      final String fileName = path.basename(pickedImage!.path);
      File imageFile = File(pickedImage.path);

      // Upload to Firebase Storage
      var status = await storage.ref(fileName).putFile(imageFile);

      // Show a message on screen on success or failure
      if (status.state == TaskState.success) {
        displaySnackbarMessage('Image uploaded!');
      } else {
        displaySnackbarMessage('There was an error in uploading the image');
      }
      // Refresh UI
      setState(() {});
    } on FirebaseException catch (error) {
      if (kDebugMode) {
        print('Firebase Exception: $error');
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Uploader'),
      ),
      body: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            OutlinedButton.icon(
              icon: const Icon(Icons.camera_alt),
              onPressed: () => _upload('camera'),
              label: const Text('Upload from Camera'),
            ),
            OutlinedButton.icon(
              icon: const Icon(Icons.image),
              onPressed: () => _upload('gallery'),
              label: const Text('Upload from Gallery'),
            ),
          ],
        ),
        const FireStoreImageList(),
      ]),
    );
  }
}

// Get Firestore contents and output into ListView
class FireStoreImageList extends StatefulWidget {
  const FireStoreImageList({Key? key}) : super(key: key);

  @override
  State<FireStoreImageList> createState() => _FireStoreImageListState();
}

class _FireStoreImageListState extends State<FireStoreImageList> {
  final Stream<QuerySnapshot> _imageStream = FirebaseFirestore.instance
      .collection('thumbnails') // changed to match collection name
      .snapshots(includeMetadataChanges: true);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _imageStream,
      builder: (context, snapshot) {
        try {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }
          return Expanded(
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.all(10),
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return ImageCard(data: data);
              }).toList(),
            ),
          );
        } catch (err) {
          if (kDebugMode) {
            print(err);
          }
        }
        return const Text('An error has occurred');
      },
    );
  }
}

// Parse passed data into Card widget
class ImageCard extends StatelessWidget {
  const ImageCard({
    Key? key,
    required this.data,
  }) : super(key: key);

  final Map<String, dynamic> data;

  Future<void> _downloadFile() async {
    DownloadService downloadService = DownloadService();
    await downloadService.download(data: data);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: ListTile(
        dense: true,
        onTap: () async {
          _downloadFile();
        },
        leading: ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
          child: CachedNetworkImage(
            imageUrl: data['thumbnailPath'], // changed to match collection field name
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) =>
                const Icon(Icons.broken_image),
          ),
        ),
        title: Text(data['fileName']), // changed to match collection field name
        subtitle: const Text('Subtitle'),
      ),
    );
  }
}

class DocScreen extends StatelessWidget {
  const DocScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Screen')),
      body: const Center(
        child: Text(
          'This is a new screen',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
