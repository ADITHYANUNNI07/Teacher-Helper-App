import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduvista/model/usermodel.dart';

class FirebaseDatabase {
  final String? uid;
  FirebaseDatabase({required this.uid});
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('User');
  Future setUserDataFirebase(UserDetails user) async {
    return await userCollection.doc(uid).set({
      'Name': user.name,
      'PhoneNumber': user.phonenumber,
      'profilePic': user.profilepic ?? '',
      'Email': user.email,
      'InstitutionName': user.institutionname ?? '',
      'Subject': user.subject ?? '',
      'FolderName': user.folderName ?? '',
    });
  }
}
