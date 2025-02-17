import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:personal_profile/models/profile.dart';
import 'package:personal_profile/services/supabase_service.dart';
import 'package:personal_profile/widgets/section_editor.dart';

class ViewProfileScreen extends StatefulWidget {
  final String profileId;

  const ViewProfileScreen({
    super.key,
    required this.profileId,
  });

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  final _sections = <Map<String, dynamic>>[];
  Profile? _profile;
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

    setState(() {
      _profile = profile;
      _isLoading = false;
    });
  }

  Future<void> _showDeleteDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();

    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteProfile),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.enterPassword),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              obscureText: true,
              decoration: InputDecoration(
                labelText: l10n.password,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
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

    if (shouldDelete == true && mounted) {
      final service = SupabaseService();
      final success = await service.deleteProfile(
        widget.profileId,
        controller.text,
      );

      if (!mounted) return;

      if (success) {
        context.go('/');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.deleteFailed),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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

    if (_profile == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.viewProfile),
        ),
        body: Center(
          child: Text(l10n.profileNotFound),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.viewProfile),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.go('/edit/${widget.profileId}'),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _showDeleteDialog,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: _sections.map((section) {
          return SectionEditor(
            sectionId: section['id'],
            content: _profile!.sections[section['id']] ?? '',
            readOnly: true,
          );
        }).toList(),
      ),
    );
  }
}
