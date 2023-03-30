import 'package:chatappdemo/src/domain/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class UserService {
  void saveUserInfo({required UserInfoModel userInfo});

  void updateUserAvatar({required String url});

  void updateUserName({required String newName});

  void addMsgToken({required String? token});

  void removeMsgToken({required String token});

  Future<List<String>> getMsgToken({required String id});

  Stream<QuerySnapshot> userStream({required String textSearch});

  Future<DocumentSnapshot> getUserInfo({required String id});
  Stream<List<UserInfoModel>> getAllUser();
  Stream<List<UserInfoModel>> getUserAdd(List<String> listMember);
  Stream<UserInfoModel> getUser(String uid);
}
