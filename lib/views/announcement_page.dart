import 'dart:io';
import 'package:cool_car_admin/Widgets/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Widgets/cool_car_app_bar.dart';

// 🔹 Hold selected image
final selectedImageProvider = StateProvider<File?>((ref) => null);

// 🔹 Hold selected target (Owner/User)
final selectedTargetProvider = StateProvider<String?>((ref) => null);

class AnnouncementsPage extends ConsumerWidget {
  const AnnouncementsPage({super.key});

  Future<void> _pickImage(WidgetRef ref) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      ref.read(selectedImageProvider.notifier).state = File(pickedImage.path);
    }
  }

  Future<void> _submitAnnouncement({
    required WidgetRef ref,
    required BuildContext context,
    required TextEditingController headingController,
    required TextEditingController messageController,
  }) async {
    final imageFile = ref.read(selectedImageProvider);
    final target = ref.read(selectedTargetProvider);

    if (imageFile == null ||
        headingController.text.trim().isEmpty ||
        messageController.text.trim().isEmpty ||
        target == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("All fields including category & logo are required"),
        ),
      );
      return;
    }

    final fileName =
        'announcement_logos/${DateTime.now().millisecondsSinceEpoch}.jpg';
    final refStorage = FirebaseStorage.instance.ref().child(fileName);

    await refStorage.putFile(imageFile);
    final imageUrl = await refStorage.getDownloadURL();

    await FirebaseFirestore.instance.collection('announcements').add({
      'logoUrl': imageUrl,
      'title': headingController.text.trim(),
      'message': messageController.text.trim(),
      'target': target,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Reset
    ref.read(selectedImageProvider.notifier).state = null;
    ref.read(selectedTargetProvider.notifier).state = null;
    headingController.clear();
    messageController.clear();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Announcement added successfully")),
      );
    }
  }

  Future<void> _deleteAnnouncement(
    BuildContext context,
    DocumentSnapshot doc,
  ) async {
    try {
      final data = doc.data() as Map<String, dynamic>;
      final logoUrl = data['logoUrl'] as String?;
      final storageRef = FirebaseStorage.instance.refFromURL(logoUrl ?? '');

      // Delete image
      if (logoUrl != null) await storageRef.delete();

      // Delete Firestore doc
      await FirebaseFirestore.instance
          .collection('announcements')
          .doc(doc.id)
          .delete();
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Announcement deleted")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error deleting: $e")));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final headingController = TextEditingController();
    final messageController = TextEditingController();
    final selectedImage = ref.watch(selectedImageProvider);
    final selectedTarget = ref.watch(selectedTargetProvider);

    return Scaffold(
      appBar: CoolCarAppBar(customTitle: "New Announcement", showIcons: false),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Form Fields
              TextField(
                controller: headingController,
                decoration: const InputDecoration(
                  labelText: "Announcement Heading",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: messageController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: "Message",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedTarget,
                decoration: const InputDecoration(
                  labelText: "Target Audience",
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'owner', child: Text("Owner")),
                  DropdownMenuItem(value: 'user', child: Text("User")),
                ],
                onChanged: (value) {
                  ref.read(selectedTargetProvider.notifier).state = value;
                },
              ),
              const SizedBox(height: 12),
              if (selectedImage != null)
                Column(
                  children: [
                    const Text(
                      "Preview:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Image.file(selectedImage, height: 150),
                    const SizedBox(height: 12),
                  ],
                ),
              ElevatedButton.icon(
                onPressed: () => _pickImage(ref),
                icon: const Icon(Icons.photo),
                label: const Text("Select Logo"),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed:
                    () => _submitAnnouncement(
                      ref: ref,
                      context: context,
                      headingController: headingController,
                      messageController: messageController,
                    ),
                icon: const Icon(Icons.send),
                label: const Text("Submit Announcement"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: AppColors.white,
                ),
              ),

              // 🔹 Preview Existing Announcements
              const SizedBox(height: 20),
              const Divider(),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "📝 Existing Announcements",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection('announcements')
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final announcements = snapshot.data!.docs;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: announcements.length,
                    itemBuilder: (context, index) {
                      final doc = announcements[index];
                      final data = doc.data() as Map<String, dynamic>;

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading:
                              data['logoUrl'] != null
                                  ? Image.network(
                                    data['logoUrl'],
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.cover,
                                  )
                                  : const Icon(Icons.image_not_supported),
                          title: Text(data['title'] ?? 'No title'),
                          subtitle: Text(data['message'] ?? 'No Message'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: AppColors.primaryBlue,
                                ),
                                onPressed: () {
                                  headingController.text = data['title'];
                                  messageController.text = data['message'];
                                  ref
                                      .read(selectedTargetProvider.notifier)
                                      .state = data['target'];
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: AppColors.redIcon,
                                ),
                                onPressed:
                                    () => _deleteAnnouncement(context, doc),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
