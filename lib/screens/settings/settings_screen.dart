import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/asmya_app_bar.dart';
import '../../data/providers/auth_provider.dart';
import '../../data/providers/theme_provider.dart';
import '../../data/providers/language_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _displayName = TextEditingController();
  final _current = TextEditingController();
  final _newPass = TextEditingController();
  final _confirm = TextEditingController();
  bool _savingProfile = false;
  bool _savingPass = false;
  String? _profileMsg;
  String? _passMsg;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final auth = context.read<AuthProvider>();
    if (_displayName.text.isEmpty && auth.user != null) {
      _displayName.text = auth.user!.displayName;
    }
  }

  @override
  void dispose() {
    _displayName.dispose(); _current.dispose(); _newPass.dispose(); _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final themeProv = context.watch<ThemeProvider>();
    final langProv = context.watch<LanguageProvider>();
    final dark = Theme.of(context).brightness == Brightness.dark;
    final user = auth.user;
    return Scaffold(
      appBar: AsmyaAppBar(title: langProv.t('settings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile header
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 44,
                    backgroundColor: AppColors.gold.withOpacity(0.18),
                    child: Text(user?.initials ?? 'UJ',
                        style: const TextStyle(
                            color: AppColors.gold, fontSize: 24, fontWeight: FontWeight.w900)),
                  ),
                  Positioned(
                    bottom: 0, right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                          color: AppColors.gold, shape: BoxShape.circle),
                      child: const Icon(Icons.camera_alt, color: Colors.black, size: 14),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(user?.displayName ?? 'Ustaz Jihad',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            ),
            Center(
              child: Text(user?.handle ?? '@ustaz_jihad_m',
                  style: TextStyle(
                      fontSize: 13,
                      color: dark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
            ),
            const SizedBox(height: 24),

            _sectionTitle('Profile'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _displayName,
                    decoration: InputDecoration(
                      labelText: langProv.t('display_name'),
                      labelStyle: const TextStyle(color: AppColors.gold),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _savingProfile ? null : () async {
                    setState(() { _savingProfile = true; _profileMsg = null; });
                    try {
                      await auth.api.updateProfile({'display_name': _displayName.text});
                      await auth.refreshProfile();
                      _profileMsg = 'Saved ✓';
                    } catch (e) { _profileMsg = 'Error: $e'; }
                    setState(() => _savingProfile = false);
                  },
                  icon: _savingProfile
                      ? const SizedBox(
                          width: 18, height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.gold))
                      : const Icon(Icons.save, color: AppColors.gold),
                ),
              ],
            ),
            if (_profileMsg != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(_profileMsg!,
                    style: TextStyle(
                        color: _profileMsg!.contains('Error') ? AppColors.red : AppColors.green,
                        fontSize: 12)),
              ),
            const SizedBox(height: 24),

            _sectionTitle('Change Password'),
            const SizedBox(height: 8),
            TextField(
                controller: _current,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: langProv.t('current_password'),
                    labelStyle: const TextStyle(color: AppColors.gold))),
            const SizedBox(height: 10),
            TextField(
                controller: _newPass,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: langProv.t('new_password'),
                    labelStyle: const TextStyle(color: AppColors.gold))),
            const SizedBox(height: 10),
            TextField(
                controller: _confirm,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: langProv.t('confirm_password'),
                    labelStyle: const TextStyle(color: AppColors.gold))),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _savingPass ? null : () async {
                  if (_newPass.text != _confirm.text) {
                    setState(() => _passMsg = 'Passwords do not match');
                    return;
                  }
                  setState(() { _savingPass = true; _passMsg = null; });
                  try {
                    await auth.api.changePassword(_current.text, _newPass.text);
                    _passMsg = 'Password changed ✓';
                    _current.clear(); _newPass.clear(); _confirm.clear();
                  } catch (e) { _passMsg = 'Error: $e'; }
                  setState(() => _savingPass = false);
                },
                child: _savingPass
                    ? const SizedBox(
                        width: 16, height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                    : const Text('Update Password'),
              ),
            ),
            if (_passMsg != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(_passMsg!,
                    style: TextStyle(
                        color: _passMsg!.contains('Error') || _passMsg!.contains('match')
                            ? AppColors.red
                            : AppColors.green,
                        fontSize: 12)),
              ),
            const SizedBox(height: 24),

            _sectionTitle('Theme'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeProv.isDark ? AppColors.gold : null,
                      foregroundColor: themeProv.isDark ? Colors.black : null,
                    ),
                    onPressed: () => themeProv.setDark(true),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.dark_mode, size: 16),
                      SizedBox(width: 6),
                      Text(langProv.t('dark')),
                    ]),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !themeProv.isDark ? AppColors.gold : null,
                      foregroundColor: !themeProv.isDark ? Colors.black : null,
                    ),
                    onPressed: () => themeProv.setDark(false),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.light_mode, size: 16),
                      SizedBox(width: 6),
                      Text(langProv.t('light')),
                    ]),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            _sectionTitle('Language'),
            const SizedBox(height: 8),
            Row(
              children: [
                _langChip('en', 'English', langProv, dark),
                const SizedBox(width: 6),
                _langChip('am', 'አማርኛ', langProv, dark),
                const SizedBox(width: 6),
                _langChip('ar', 'العربية', langProv, dark),
              ],
            ),
            const SizedBox(height: 24),

            _sectionTitle('Role & Info'),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Role',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: dark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                          const SizedBox(height: 4),
                          Text(user?.adminSubrole?.replaceAll('_', ' ') ?? 'SUPERIOR AMIR',
                              style: const TextStyle(
                                  color: AppColors.gold, fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                    Container(width: 1, height: 36, color: AppColors.gold.withOpacity(0.3)),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Side',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: dark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                          const SizedBox(height: 4),
                          Text(user?.side ?? 'MEN',
                              style: const TextStyle(
                                  color: AppColors.gold, fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String t) => Text(t,
      style: const TextStyle(
          fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.gold, letterSpacing: 1));

  Widget _langChip(String code, String label, LanguageProvider prov, bool dark) {
    final selected = prov.code == code;
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: selected ? AppColors.gold : null,
          foregroundColor: selected ? Colors.black : null,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onPressed: () => prov.setLanguage(code),
        child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
      ),
    );
  }
}
