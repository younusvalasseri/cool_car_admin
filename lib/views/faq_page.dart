import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';

class FaqPage extends ConsumerWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final faqStream = ref.watch(faqStreamProvider);

    final questionController = TextEditingController();
    final answerController = TextEditingController();

    void submitFaq() async {
      final question = questionController.text.trim();
      final answer = answerController.text.trim();

      await ref.read(addFaqProvider).addFaq(question: question, answer: answer);

      if (!context.mounted) return;
      questionController.clear();
      answerController.clear();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("FAQ added successfully")));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Manage FAQs")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: questionController,
              decoration: const InputDecoration(
                labelText: "Question",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: answerController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Answer",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: submitFaq, child: const Text("Add FAQ")),
            const SizedBox(height: 24),
            const Text(
              "Existing FAQs",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: faqStream.when(
                data: (snapshot) {
                  final faqs = snapshot.docs;
                  return ListView.builder(
                    itemCount: faqs.length,
                    itemBuilder: (context, index) {
                      final data = faqs[index].data();
                      return ListTile(
                        title: Text(data['question'] ?? ''),
                        subtitle: Text(data['answer'] ?? ''),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error loading FAQs: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
