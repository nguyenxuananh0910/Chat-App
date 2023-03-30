import 'package:flutter/material.dart';

import '../../../../core/components/custom_button.dart';
import '../../../../core/components/custom_text.dart';
import '../../../../core/components/customappbar.dart';
import '../../../../theme/colors.dart';

class Security extends StatelessWidget {
  static const routerName = '/Security';
  const Security({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.security_outlined),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert),
              ),
            ],
          )
        ],
        title: const CustomText(
          text: 'Security',
          textColor: AppColor.white,
          textSize: 25,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: SizedBox(
              width: 400,
              height: 50,
              child: CustomButton(
                color: Colors.grey[200]!,
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        SizedBox(
                          width: 10,
                        ),
                        CustomText(
                          text: 'Block',
                          textSize: 18,
                          textColor: AppColor.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                    const Icon(Icons.block)
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: SizedBox(
              width: 400,
              height: 50,
              child: CustomButton(
                color: Colors.grey[200]!,
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        SizedBox(
                          width: 10,
                        ),
                        CustomText(
                          text: 'Report a problem',
                          textSize: 18,
                          textColor: AppColor.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                    const Icon(Icons.arrow_forward_ios)
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: SizedBox(
              width: 400,
              height: 50,
              child: CustomButton(
                color: Colors.grey[200]!,
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        SizedBox(
                          width: 10,
                        ),
                        CustomText(
                          text: 'Account lock',
                          textSize: 18,
                          textColor: AppColor.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                    Icon(Icons.lock)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
