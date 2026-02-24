import 'package:cerbere_admin/src/theme/cerbere_theme.dart';
import 'package:flutter/material.dart';

/// Layout commun Cerbère : barre de titre + zone de contenu (sans sidebar, la nav est gérée par l'app).
class CerbereLayout extends StatelessWidget {
  const CerbereLayout({
    super.key,
    required this.title,
    required this.body,
  });

  final String title;
  final Widget body;

  static const double _appBarHeight = 64;
  static const double _contentMaxWidth = 1000;
  static const double _contentPadding = 32;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: CerbereTheme.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: _appBarHeight,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: _contentPadding),
            decoration: const BoxDecoration(
              color: CerbereTheme.background,
              border: Border(
                bottom: BorderSide(color: CerbereTheme.border, width: 1),
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: CerbereTheme.foreground,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(_contentPadding),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: _contentMaxWidth),
                  child: SizedBox(
                    width: double.infinity,
                    child: body,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
