import 'package:chatappdemo/src/domain/model/user.dart';
import 'package:chatappdemo/src/domain/services/authen_service.dart';
import 'package:chatappdemo/src/domain/services/user_service.dart';
import 'package:chatappdemo/src/presentation/mess/roomchat/child_widget_mess/updategroup/child_widget_updategroup/add_member_page_view.dart';
import 'package:chatappdemo/src/presentation/mess/roomchat/child_widget_mess/updategroup/updategroup_page_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../../../../../infrastructure/repositories/user_repo.dart';

class AddMemberController extends GetxController {
  String? groupidChat;
  String? idGroupChat;
  List<String>? listCurrentMember;
  // List<String>? listName;
  final AuthenService _auThenService = Get.find();
  final RxList<ListMenber> membersList = <ListMenber>[].obs;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;
  final RxList<UserInfoModel> users = <UserInfoModel>[].obs;
  // final AuthenService _authenService = Get.find();
  final UserService userService = UserRepo();
  late CollectionReference collectionReference;
  @override
  void onInit() {
    groupidChat = Get.arguments['groupChatId'];
    listCurrentMember = Get.arguments['listMember'];
    // TODO: implement onInit
    super.onInit();
    users.bindStream(userService.getUserAdd(listCurrentMember!));
    idGroupChat = groupidChat;
    // listName = listCurrentMember;
  }

  Future addMembers(UserInfoModel? user) async {
    membersList.add(
      ListMenber(
        id: user!.idUsers!,
        name: user.name!,
        photoURL: user.urlAvatar!,
      ),
    );
    // refresh lai man
    users.refresh();
  }

  Future removeMembers(int index) async {
    membersList.removeAt(index);
    users.refresh();
  }

  void onAddMember() async {
    await firestore.collection('group').doc(idGroupChat).update({
      "menber": [
        ...?listCurrentMember,
        ...List.generate(
            membersList.length, (int index) => membersList[index].id)
      ],
    });
    await firestore
        .collection('users')
        .doc(_auThenService.currentUser!.uid)
        .collection('group')
        .doc(idGroupChat)
        .get();

    Get.toNamed(UpdateGroupPageView.routerName);
  }
}
