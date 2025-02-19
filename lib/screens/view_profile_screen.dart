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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_error != null) {
      return Scaffold(
        appBar: CommonAppBar(
          title: l10n.viewProfile,
        ),
        body: Center(
          child: Text(
            _error!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
      );
    }

    if (_profile == null) {
      return Scaffold(
        appBar: CommonAppBar(
          title: l10n.viewProfile,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: CommonAppBar(
        title: l10n.viewProfile,
      ),
      body: SectionNavigator(
        sections: _profile!.sections,
        onSectionsChanged: (_) {}, // Disable editing
        isEditable: false,
      ),
    );
  }
}
