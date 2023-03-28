import 'package:chatappdemo/src/domain/services/authen_service.dart';
import 'package:chatappdemo/src/domain/services/message_service.dart';
import 'package:chatappdemo/src/domain/services/user_service.dart';
import 'package:chatappdemo/src/infrastructure/repositories/authen_repo.dart';
import 'package:chatappdemo/src/infrastructure/repositories/message_repo.dart';
import 'package:chatappdemo/src/infrastructure/repositories/user_repo.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class GlobalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Dio(), fenix: true);
    Get.lazyPut<AuthenService>(() => AuthenRepo(), fenix: true);
    Get.lazyPut<UserService>(() => UserRepo(), fenix: true);
    //
  }
}
