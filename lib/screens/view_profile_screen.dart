import 'package:flutter/material.dart';
import 'package:personal_profile/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_profile/models/profile.dart';
import 'package:personal_profile/services/supabase_service.dart';
import 'package:personal_profile/widgets/common_app_bar.dart';
import 'package:personal_profile/widgets/section_navigator.dart';

class ViewProfileScreen extends StatefulWidget {
  final String id;

  const ViewProfileScreen({
    super.key,
    required this.id,
  });

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  Profile? _profile;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await SupabaseService().getProfile(widget.id);
      if (mounted) {
        setState(() {
          _profile = profile;
          if (profile == null) {
            _error = AppLocalizations.of(context)!.profileNotFound;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = AppLocalizations.of(context)!.profileNotFound;
        });
      }
    }
  }

  Future<void> _updateProfile(Map<String, dynamic> sections) async {
    try {
      final success = await SupabaseService().updateProfile(
        widget.id,
        _profile!.password,
        Profile(
          id: widget.id,
          password: _profile!.password,
          sections: sections,
        ),
      );

      if (!mounted) return;

      if (!success) {
        setState(() {
          _error = AppLocalizations.of(context)!.updateFailed;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = AppLocalizations.of(context)!.updateFailed;
        });
      }
    }
  }

  Future<void> _deleteProfile() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteProfile),
        content: Text(l10n.deleteConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final success = await SupabaseService().deleteProfile(
        widget.id,
        _profile!.password,
      );
      if (!mounted) return;

      if (success) {
        context.go('/');
      } else {
        setState(() {
          _error = AppLocalizations.of(context)!.deleteFailed;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = AppLocalizations.of(context)!.deleteFailed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_error != null) {
      return Scaffold(
        appBar: const CommonAppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: Text(l10n.createProfile),
              ),
            ],
          ),
        ),
      );
    }

    if (_profile == null) {
      return const Scaffold(
        appBar: CommonAppBar(),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: CommonAppBar(
        title: l10n.viewProfile,
      ),
      body: Column(
        children: [
          Expanded(
            child: SectionNavigator(
              sections: _profile!.sections,
              onSectionsChanged: _updateProfile,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _deleteProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
              child: Text(l10n.deleteProfile),
            ),
          ),
        ],
      ),
    );
  }
}
