import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class Common{

  static Future saveImage(_file)async{
    if(_file!=null){
      Reference reference=FirebaseStorage.instance.ref().child("Story").child(Uuid().v1());
      UploadTask uploadTask=reference.putFile(_file);
      var downloadUrl=(await uploadTask);
      return downloadUrl.ref.getDownloadURL();
    }
  }
}