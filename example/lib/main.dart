import 'package:cerbere_admin/cerbere_admin.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const CerbereAdminExampleApp());
}

/// Example app for cerbere_admin.
///
/// In a real app, initialize Firebase and Firebase Admin SDK, then wrap
/// your app with [CerbereAdminInitWidget] and use [CerbereUtilisateursPage]
/// or [CerbereRolesPage].
class CerbereAdminExampleApp extends StatelessWidget {
  /// Creates the example app.
  const CerbereAdminExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cerbère Admin Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const _ExampleHomePage(),
    );
  }
}

class _ExampleHomePage extends StatelessWidget {
  const _ExampleHomePage();

  @override
  Widget build(BuildContext context) {
    // References to package widgets for the example (use them in a real app
    // after wrapping with CerbereAdminInitWidget).
    const rolesPage = CerbereRolesPage();
    const usersPage = CerbereUtilisateursPage();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cerbère Admin Example'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Configure Firebase Auth, Firestore and Firebase Admin SDK, '
                'then wrap your app with CerbereAdminInitWidget. '
                'You can then navigate to CerbereUtilisateursPage and '
                'CerbereRolesPage.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Available: ${rolesPage.runtimeType}, '
                '${usersPage.runtimeType}',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
