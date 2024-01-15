import 'package:cucumber_admin/presentation/views/chat/chat.dart';
import 'package:cucumber_admin/presentation/views/chat/chatlist.dart';
import 'package:cucumber_admin/presentation/views/products/products.dart';
import 'package:cucumber_admin/presentation/views/qa_part/all_users.dart';
import 'package:cucumber_admin/presentation/views/qa_part/location.dart';
import 'package:cucumber_admin/presentation/views/todays_collection/todays_collection.dart';
import 'package:cucumber_admin/presentation/widgets/common_widgets.dart';
import 'package:cucumber_admin/presentation/widgets/home_widgets.dart';
import 'package:cucumber_admin/utils/constants/constants.dart';
import 'package:flutter/material.dart';

class MainScreensNav extends StatelessWidget {
  const MainScreensNav({
    super.key,
    required this.greeting,
    required this.username,
    required this.context,
  });

  final String greeting;
  final String username;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(45),
          child: Captions(
            captionColor: kwhite,
            captions: '$greeting, $username',
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AllUsers(),
                )),
                child: const HomeContainer(
                  title: "User Management",
                  subtitle: 'View/Update user collection details',
                ),
              ),
              lheight,
              InkWell(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Products(),
                )),
                child: const HomeContainer(
                  title: "Products",
                  subtitle: 'Products details adding',
                ),
              ),
              lheight,
              InkWell(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => TodaysCollection(),
                )),
                child: const HomeContainer(
                    title: "Daily Schedules", subtitle: "See daily schedule"),
              ),

              // InkWell(
              // onTap: () =>
              // Navigator.of(context).push(MaterialPageRoute(
              //   builder: (context) =>  WeeklySchedule(),
              // )),
              //   child: const HomeContainer(
              //     title: "This week's schedule",
              //     subtitle: "See schedule",
              //   ),
              // ),
              lheight,
              InkWell(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ChatList(),
                      )),
                  child: const HomeContainer(
                    title: 'Chat Support',
                    subtitle: 'Talk to our customer executive',
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
