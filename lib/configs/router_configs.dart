import 'package:chatappdemo/src/domain/services/message_service.dart';
import 'package:chatappdemo/src/infrastructure/repositories/message_repo.dart';
import 'package:chatappdemo/src/infrastructure/repositories/user_repo.dart';
import 'package:chatappdemo/src/presentation/account/child_widget_account/security.dart';
import 'package:chatappdemo/src/presentation/account/profile_ctrl.dart';
import 'package:chatappdemo/src/presentation/account/profile_page_view.dart';
import 'package:chatappdemo/src/presentation/contact/contact_page_ctrl.dart';
import 'package:chatappdemo/src/presentation/contact/contact_page_view.dart';
import 'package:chatappdemo/src/presentation/groupchat/group_ctrl.dart';
import 'package:chatappdemo/src/presentation/groupchat/group_page_view.dart';
import 'package:chatappdemo/src/presentation/login/login_ctrl.dart';
import 'package:chatappdemo/src/presentation/login/login_page_view.dart';
import 'package:chatappdemo/src/presentation/mess/listmessage/listmessage_ctrl.dart';
import 'package:chatappdemo/src/presentation/mess/listmessage/listmessage_page_view.dart';
import 'package:chatappdemo/src/presentation/mess/roomchat/roomchat_page_ctrl.dart';
import 'package:chatappdemo/src/presentation/mess/roomchat/roomchat_page_view.dart';
import 'package:chatappdemo/src/presentation/pages/root_app.dart';
import 'package:chatappdemo/src/presentation/signup/signup_page_ctrl.dart';
import 'package:chatappdemo/src/presentation/signup/signup_page_view.dart';
import 'package:chatappdemo/src/presentation/splash/landing_page.dart';
import 'package:get/get.dart';
import '../src/presentation/account/child_widget_account/update_profile/update_page_ctrl.dart';
import '../src/presentation/account/child_widget_account/update_profile/updateprofil_page_view.dart';
import '../src/presentation/groupchat/child_widget_group/adduser_ui.dart';
import '../src/presentation/mess/roomchat/child_widget_mess/updategroup/child_widget_updategroup/add_member_page_view.dart';
import '../src/presentation/mess/roomchat/child_widget_mess/updategroup/child_widget_updategroup/add_members_page_ctrl.dart';
import '../src/presentation/mess/roomchat/child_widget_mess/updategroup/updategroup_page_ctrl.dart';
import '../src/presentation/mess/roomchat/child_widget_mess/updategroup/updategroup_page_view.dart';

class RouterConfigs {
  static final routes = [
    GetPage(
      name: LoadingPage.routerName,
      page: () => const LoadingPage(),
    ),
    GetPage(
      name: RootApp.routerName,
      page: () => const RootApp(),
      binding: BindingsBuilder(
        () {
          Get.put(UserRepo());
          Get.put<MessageService>(MessageRepo());
          Get.put(ListmessageController());
          Get.lazyPut(() => GroupController());
          Get.lazyPut(() => ContactController());
          Get.lazyPut(() => ProfileController());
          // Get.lazyPut(() => const Contacts());
        },
      ),
    ),
    GetPage(
      name: LoginPageView.routerName,
      page: () => const LoginPageView(),
      binding: BindingsBuilder(
        () {
          // Get.put(LoginPageCtrl());
          Get.lazyPut(() => LoginController());
        },
      ),
    ),
    GetPage(
      name: ListMessagePageView.routerName,
      page: () => const ListMessagePageView(),
      binding: BindingsBuilder(
        () {
          Get.put(ListmessageController());
        },
      ),
    ),
    GetPage(
      name: GroupchatView.routerName,
      page: () => const GroupchatView(),
      binding: BindingsBuilder(
        () {
          Get.put(GroupController());
        },
      ),
    ),
    GetPage(
      name: ContactsPageView.routerName,
      page: () => const ContactsPageView(),
      binding: BindingsBuilder(
        () {
          Get.put(ContactController());
        },
      ),
    ),
    GetPage(
      name: ProfilePageView.routerName,
      page: () => const ProfilePageView(),
      binding: BindingsBuilder(
        () {
          Get.lazyPut(() => ProfileController());
        },
      ),
    ),
    GetPage(
      name: ChatAppPageView.routerName,
      page: () => const ChatAppPageView(),
      binding: BindingsBuilder(
        () {
          Get.put<MessageService>(MessageRepo());
          Get.lazyPut(() => RoomChatController());
        },
      ),
    ),
    GetPage(
      name: SignUpPageView.routerName,
      page: () => const SignUpPageView(),
      binding: BindingsBuilder(
        () {
          Get.lazyPut(() => SingUpController());
        },
      ),
    ),
    GetPage(
      name: AccountPageView.routerName,
      page: () => const AccountPageView(),
      binding: BindingsBuilder(
        () {
          Get.lazyPut(() => UpdateProfileController());
        },
      ),
    ),
    GetPage(
      name: UpdateGroupPageView.routerName,
      page: () => const UpdateGroupPageView(),
      binding: BindingsBuilder(
        () {
          Get.put(UpdateGroupController());
        },
      ),
    ),
    GetPage(
      name: Security.routerName,
      page: () => const Security(),
    ),
    GetPage(
      name: AddMemberGroup.routerName,
      page: () => const AddMemberGroup(),
      binding: BindingsBuilder(
        () {
          Get.put(AddMemberController());
        },
      ),
    ),
    GetPage(
      name: CreateGroup.routerName,
      page: () => const CreateGroup(),
    )
  ];
}
