import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_profile/l10n/app_localizations.dart';
import 'package:personal_profile/services/supabase_service.dart';

class EnterEditIdScreen extends StatefulWidget {
  const EnterEditIdScreen({super.key});

  @override
  State<EnterEditIdScreen> createState() => _EnterEditIdScreenState();
}

class _EnterEditIdScreenState extends State<EnterEditIdScreen> {
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEditProfile() async {
    if (_idController.text.isEmpty || _passwordController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final service = SupabaseService();
      final valid = await service.validateCredentials(
        _idController.text,
        _passwordController.text,
      );
      
      if (!mounted) return;

      if (valid) {
        context.go('/edit/${_idController.text}');
      } else {
        final l10n = AppLocalizations.of(context)!;
        setState(() {
          _error = l10n.invalidCredentials;
        });
      }
    } catch (e) {
      if (!mounted) return;
      
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        _error = l10n.updateFailed;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editProfile),
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _idController,
                  decoration: InputDecoration(
                    labelText: l10n.profileId,
                    errorText: _error,
                  ),
                  enabled: !_isLoading,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: l10n.password,
                  ),
                  obscureText: true,
                  enabled: !_isLoading,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _onEditProfile,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : Text(l10n.editProfile),
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
