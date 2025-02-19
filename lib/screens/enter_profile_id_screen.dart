import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_profile/l10n/app_localizations.dart';
import 'package:personal_profile/services/supabase_service.dart';
import 'package:personal_profile/widgets/common_app_bar.dart';

class EnterProfileIdScreen extends StatefulWidget {
  const EnterProfileIdScreen({super.key});

  @override
  State<EnterProfileIdScreen> createState() => _EnterProfileIdScreenState();
}

class _EnterProfileIdScreenState extends State<EnterProfileIdScreen> {
  final _idController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }

  void _onViewProfile() async {
    if (_idController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final service = SupabaseService();
      final exists = await service.profileExists(_idController.text);
      
      if (!mounted) return;

      if (!exists) {
        setState(() {
          _error = AppLocalizations.of(context)!.errorProfileNotFound;
          _isLoading = false;
        });
        return;
      }
      
      context.go('/view/${_idController.text}');
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = AppLocalizations.of(context)!.errorGeneric;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: CommonAppBar(
        title: l10n.enterProfileId,
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
                    border: const OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _onViewProfile(),
                  autofocus: true,
                  enabled: !_isLoading,
                ),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _error!,
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _isLoading ? null : _onViewProfile,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : Text(l10n.viewProfile),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
