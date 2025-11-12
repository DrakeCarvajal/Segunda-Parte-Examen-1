// lib/pages/favorites_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/recipe_provider.dart';
import '../widgets/custom_scaffold.dart';
import '../widgets/recipe_card.dart';

/// Página que muestra únicamente las recetas marcadas como favoritas.
/// Usa el mismo grid responsivo que Home y reutiliza RecipeCard.
class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Columns responsivas igual que en Home.
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount =
        screenWidth > 900 ? 4 : (screenWidth > 600 ? 3 : (screenWidth > 400 ? 2 : 1));

    return CustomScaffold(
      showBackButton: true, // Permite volver con la flecha en AppBar.
      body: Consumer<RecipeProvider>(
        builder: (context, provider, _) {
          final favorites = provider.favoriteRecipes; // Lista filtrada (solo favoritas).
          if (favorites.isEmpty) {
            // Mensaje cuando aún no hay favoritas.
            return const Center(
              child: Text('Aún no tienes recetas favoritas.'),
            );
          }

          // Grid idéntico a Home, pero con la lista "favorites".
          return GridView.custom(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 1.0,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            childrenDelegate: SliverChildBuilderDelegate(
              (context, index) => RecipeCard(recipe: favorites[index]),
              childCount: favorites.length,
              addAutomaticKeepAlives: true,
            ),
          );
        },
      ),
    );
  }
}
