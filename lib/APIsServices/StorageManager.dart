import 'package:firebase_storage/firebase_storage.dart';

class StorageManager {

  //final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final StorageReference _root = FirebaseStorage.instance.ref();


  Future<String> getImageURL(String photo) async {
    var flower = _root.child("flowers/$photo");
    String url = await flower.getDownloadURL();
    return url;
  }

}