/// package qui gere les roles et les autorisation avec firebase (Cerbère admin, dépend Admin SDK)
library cerbere_admin;

// Widget d'initialisation
export 'src/widgets/cerbere_admin_init_widget.dart';

// Repository étendu
export 'src/repositories/cerbere_utilisateur_admin_repository.dart';

// Use cases
export 'src/usecases/assigne_role_utilisateur_usecase.dart';
export 'src/usecases/recupere_role_utilisateur_usecase.dart';
export 'src/usecases/recupere_roles_usecase.dart';

// Pages
export 'src/pages/cerbere_utilisateurs/view/cerbere_utilisateurs_page.dart';
export 'src/pages/cerbere_roles/view/cerbere_roles_page.dart';
