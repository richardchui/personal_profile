import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:personal_profile/models/profile.dart';
import 'package:personal_profile/services/supabase_service.dart';
import 'package:personal_profile/widgets/section_editor.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  final _sections = <Map<String, dynamic>>[];
  final _sectionData = <String, String>{};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSections();
  }

  Future<void> _loadSections() async {
    final String jsonString = await rootBundle.loadString('assets/sections.json');
    final data = json.decode(jsonString);
    setState(() {
      _sections.addAll(List<Map<String, dynamic>>.from(data['sections']));
      _isLoading = false;
    });
  }

  Future<void> _createProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final profile = Profile(
      id: _idController.text,
      sections: Map<String, String>.from(_sectionData),
    );

    final service = SupabaseService();
    final success = await service.createProfile(
      _idController.text,
      _passwordController.text,
      profile,
    );

    if (!mounted) return;

    if (success) {
      context.go('/view/${_idController.text}');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.profileCreationFailed),
          backgroundColor: Colors.red,
        ),
      );
    }
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
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.createProfile),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
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
            const SizedBox(height: 16),
            ..._sections.map((section) {
              return SectionEditor(
                sectionId: section['id'],
                content: _sectionData[section['id']] ?? '',
                onChanged: (value) {
                  _sectionData[section['id']] = value;
                },
              );
            }),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _createProfile,
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }
}
