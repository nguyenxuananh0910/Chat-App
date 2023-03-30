import 'package:chatappdemo/configs/api_path.dart';
import 'package:chatappdemo/src/domain/model/user.dart';
import 'package:chatappdemo/src/domain/services/authen_service.dart';
import 'package:chatappdemo/src/domain/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class UserRepo implements UserService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final AuthenService _authenService = Get.find();
  // UserRepo({required this.uid});

  // final String uid;
  // String get userid => uid;
  @override
  void saveUserInfo({required UserInfoModel userInfo}) {
    try {
      final path = APIPath.user(userInfo.idUsers ?? "");
      final documentReference = FirebaseFirestore.instance.doc(path);
      documentReference.set(userInfo.toMap());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<QuerySnapshot> userStream({required String textSearch}) {
    final path = APIPath.users();
    return FirebaseFirestore.instance
        .collection(path)
        .where('name', isEqualTo: textSearch)
        .snapshots();
  }

  @override
  Future<DocumentSnapshot> getUserInfo({required String id}) async {
    final path = APIPath.user(id);
    return await FirebaseFirestore.instance.doc(path).get();
  }

  @override
  void updateUserAvatar({required String url}) {
    final path = APIPath.user(_authenService.currentUser!.uid);
    final documentReference = FirebaseFirestore.instance.doc(path);
    documentReference.update({'photoURL': url});
  }

  @override
  void updateUserName({required String newName}) {
    final path = APIPath.user(_authenService.currentUser!.uid);
    final documentReference = FirebaseFirestore.instance.doc(path);
    documentReference.update({'name': newName});
  }

  @override
  void addMsgToken({required String? token}) {
    if (token == null) return;
    final path = APIPath.user(_authenService.currentUser!.uid);
    final documentReference = FirebaseFirestore.instance.doc(path);
    documentReference.update({
      'msgToken': FieldValue.arrayUnion([token])
    });
  }

  @override
  void removeMsgToken({required String token}) {
    final path = APIPath.user(_authenService.currentUser!.uid);
    final documentReference = FirebaseFirestore.instance.doc(path);
    documentReference.update({
      'msgToken': FieldValue.arrayRemove([token])
    });
  }

  @override
  Future<List<String>> getMsgToken({required String id}) async {
    final path = APIPath.user(id);
    final documentSnapshot = await FirebaseFirestore.instance.doc(path).get();
    return documentSnapshot.get('msgToken').cast<String>();
  }

  @override
  Stream<List<UserInfoModel>> getAllUser() {
    late final CollectionReference collectionReference =
        firestore.collection('users');
    return collectionReference.snapshots().map((query) =>
        query.docs.map((item) => UserInfoModel.fromDocument(item)).toList());
  }

  @override
  Stream<UserInfoModel> getUser(uid) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .snapshots()
        .map((item) => UserInfoModel.fromDocument(item));
  }

  @override
  Stream<List<UserInfoModel>> getUserAdd(List<String> listMember) {
    late final CollectionReference collectionReference =
        firestore.collection('users');
    return collectionReference.snapshots().map((query) => query.docs
        .map((item) {
          return UserInfoModel.fromDocument(item);
        })
        .where((element) => !listMember.contains(element.idUsers))
        .toList());
  }
}
