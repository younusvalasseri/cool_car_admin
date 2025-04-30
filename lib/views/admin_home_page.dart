import 'package:cool_car_admin/Widgets/today_count_card.dart';
import 'package:cool_car_admin/providers/providers.dart';
import 'package:cool_car_admin/views/new_users_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'admin_chat_list_page.dart';
import '../Widgets/admin_card.dart';
import '../Widgets/admin_sidebar.dart';
import '../Widgets/building_container.dart';
import '../Widgets/cool_car_app_bar.dart';
import '../Widgets/page_color.dart';
import 'active_requests_page.dart';
import 'active_users_page.dart';
import 'cool_car_revenue.dart';
import 'trip_history_page.dart';

class AdminHomePage extends ConsumerWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      drawer: const AdminSidebar(),
      appBar: CoolCarAppBar(customTitle: 'CoolCar Admin', showIcons: true),
      body: Container(
        decoration: BoxDecoration(
          gradient: PageColor.gradient(
            direction: GradientDirection.topToBottom,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 500, // Set max width like a mobile screen
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 10),
                            AdminCard(
                              title: "Rental History",
                              isFullWidth: true,
                              onTap:
                                  () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => TripHistoryPage(),
                                    ),
                                  ),
                            ),
                            const SizedBox(height: 10),
                            AdminCard(
                              title: "Active Requests",
                              isFullWidth: true,
                              onTap:
                                  () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ActiveRequestsPage(),
                                    ),
                                  ),
                            ),
                            const SizedBox(height: 10),
                            AdminCard(
                              title: "Revenue",
                              isFullWidth: true,
                              onTap:
                                  () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => CoolCarRevenuePage(),
                                    ),
                                  ),
                            ),
                            const SizedBox(height: 10),
                            AdminCard(
                              title: "Active Users",
                              isFullWidth: true,
                              onTap:
                                  () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ActiveUsersPage(),
                                    ),
                                  ),
                            ),
                            const SizedBox(height: 10),
                            TodayCountCard(
                              label: "🧑🏻 Today's Users",
                              isFullWidth: true,
                              stream: ref.watch(
                                todaysUsersStreamProvider.stream,
                              ),
                              onTap:
                                  () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const NewUsersPage(),
                                    ),
                                  ),
                            ),
                            const SizedBox(height: 10),
                            TodayCountCard(
                              label: "💬 New Messages",
                              isFullWidth: true,
                              stream: ref.watch(
                                unreadMessagesStreamProvider.stream,
                              ),
                              onTap:
                                  () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const AdminChatListPage(),
                                    ),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const BuildingContainer(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
