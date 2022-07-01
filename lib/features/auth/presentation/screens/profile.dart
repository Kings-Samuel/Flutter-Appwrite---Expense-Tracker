import 'dart:typed_data';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterappwrite/core/presentation/routes.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../notifiers/auth_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _profilepicID = '';
  Map<String, dynamic>? country;
  Map<String, dynamic>? currency;
  bool _isLoading = false;

  Future<Preferences> _getProfilepicID(BuildContext context) async {
    _isLoading = true;
    return await context.read<AuthState>().getAccount.getPrefs().then((value) {
      country = value.data['country'] as Map<String, dynamic>;
      currency = value.data['currency'] as Map<String, dynamic>;
      _profilepicID = value.data['profilepicID'].toString();
      if (kDebugMode) {
        // print('country: ${country.toString()}');
        // print('currency: ${currency.toString()}');
        print('profilepicID: $_profilepicID');
      }
      Future.delayed(
        const Duration(seconds: 2),
        () => setState(() => _isLoading = false),
      );
      return value;
    });
  }

  @override
  void initState() {
    _getProfilepicID(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Profile'),
      ),
      body: Consumer<AuthState>(
        builder: (context, state, child) {
          if (state.isLoggedIn) {
            return pageUI(state);
          } else {
            return const Center(
              child: Text('You are not logged in'),
            );
          }
        },
      ),
    );
  }

  Widget pageUI(AuthState state) {
    return _isLoading == true
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ListView(
            padding: const EdgeInsets.all(15.0),
            children: [
              FutureBuilder(
                future: state.storage.getFilePreview(
                  bucketId: '6270303c205fdc6b2aa7',
                  fileId: _profilepicID,
                ),
                builder: (context, snapshot) {
                  return snapshot.hasData && snapshot.data != null
                      ? Container(
                          margin: const EdgeInsets.only(bottom: 15.0),
                          child: InkWell(
                            onTap: () => _uploadPic(context),
                            child: CircleAvatar(
                              radius: 75.0,
                              backgroundColor: Colors.red,
                              backgroundImage:
                                  MemoryImage(snapshot.data as Uint8List),
                            ),
                          ),
                        )
                      : const Center(child: CircularProgressIndicator());
                },
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  'Welcome ${state.user.name}',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(bottom: 30.0),
                child: Text(
                  '${state.user.email}',
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    state.logout();
                    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.signup,
                        (Route<dynamic> route) => false);
                  },
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.exit_to_app),
                      SizedBox(width: 10.0),
                      Text('Logout'),
                    ],
                  )))
            ],
          );
  }

  //upload profile pic function
  _uploadPic(BuildContext context) async {
    XFile? selectedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      AuthState state = Provider.of<AuthState>(context, listen: false);

      // ! only use multipartfile for large file uploads
      // final multipartFile = await MultipartFile.fromPath(
      //     selectedImage.name,
      //     selectedImage.path,
      //     filename: selectedImage.name,
      // );

      final inputFile = InputFile(
        // file: multipartFile,
        filename: selectedImage.name,
        path: selectedImage.path,
      );

      final uploadPic = state.storage.createFile(
        bucketId: '6270303c205fdc6b2aa7',
        fileId: 'unique()',
        file: inputFile,
        read: ['user:${state.user.id}'],
        write: ['user:${state.user.id}'],
        onProgress: (UploadProgress progress) {
          if (kDebugMode) {
            print('Progress ${progress.progress}%');
            print('Uploaded ${progress.chunksUploaded}%');
            print('Total ${progress.chunksTotal}%');
            print('Size ${progress.sizeUploaded}%');
          }
        },
      );

      uploadPic.then((response) async {
      final String id = response.$id;
      if (kDebugMode) {
        print('id: $id');
      }

      await state.storage
          .deleteFile(bucketId: '6270303c205fdc6b2aa7', fileId: _profilepicID);

      setState(() {
        _profilepicID = id;
      });

      state.updateUserPrefs({
        'country': country,
        'currency': currency,
        'profilepicID': id,
      });

      }).catchError((error) {
        if (kDebugMode) {
          print(error.toString());
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
          ),
        );
      });
    }
  }
}
