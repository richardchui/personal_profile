import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:personal_profile/models/profile.dart';
import 'package:personal_profile/services/supabase_service.dart';
import 'package:personal_profile/widgets/section_navigator.dart';

class EditProfileScreen extends StatefulWidget {
  final String id;

  const EditProfileScreen({super.key, required this.id});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  Profile? _profile;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final service = SupabaseService();
    final profile = await service.getProfile(widget.id);
    
    if (!mounted) return;

    setState(() {
      _profile = profile;
      _isLoading = false;
    });

    if (profile == null) {
      if (!mounted) return;
      
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.profileNotFound),
          backgroundColor: Colors.red,
        ),
      );
      context.go('/');
    }
  }

  Future<void> _saveProfile() async {
    if (_profile == null) return;

    setState(() => _isSaving = true);

    final service = SupabaseService();
    final success = await service.updateProfile(
      widget.id,
      _profile!.password,
      _profile!,
    );

    if (!mounted) return;

    final l10n = AppLocalizations.of(context)!;
    if (success) {
      context.go('/view/${widget.id}');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.updateFailed),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() => _isSaving = false);
  }

  void _updateSections(Map<String, dynamic> sections) {
    setState(() {
      _profile = _profile!.copyWith(sections: sections);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.editProfile),
          leading: IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => context.go('/'),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_profile == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.editProfile),
          leading: IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => context.go('/'),
          ),
        ),
        body: Center(
          child: Text(l10n.profileNotFound),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editProfile),
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () => context.go('/'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isSaving ? null : _saveProfile,
          ),
        ],
      ),
      body: SectionNavigator(
        sections: _profile!.sections,
        onSectionsChanged: _updateSections,
      ),
    );
  }
}
