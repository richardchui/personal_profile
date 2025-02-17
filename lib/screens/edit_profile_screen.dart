import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:personal_profile/models/profile.dart';
import 'package:personal_profile/services/supabase_service.dart';
import 'package:personal_profile/widgets/section_editor.dart';

class EditProfileScreen extends StatefulWidget {
  final String profileId;

  const EditProfileScreen({
    super.key,
    required this.profileId,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _sections = <Map<String, dynamic>>[];
  final _sectionData = <String, String>{};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final String jsonString = await rootBundle.loadString('assets/sections.json');
    final data = json.decode(jsonString);
    _sections.addAll(List<Map<String, dynamic>>.from(data['sections']));

    final service = SupabaseService();
    final profile = await service.getProfile(widget.profileId);

    if (profile != null) {
      setState(() {
        _sectionData.addAll(profile.sections);
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final profile = Profile(
      id: widget.profileId,
      sections: Map<String, String>.from(_sectionData),
    );

    final service = SupabaseService();
    final success = await service.updateProfile(
      widget.profileId,
      _passwordController.text,
      profile,
    );

    if (!mounted) return;

    if (success) {
      context.go('/view/${widget.profileId}');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.updateFailed),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
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
        title: Text(l10n.editProfile),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
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
              onPressed: _saveProfile,
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }
}
