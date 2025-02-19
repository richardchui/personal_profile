import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_profile/l10n/app_localizations.dart';
import 'package:personal_profile/models/profile.dart';
import 'package:personal_profile/services/supabase_service.dart';
import 'package:personal_profile/widgets/common_app_bar.dart';
import 'package:personal_profile/widgets/section_navigator.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  Map<String, dynamic> _sections = {};
  bool _isSaving = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSections();
  }

  Future<void> _loadSections() async {
    try {
      debugPrint('Loading sections from assets...');
      final jsonString = await rootBundle.loadString('assets/sections.json');
      debugPrint('Loaded JSON: $jsonString');
      
      final data = json.decode(jsonString);
      final sections = List<Map<String, dynamic>>.from(data['sections']);
      debugPrint('Parsed sections: $sections');
      
      final initialSections = <String, dynamic>{};
      for (final section in sections) {
        initialSections[section['id']] = '';
      }
      debugPrint('Created initial sections: $initialSections');

      if (!mounted) return;
      setState(() {
        _sections = initialSections;
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      debugPrint('Error loading sections: $e');
      debugPrint('Stack trace: $stackTrace');
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final profile = Profile(
      id: _idController.text,
      password: _passwordController.text,
      sections: Map<String, dynamic>.from(_sections),
    );

    final service = SupabaseService();
    final success = await service.createProfile(
      _idController.text,
      _passwordController.text,
      profile,
    );

    if (!mounted) return;

    final l10n = AppLocalizations.of(context)!;
    if (success) {
      context.go('/view/${_idController.text}');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.profileCreationFailed),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() => _isSaving = false);
  }

  void _updateSections(Map<String, dynamic> newSections) {
    setState(() {
      _sections = newSections;
    });
  }

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return const Scaffold(
        appBar: CommonAppBar(),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: const CommonAppBar(),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: _idController,
                    decoration: InputDecoration(
                      labelText: l10n.profileId,
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.requiredField;
                      }
                      if (value.length < 5 || value.length > 15) {
                        return l10n.invalidIdLength;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: l10n.password,
                      border: const OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.requiredField;
                      }
                      if (value.length < 5 || value.length > 15) {
                        return l10n.invalidPasswordLength;
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: SectionNavigator(
                sections: _sections,
                onSectionsChanged: _updateSections,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveProfile,
                child: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.save),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
