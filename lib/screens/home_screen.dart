import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:personal_profile/providers/locale_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          PopupMenuButton<Locale>(
            icon: const Icon(Icons.language),
            onSelected: (Locale locale) {
              context.read<LocaleProvider>().setLocale(locale);
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: Locale('en'),
                child: Text('English'),
              ),
              const PopupMenuItem(
                value: Locale('zh', 'CN'),
                child: Text('简体中文'),
              ),
              const PopupMenuItem(
                value: Locale('zh', 'TW'),
                child: Text('繁體中文'),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => context.go('/create'),
              child: Text(l10n.createProfile),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => _ViewProfileDialog(),
                );
              },
              child: Text(l10n.viewProfile),
            ),
          ],
        ),
      ),
    );
  }
}

class _ViewProfileDialog extends StatefulWidget {
  @override
  _ViewProfileDialogState createState() => _ViewProfileDialogState();
}

class _ViewProfileDialogState extends State<_ViewProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return AlertDialog(
      title: Text(l10n.enterProfileId),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _idController,
          decoration: InputDecoration(labelText: l10n.profileId),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return l10n.requiredField;
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context);
              context.go('/view/${_idController.text}');
            }
          },
          child: Text(l10n.view),
        ),
      ],
    );
  }
}
