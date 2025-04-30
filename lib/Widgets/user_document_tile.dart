import 'package:cool_car_admin/Widgets/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DocumentRow extends StatelessWidget {
  final String title;
  final String? documentUrl;

  const DocumentRow({
    super.key,
    required this.title,
    required this.documentUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            documentUrl != null ? Icons.check_circle : Icons.error,
            color:
                documentUrl != null ? AppColors.greenBack : AppColors.redBack,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: AppColors.whiteText),
            ),
          ),
          if (documentUrl != null)
            IconButton(
              icon: const Icon(
                Icons.remove_red_eye,
                color: AppColors.whiteText,
              ),
              onPressed: () async {
                final uri = Uri.parse(documentUrl!);

                try {
                  final launched = await launchUrl(
                    uri,
                    mode: LaunchMode.externalApplication,
                  );

                  if (!launched && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('⚠️ Unable to open document'),
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('⚠️ No app found to open document'),
                      ),
                    );
                  }
                }
              },
            ),
        ],
      ),
    );
  }
}
