import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/asmya_app_bar.dart';
import '../../data/providers/member_provider.dart';
import '../../data/providers/language_provider.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({super.key});
  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  final _search = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MemberProvider>().load();
    });
  }

  @override
  void dispose() { _search.dispose(); super.dispose(); }

  void _addDialog(BuildContext context) {
    final name = TextEditingController();
    final username = TextEditingController();
    final password = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).cardTheme.color,
        title: const Text('Add Member', style: TextStyle(color: AppColors.gold)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: name, decoration: const InputDecoration(hintText: 'Display name')),
          const SizedBox(height: 10),
          TextField(controller: username, decoration: const InputDecoration(hintText: 'Username')),
          const SizedBox(height: 10),
          TextField(
              controller: password,
              obscureText: true,
              decoration: const InputDecoration(hintText: 'Password')),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (name.text.isEmpty || username.text.isEmpty) return;
              await context.read<MemberProvider>().add({
                'display_name': name.text,
                'username': username.text,
                'password': password.text.isEmpty ? 'password123' : password.text,
                'role': 'STUDENT',
              });
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<MemberProvider>();
    final lang = context.watch<LanguageProvider>();
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AsmyaAppBar(title: lang.t('members')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: prov.filter == 'all' ? AppColors.gold : null,
                      foregroundColor: prov.filter == 'all' ? Colors.black : null,
                    ),
                    onPressed: () => prov.setFilter('all'),
                    child: Text('${lang.t('all_members')} (${prov.members.length})',
                        style: const TextStyle(fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: prov.filter == 'followers' ? AppColors.gold : null,
                      foregroundColor: prov.filter == 'followers' ? Colors.black : null,
                    ),
                    onPressed: () => prov.setFilter('followers'),
                    child: Text('${lang.t('my_followers')} (${prov.members.length})',
                        style: const TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _search,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: lang.t('search'),
                prefixIcon: const Icon(Icons.search, color: AppColors.gold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () => _addDialog(context),
                icon: const Icon(Icons.add, size: 18),
                label: Text(lang.t('add_member')),
              ),
            ),
          ),
          Expanded(
            child: prov.isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
                : prov.members.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.group_off,
                                size: 80,
                                color: dark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                            const SizedBox(height: 12),
                            Text(lang.t('no_members'),
                                style: TextStyle(
                                    color: dark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: prov.members.length,
                        itemBuilder: (context, i) {
                          final m = prov.members[i];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppColors.gold.withOpacity(0.15),
                                child: Text(m.initials,
                                    style: const TextStyle(
                                        color: AppColors.gold, fontWeight: FontWeight.w800)),
                              ),
                              title: Text(m.displayName,
                                  style: const TextStyle(fontWeight: FontWeight.w700)),
                              subtitle: Text('${m.handle ?? '@${m.username}'} • ${m.role}',
                                  style: const TextStyle(fontSize: 12)),
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
