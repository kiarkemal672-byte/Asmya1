import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/asmya_app_bar.dart';
import '../../data/providers/chat_provider.dart';
import '../../data/providers/language_provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _searchCtrl = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().load();
    });
  }

  @override
  void dispose() { _searchCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<ChatProvider>();
    final lang = context.watch<LanguageProvider>();
    final dark = Theme.of(context).brightness == Brightness.dark;
    final filtered = prov.conversations
        .where((c) => c.title.toLowerCase().contains(_searchCtrl.text.toLowerCase()))
        .toList();
    return Scaffold(
      appBar: AsmyaAppBar(title: lang.t('chat')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search conversations...',
                prefixIcon: const Icon(Icons.search, color: AppColors.gold),
              ),
            ),
          ),
          Expanded(
            child: prov.isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
                : filtered.isEmpty
                    ? const Center(child: Text('No conversations'))
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => Divider(
                            color: dark ? AppColors.darkBorder : AppColors.lightBorder,
                            height: 1,
                            indent: 76),
                        itemBuilder: (context, i) {
                          final c = filtered[i];
                          return ListTile(
                            onTap: () {},
                            leading: CircleAvatar(
                              radius: 24,
                              backgroundColor: AppColors.gold.withOpacity(0.15),
                              child: Text(
                                c.avatarInitials ?? 'AS',
                                style: const TextStyle(
                                    color: AppColors.gold,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 13),
                              ),
                            ),
                            title: Text(c.title,
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                            subtitle: Text(
                              c.lastMessage ?? c.description ?? 'Tap to start conversation',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: dark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                            ),
                            trailing: Text(
                              c.lastMessageAt != null
                                  ? '${c.lastMessageAt!.hour.toString().padLeft(2, '0')}:${c.lastMessageAt!.minute.toString().padLeft(2, '0')}'
                                  : '',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: dark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
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
