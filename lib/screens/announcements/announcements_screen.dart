import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/asmya_app_bar.dart';
import '../../data/providers/announcement_provider.dart';
import '../../data/providers/language_provider.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});
  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AnnouncementProvider>().load();
    });
  }

  void _showCreateDialog(BuildContext context) {
    final title = TextEditingController();
    final content = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).cardTheme.color,
        title: const Text('New Announcement', style: TextStyle(color: AppColors.gold)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: title, decoration: const InputDecoration(hintText: 'Title')),
          const SizedBox(height: 12),
          TextField(
              controller: content,
              maxLines: 4,
              decoration: const InputDecoration(hintText: 'Content')),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (title.text.isEmpty || content.text.isEmpty) return;
              await context.read<AnnouncementProvider>().create(title.text, content.text);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<AnnouncementProvider>();
    final lang = context.watch<LanguageProvider>();
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AsmyaAppBar(title: lang.t('announcements')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () => _showCreateDialog(context),
                icon: const Icon(Icons.add, size: 18),
                label: Text(lang.t('new_announcement')),
              ),
            ),
          ),
          Expanded(
            child: prov.isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
                : prov.items.isEmpty
                    ? const Center(child: Text('No announcements yet'))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        itemCount: prov.items.length,
                        itemBuilder: (context, i) {
                          final a = prov.items[i];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 18,
                                        backgroundColor: AppColors.gold.withOpacity(0.15),
                                        child: Text(a.authorInitials,
                                            style: const TextStyle(
                                                color: AppColors.gold,
                                                fontWeight: FontWeight.w800,
                                                fontSize: 12)),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(a.authorName,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w700, fontSize: 14)),
                                            Text(DateFormat('MMM d, yyyy').format(a.createdAt),
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    color: dark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline,
                                            color: AppColors.red, size: 20),
                                        onPressed: () => prov.delete(a.id),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(a.title,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w800, fontSize: 16)),
                                  const SizedBox(height: 6),
                                  Text(a.content,
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: dark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                          height: 1.5)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
