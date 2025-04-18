import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../Widgets/cool_car_app_bar.dart';
import 'admin_chat_page.dart';
import 'chat_user_tile.dart';

class AdminChatListPage extends ConsumerWidget {
  const AdminChatListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latestChatsAsync = ref.watch(latestChatsProvider);

    return Scaffold(
      appBar: CoolCarAppBar(customTitle: 'Live Chats', showIcons: false),
      body: latestChatsAsync.when(
        data: (chatSnapshot) {
          final chatDocs = chatSnapshot.docs;

          final Map<String, Map<String, dynamic>> lastMessagesByUser = {};

          for (var doc in chatDocs) {
            final data = doc.data() as Map<String, dynamic>;
            final userId = doc.reference.parent.parent?.id;

            if (userId != null && !lastMessagesByUser.containsKey(userId)) {
              lastMessagesByUser[userId] = {
                'text': data['text'] ?? '[No message]',
                'timestamp': (data['timestamp'] as Timestamp?)?.toDate(),
              };
            }
          }

          if (lastMessagesByUser.isEmpty) {
            return const Center(child: Text("No messages yet."));
          }

          return ListView(
            children:
                lastMessagesByUser.entries.map((entry) {
                  final userId = entry.key;
                  final messageData = entry.value;
                  final userDataAsync = ref.watch(userDataProvider(userId));
                  final unreadCountAsync = ref.watch(
                    unreadCountProvider(userId),
                  );

                  return userDataAsync.when(
                    data: (userData) {
                      final userName = userData?['name'] ?? 'User ID: $userId';
                      final photoUrl = userData?['profilePhoto'];

                      return unreadCountAsync.when(
                        data:
                            (unreadCount) => ChatUserTile(
                              userId: userId,
                              userName: userName,
                              photoUrl: photoUrl,
                              message: messageData['text'],
                              timestamp: messageData['timestamp'],
                              unreadCount: unreadCount,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => AdminChatPage(userId: userId),
                                  ),
                                );
                              },
                            ),
                        loading: () => const SizedBox.shrink(),
                        error: (_, __) => const SizedBox.shrink(),
                      );
                    },
                    loading: () => const ListTile(title: Text("Loading...")),
                    error: (e, _) => ListTile(title: Text("Error: $e")),
                  );
                }).toList(),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
      ),
    );
  }
}
