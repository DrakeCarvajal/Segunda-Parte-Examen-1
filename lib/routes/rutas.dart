import 'package:go_router/go_router.dart';
import '../pages/home_page.dart';
import '../pages/add_edit_recipe_page.dart';
import '../pages/favorites_page.dart';
import '../pages/search_page.dart';
import '../pages/ingrediente_page.dart';

// Configuración del enrutador GoRouter para la navegación de la aplicación.
final GoRouter router = GoRouter(
  initialLocation: '/', // Ruta inicial: página principal.
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/add-recipe',
      builder: (context, state) => const AddEditRecipePage(),
    ),
    GoRoute(
      path: '/edit-recipe/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return AddEditRecipePage(recipeId: id);
      },
    ),
    GoRoute(
      path: '/favorites', // NUEVO
      builder: (context, state) => const FavoritesPage(), // NUEVO
    ),
    // Ruta de búsqueda: /search
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchPage(),
    ),
    GoRoute(
      path: '/ingredient',
      builder: (context, state) => const IngredientePage(),
    ),
    //TODO: NUEVA RUTA A LA NUEVA PÁGINA DE INGREDIENTES /ingredient
  ],
);
