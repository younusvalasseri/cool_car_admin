import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TodayCountCard extends StatelessWidget {
  final String label;
  final Stream<QuerySnapshot> stream;
  final VoidCallback? onTap;

  const TodayCountCard({
    super.key,
    required this.label,
    required this.stream,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: const Color.fromARGB(255, 0, 139, 252),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 40,
                  width: 40,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                );
              }

              if (snapshot.hasError) {
                return const Text(
                  "Error",
                  style: TextStyle(color: Colors.white),
                );
              }

              final count = snapshot.data?.docs.length ?? 0;

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Text(
                    "$count",
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
