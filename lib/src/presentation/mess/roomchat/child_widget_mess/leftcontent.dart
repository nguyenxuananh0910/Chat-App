import 'package:chatappdemo/core/components/custom_text.dart';
import 'package:chatappdemo/src/domain/model/message.dart';
import 'package:chatappdemo/src/presentation/mess/roomchat/child_widget_mess/chat_case.dart';
import 'package:chatappdemo/theme/colors.dart';
import 'package:chatappdemo/utils/get_color.dart';
import 'package:chatappdemo/utils/time_format.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LeftContent extends StatelessWidget {
  final MessageModel? last;
  final MessageModel current;
  final MessageModel? next;
  final bool isHienThiGio;

  const LeftContent({
    Key? key,
    required this.current,
    required this.last,
    required this.next,
    this.isHienThiGio = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    // return Row(
    //   mainAxisAlignment: MainAxisAlignment.start,
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         // if ((next == null && current.sendby != user?.uid) ||
    //         //     (current.sendby == last?.sendby))
    //         StreamBuilder<DocumentSnapshot>(
    //             stream: FirebaseFirestore.instance
    //                 .collection('users')
    //                 .doc(current.sendby)
    //                 .snapshots(),
    //             builder: (context, snapshot) {
    //               if (snapshot.data != null) {
    //                 return Row(
    //                   children: [
    //                     Padding(
    //                         padding: const EdgeInsets.only(top: 30),
    //                         child: CustomText(
    //                           text: snapshot.data?['name'],
    //                         )),
    //                   ],
    //                 );
    //               }
    //               return Container();
    //             }),
    //         Padding(
    //           padding:
    //               const EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
    //           child: Container(
    //             decoration: BoxDecoration(
    //                 color: Colors.grey[700],
    //                 borderRadius: const BorderRadius.only(
    //                   topRight: Radius.circular(10),
    //                   topLeft: Radius.circular(10),
    //                   bottomRight: Radius.circular(10),
    //                 )),
    //             child: ChatBubble(message: current),
    //           ),
    //         ),
    //         // if (isHienThiGio)
    //         Padding(
    //           padding: const EdgeInsets.symmetric(horizontal: 8.0),
    //           child: CustomText(
    //             // textAlign: current.sendBy == user?.uid
    //             //     ? TextAlign.right
    //             //     : TextAlign.left,
    //             text: dayFormat(current.time!),
    //             textSize: 15,
    //             fontWeight: FontWeight.w400,
    //             textColor: getSuitableColor(AppColor.black, AppColor.white),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ],
    // );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(current.sendby)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // if (current.sendby != last?.sendby)
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(snapshot
                                  .data?['photoURL'] ==
                              ""
                          ? "https://png.pngtree.com/png-vector/20190805/ourlarge/pngtree-account-avatar-user-abstract-circle-background-flat-color-icon-png-image_1650938.jpg"
                          : snapshot.data?['photoURL']),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 5),
                      //   child: CustomText(
                      //     text: snapshot.data?['name'],
                      //     textSize: 18,
                      //     textColor:
                      //         getSuitableColor(AppColor.black, AppColor.white),
                      //     fontWeight: FontWeight.w400,
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 5.0, top: 20.0, bottom: 10),
                        child: Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.65),
                          decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(10),
                                topLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              )),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: CustomText(
                              textSize: 18,
                              text: current.message!,
                              textColor: getSuitableColor(
                                  AppColor.black, AppColor.white),
                            ),
                          ),
                        ),
                      ),

                      if (isHienThiGio)
                        CustomText(
                          text: dayFormat(current.time!),
                          textSize: 15,
                          fontWeight: FontWeight.w300,
                          textColor:
                              getSuitableColor(AppColor.black, AppColor.white),
                        ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  )
                ],
              );
            }
            return Container();
          }),
    );
  }
}
