import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../core/router/app_router.dart';
import '../data/providers/auth_provider.dart';

class SignInScreen extends StatefulWidget {
  final String? role;
  final String? side;
  const SignInScreen({super.key, this.role, this.side});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.gold),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.gold, width: 2),
                    ),
                    child: const Center(
                      child: Text('ASMYA',
                          style: TextStyle(
                              color: AppColors.gold,
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1)),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Center(
                  child: Text('Sign In',
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: AppColors.gold)),
                ),
                const SizedBox(height: 8),
                if (widget.role != null)
                  Center(
                    child: Text(
                      'Role: ${widget.role}  •  Side: ${widget.side ?? "—"}',
                      style: TextStyle(
                          color: dark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          fontSize: 12),
                    ),
                  ),
                const SizedBox(height: 32),
                Text('Username',
                    style: TextStyle(
                        color: dark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _username,
                  decoration: const InputDecoration(hintText: 'Enter username'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Username required' : null,
                ),
                const SizedBox(height: 18),
                Text('Password',
                    style: TextStyle(
                        color: dark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _password,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    hintText: 'Enter password',
                    suffixIcon: IconButton(
                      icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility,
                          color: AppColors.gold),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  validator: (v) => (v == null || v.length < 6) ? 'Min 6 characters' : null,
                ),
                const SizedBox(height: 28),
                if (auth.error != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.red.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(auth.error!,
                        style: const TextStyle(color: AppColors.red, fontSize: 13)),
                  ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: auth.isLoading
                        ? null
                        : () async {
                            if (!_formKey.currentState!.validate()) return;
                            auth.setRole(widget.role);
                            auth.setSide(widget.side);
                            final ok = await auth.login(_username.text.trim(), _password.text);
                            if (ok && mounted) {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  AppRouter.main, (_) => false);
                            }
                          },
                    child: auth.isLoading
                        ? const SizedBox(
                            width: 18, height: 18,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.black))
                        : const Text('Sign In'),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () async {
                      final ok = await auth.register({
                        'username': 'ustaz_jihad_m',
                        'password': 'password123',
                        'display_name': 'Ustaz Jihad',
                        'role': widget.role ?? 'ADMIN_AMIR',
                        'side': widget.side ?? 'MEN',
                        'admin_subrole': 'SUPERIOR_AMIR',
                      });
                      if (ok && mounted) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            AppRouter.main, (_) => false);
                      }
                    },
                    child: const Text("Don't have an account? Register demo",
                        style: TextStyle(color: AppColors.gold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
