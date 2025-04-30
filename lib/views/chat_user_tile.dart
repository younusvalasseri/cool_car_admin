import 'package:cool_car_admin/Widgets/app_colors.dart';
import 'package:flutter/material.dart';

class ChatUserTile extends StatelessWidget {
  final String userId;
  final String userName;
  final String? photoUrl;
  final String message;
  final DateTime? timestamp;
  final int unreadCount;
  final VoidCallback onTap;

  const ChatUserTile({
    super.key,
    required this.userId,
    required this.userName,
    required this.photoUrl,
    required this.message,
    required this.timestamp,
    required this.unreadCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            // 👤 Avatar
            CircleAvatar(
              radius: 24,
              backgroundImage:
                  photoUrl != null ? NetworkImage(photoUrl!) : null,
              child:
                  photoUrl == null
                      ? Text(userName.isNotEmpty ? userName[0] : '?')
                      : null,
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          message,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: AppColors.black),
                        ),
                      ],
                    ),
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (timestamp != null)
                        Text(
                          TimeOfDay.fromDateTime(timestamp!).format(context),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.greyBack,
                          ),
                        ),
                      Visibility(
                        visible: unreadCount > 0,
                        replacement: const SizedBox(height: 18),
                        child: Container(
                          margin: const EdgeInsets.only(top: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: const BoxDecoration(
                            color: AppColors.greenBack,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: Text(
                            '$unreadCount',
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
