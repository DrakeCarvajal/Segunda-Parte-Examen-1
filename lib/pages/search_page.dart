import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/recipe_provider.dart'; // ← Proveedor global con la lista de recetas
import '../widgets/recipe_card.dart';       // ← Tarjeta ya existente, la reutilizamos
import '../models/recipe.dart';             // ← Modelo de Receta

/// Pantalla de Búsqueda rápida.
/// - Filtra por TÍTULO en vivo (case-insensitive, con trim)
/// - Si no hay texto → muestra TODAS las recetas
/// - Reutiliza RecipeCard para resultados
/// - Muestra estado “sin resultados” cuando no hay coincidencias
/// - (EJERCICIO 4) Filtro por CATEGORÍA con AND (Todas/Desayuno/Comida/Cena)
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // Controlador del TextField para leer lo que escribe el usuario
  final TextEditingController _controller = TextEditingController();

  // Texto “normalizado” que usamos para el filtrado (trim para quitar espacios)
  String _query = '';

  // === EJERCICIO 4: estado y datos del filtro por categoría ===
  // Lista fija de categorías + "Todas"
  final List<String> _categories = const ['Todas', 'Desayuno', 'Comida', 'Cena'];
  // Selección actual en el filtro
  String _selectedCategory = 'Todas';

  @override
  void initState() {
    super.initState();

    // Escuchamos cambios del TextField para filtrar “en vivo”.
    _controller.addListener(() {
      final q = _controller.text.trim();
      if (q != _query) {
        setState(() => _query = q);
      }
    });
  }

  @override
  void dispose() {
    // Importante: liberar el controlador cuando se destruye la pantalla
    _controller.dispose();
    super.dispose();
  }

  /// Devuelve la lista de recetas filtradas por:
  /// - Título (case-insensitive, contiene)
  /// - (EJERCICIO 4) Categoría: AND con la condición anterior
  ///
  /// Reglas:
  /// - Si _query está vacío → mantiene todas (respecto a título)
  /// - Si _selectedCategory == 'Todas' → ignora categoría, aplica solo título
  List<Recipe> _filter(List<Recipe> all) {
    // 1) Filtrado por texto (título)
    final List<Recipe> byTitle;
    if (_query.isEmpty) {
      byTitle = all;
    } else {
      final q = _query.toLowerCase();
      byTitle = all.where((r) => r.title.toLowerCase().contains(q)).toList();
    }

    // 2) (EJERCICIO 4) Filtrado por categoría con AND
    if (_selectedCategory == 'Todas') {
      return byTitle; // no filtramos por categoría
    }
    return byTitle.where((r) => r.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    // 1) Obtenemos TODAS las recetas desde el Provider
    final recipes = context.watch<RecipeProvider>().recipes;

    // 2) Calculamos los resultados según el texto y la categoría actuales
    final results = _filter(recipes);

    return Scaffold(
      appBar: AppBar(title: const Text('Buscar')),

      // Estructura principal: barra de búsqueda + (EJ.4) filtro categoría + resultados
      body: Column(
        children: [
          // ====== BARRA DE BÚSQUEDA (texto) ======
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _controller,                  // ← texto de búsqueda
              textInputAction: TextInputAction.search,  // ← UX del teclado
              decoration: InputDecoration(
                hintText: 'Buscar por título…',
                prefixIcon: const Icon(Icons.search),
                // Botón “X” para limpiar; solo aparece si hay texto
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        tooltip: 'Limpiar',
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();            // limpia texto → listener actualiza _query
                          FocusScope.of(context).unfocus(); // opcional: cierra teclado
                        },
                      )
                    : null,
                border: const OutlineInputBorder(),
              ),
            ),
          ),

          // ====== (EJERCICIO 4) FILTRO POR CATEGORÍA ======
          // Desplegable simple independiente del TextField: aplica AND
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Categoría',
                border: OutlineInputBorder(),
              ),
              items: _categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _selectedCategory = val); // refresca resultados
                }
              },
            ),
          ),

          // ====== RESULTADOS ======
          Expanded(
            child: results.isEmpty
                ? const _EmptyResults()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final recipe = results[index];
                      // Reutilizamos la misma tarjeta de la lista principal
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: RecipeCard(recipe: recipe),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/// Widget pequeño para mostrar cuando no hay coincidencias.
/// Mantenerlo separado mejora la legibilidad y facilita cambiar el diseño.
class _EmptyResults extends StatelessWidget {
  const _EmptyResults();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, size: 48, color: Colors.grey),
            SizedBox(height: 12),
            Text(
              'No se encontraron recetas',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
