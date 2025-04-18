import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../Widgets/cool_car_app_bar.dart';
import '../providers/providers.dart';

class AdminChatPage extends ConsumerStatefulWidget {
  final String userId;
  const AdminChatPage({super.key, required this.userId});

  @override
  ConsumerState<AdminChatPage> createState() => _AdminChatPageState();
}

class _AdminChatPageState extends ConsumerState<AdminChatPage> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(adminMarkMessagesReadProvider)(widget.userId);
    });
  }

  String _formatTimestamp(DateTime? timestamp) {
    if (timestamp == null) return '';
    return DateFormat('hh:mm a').format(timestamp);
  }

  String _formatDateLabel(DateTime? dateTime) {
    final now = DateTime.now();
    if (dateTime == null) return '';
    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return "Today";
    }
    return DateFormat('dd MMM yyyy').format(dateTime);
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    ref.read(adminSendMessageProvider)(widget.userId, text);
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final chatStream = ref.watch(adminChatStreamProvider(widget.userId));
    final userNameAsync = ref.watch(fetchChatUserNameProvider(widget.userId));

    return userNameAsync.when(
      loading:
          () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text("Error: $e"))),
      data: (userName) {
        return Scaffold(
          appBar: CoolCarAppBar(
            customTitle: "Chat with $userName",
            showIcons: false,
          ),
          body: Column(
            children: [
              Expanded(
                child: chatStream.when(
                  loading:
                      () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text("Error: $e")),
                  data: (snapshot) {
                    final messages = snapshot.docs;
                    List<Widget> chatWidgets = [];
                    DateTime? lastDate;

                    for (int i = messages.length - 1; i >= 0; i--) {
                      final data = messages[i].data() as Map<String, dynamic>;
                      final isAdmin = data['sender'] == 'admin';
                      final text = data['text'] ?? '';
                      final timestamp =
                          (data['timestamp'] as Timestamp?)?.toDate();

                      if (timestamp != null &&
                          (lastDate == null ||
                              timestamp.day != lastDate.day ||
                              timestamp.month != lastDate.month ||
                              timestamp.year != lastDate.year)) {
                        chatWidgets.add(
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade400,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  _formatDateLabel(timestamp),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                        lastDate = timestamp;
                      }

                      chatWidgets.add(
                        Align(
                          alignment:
                              isAdmin
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 8,
                            ),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color:
                                  isAdmin ? Colors.blue[200] : Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(text),
                                const SizedBox(height: 4),
                                Text(
                                  _formatTimestamp(timestamp),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    return ListView(
                      reverse: true,
                      padding: const EdgeInsets.only(bottom: 10),
                      children: chatWidgets.reversed.toList(),
                    );
                  },
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: "Type your message...",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _sendMessage,
                      child: const Text("Send"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
} //convert it in to ConsumerWidget (Riverpod)
