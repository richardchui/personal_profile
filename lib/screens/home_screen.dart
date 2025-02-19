import 'package:flutter/material.dart';
import 'package:personal_profile/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_profile/services/supabase_service.dart';
import 'package:personal_profile/widgets/common_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isViewingProfile = false;
  String? _error;

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onViewProfile() async {
    if (!_isViewingProfile) {
      setState(() {
        _isViewingProfile = true;
        _error = null;
      });
      return;
    }

    final id = _idController.text.trim();
    final password = _passwordController.text.trim();

    if (id.isEmpty || password.isEmpty) {
      setState(() {
        _error = AppLocalizations.of(context)!.requiredField;
      });
      return;
    }

    try {
      final profile = await SupabaseService().getProfile(id);
      if (profile == null || profile.password != password) {
        setState(() {
          _error = AppLocalizations.of(context)!.invalidCredentials;
        });
        return;
      }

      if (mounted) {
        context.go('/view/$id');
      }
    } catch (e) {
      setState(() {
        _error = AppLocalizations.of(context)!.invalidCredentials;
      });
    }
  }

  void _onCreateProfile() {
    context.go('/create');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: const CommonAppBar(),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_isViewingProfile) ...[
                  TextField(
                    controller: _idController,
                    decoration: InputDecoration(
                      labelText: l10n.profileId,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: l10n.password,
                      border: const OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      _error!,
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 32),
                ],
                ElevatedButton(
                  onPressed: _onViewProfile,
                  child: Text(_isViewingProfile ? l10n.viewProfile : l10n.viewProfile),
                ),
                const SizedBox(height: 16),
                if (!_isViewingProfile)
                  ElevatedButton(
                    onPressed: _onCreateProfile,
                    child: Text(l10n.createProfile),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
