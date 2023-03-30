import 'package:chatappdemo/src/domain/model/group_model.dart';
import 'package:chatappdemo/src/domain/model/message.dart';

abstract class MessageService {
  Stream<List<GroupModel>> getAllChat(String uid);
  Stream<List<GroupModel>> getAllChatGroup(String uid);
  Stream<List<MessageModel>> getALlMessage(String idGroupChat);
  Stream<GroupModel> getGroup(String idChat);

  // Stream<MessageModel> getLastMes(String lastMess);
}
