import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_profile/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:personal_profile/main.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;

  const CommonAppBar({
    super.key,
    this.title,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.path;
    
    return AppBar(
      title: Text(title ?? ''),
      leading: currentRoute != '/' ? IconButton(
        icon: const Icon(Icons.home),
        onPressed: () {
          if (currentRoute != '/') {
            context.go('/');
          }
        },
      ) : null,
      actions: [
        Consumer<LocaleProvider>(
          builder: (context, localeProvider, _) {
            return PopupMenuButton<Locale>(
              tooltip: 'Change language',
              icon: const Icon(Icons.language),
              onSelected: (Locale locale) {
                localeProvider.setLocale(locale);
              },
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: Locale('en'),
                  child: Text('English'),
                ),
                PopupMenuItem(
                  value: Locale('zh', 'CN'),
                  child: Text('简体中文'),
                ),
                PopupMenuItem(
                  value: Locale('zh', 'TW'),
                  child: Text('繁體中文'),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
