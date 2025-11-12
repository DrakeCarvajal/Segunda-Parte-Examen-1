import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/recipe.dart';
import '../providers/recipe_provider.dart';
import 'package:flutter/services.dart';

// Widget que muestra una tarjeta de receta compacta con título, tiempo, instrucciones y foto.
class RecipeCard extends StatelessWidget {
  final Recipe recipe; // Receta a mostrar.

  const RecipeCard({super.key, required this.recipe});

  // Pequeña utilidad para mostrar feedback rápido al usuario.
  void _toast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
     SnackBar(content: Text(msg), duration: const Duration(milliseconds: 900)),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Envolvemos TODA la tarjeta con GestureDetector para capturar gestos básicos.
    // - onTap: navegación a editar (lo que ya hacías con InkWell)
    // - onDoubleTap: ejemplo sencillo -> alternar favorito
    // - onLongPress: ejemplo sencillo -> mostrar un mensaje
    return GestureDetector(
      onTap: () {
      // feedback muy visible para TAP
       HapticFeedback.selectionClick(); // vibración leve (si hay)
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(
            content: const Text('TAP en la tarjeta'),
            duration: const Duration(milliseconds: 1200),
          backgroundColor: Colors.blueAccent,
        ),
     );

     // tu acción real (navegar a editar)
      context.go('/edit-recipe/${recipe.id}');
   },

  onDoubleTap: () {
     HapticFeedback.mediumImpact();

    final provider = context.read<RecipeProvider>();
    final estabaFav = recipe.isFavorite;
    provider.toggleFavorite(recipe.id!);

    // Usa dos SnackBar const y elige uno según la condición
    final snack = estabaFav
        ? const SnackBar(
            content: Text('DOUBLE TAP → quitada de favoritos'),
            duration: Duration(milliseconds: 1400),
            backgroundColor: Colors.pinkAccent,
          )
        : const SnackBar(
            content: Text('DOUBLE TAP → añadida a favoritos'),
            duration: Duration(milliseconds: 1400),
            backgroundColor: Colors.pinkAccent,
          );

    ScaffoldMessenger.of(context).showSnackBar(snack);
  },


  onLongPress: () {
    // feedback muy visible para LONG PRESS
    HapticFeedback.heavyImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(' LONG PRESS en la tarjeta'),
        duration: Duration(milliseconds: 1400),
        backgroundColor: Colors.deepPurple,
      ),
    );

    debugPrint('[GestureDetector] onLongPress sobre tarjeta');
  },

      //Tu Card original se mantiene tal cual como child del GestureDetector.
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen de la receta o placeholder, con tamaño reducido.
            // ENVOLVEMOS EN UN STACK PARA SUPERPONER LA estrella DE FAVORITOS.
            Stack( // NUEVO (ya lo tenías marcado como NUEVO en tu código)
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: SizedBox(
                    height: 120, // Reducido de 120px a 80px para tarjetas más pequeñas.
                    width: double.infinity,
                    child: recipe.photoBytes != null
                        ? Image.memory(
                            recipe.photoBytes!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                          )
                        : _buildPlaceholder(),
                  ),
                ),
                // Botón de favorito superpuesto en la esquina superior derecha.
                Positioned(
                  top: 8,
                  right: 8,
                  child: Consumer<RecipeProvider>(
                    builder: (context, provider, _) {
                      final isFav = recipe.isFavorite; // Estado actual
                      return Material(
                        color: Colors.black.withOpacity(0.2), // Fondo circular semitransparente
                        shape: const CircleBorder(),
                        child: IconButton(
                          tooltip: isFav ? 'Quitar de favoritos' : 'Añadir a favoritos',
                          icon: Icon(
                            isFav ? Icons.star : Icons.star_border,
                            color: Colors.yellow[600],
                          ),
                          onPressed: () => provider.toggleFavorite(recipe.id!), // Alterna favorito
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(6.0), // Reducido de 8px para mayor compacidad.
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título de la receta.
                  Text(
                    recipe.title,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[800],
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Tiempo de preparación.
                  Text(
                    'Tiempo: ${recipe.preparationTime >= 60 && recipe.preparationTime % 60 == 0 ? "${recipe.preparationTime ~/ 60} h" : "${recipe.preparationTime} min"}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  // Instrucciones de elaboración (truncadas).
                  Text(
                    recipe.instructions?.isNotEmpty == true ? recipe.instructions! : 'Sin instrucciones',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  // Botón para eliminar la receta.
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red[400], size: 20),
                      onPressed: () {
                        Provider.of<RecipeProvider>(context, listen: false).deleteRecipe(recipe.id!);
                      },
                      tooltip: 'Eliminar receta',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget para mostrar un placeholder si no hay imagen o hay error.
  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: Icon(Icons.image, size: 40, color: Colors.grey[600]),
    );
  }
}


