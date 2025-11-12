// lib/widgets/custom_scaffold.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Widget de Scaffold personalizado con:
/// - AppBar con logo y botón de volver opcional
/// - Acciones configurables en AppBar
/// - Fondo con degradado y bordes redondeados
/// - (NUEVO) Opción sencilla para mostrar un botón de BÚSQUEDA en el AppBar
class CustomScaffold extends StatelessWidget {
  final Widget body;                        // Contenido del cuerpo (obligatorio).
  final bool showBackButton;                // ¿Mostrar botón de volver en AppBar?
  final Widget? floatingActionButton;       // FAB opcional.
  final List<Widget>? actions;              // Acciones personalizadas en AppBar (si las pasas, se respetan).

  /// (NUEVO) Activa un IconButton de búsqueda por defecto en el AppBar.
  /// Útil para la pantalla principal: al pulsar navega a '/search'.
  final bool showSearchAction;

  const CustomScaffold({
    super.key,
    required this.body,
    this.showBackButton = true,
    this.floatingActionButton,
    this.actions,
    this.showSearchAction = false, // ← por defecto NO se muestra la lupa
  });

  @override
  Widget build(BuildContext context) {
    // ===== Construimos la lista final de acciones para el AppBar =====
    // Prioridad:
    // 1) Si el usuario pasa `actions`, las usamos tal cual.
    // 2) Si NO pasa `actions` y `showSearchAction == true`, añadimos la lupa.
    // 3) Si ninguna de las anteriores, se queda vacío.
    final appBarActions = actions ??
        (showSearchAction
            ? <Widget>[
                IconButton(
                  tooltip: 'Buscar',
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    // Navegamos a la pantalla de Búsqueda (Ejercicio 1)
                    // Usamos push para poder volver con "atrás"
                    context.push('/search');
                  },
                ),
              ]
            : null);

    return Scaffold(
      // ================== APPBAR ==================
      appBar: AppBar(
        // Botón de volver (si procede). En este proyecto
        // lo resolvéis navegando a '/', pero podrías usar context.pop() si quieres ir a la pantalla previa.
        leading: showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => context.go('/'), // Navega a la pantalla principal.
                tooltip: 'Volver',
              )
            : null,

        // Logo centrado con bordes redondeados
        title: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            'assets/images/logo.png',
            height: 40,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.restaurant_menu, color: Colors.white, size: 40),
          ),
        ),
        centerTitle: true,

        // Acciones a la derecha del AppBar:
        // - Si pasaste `actions`, se usan.
        // - Si no, y `showSearchAction` es true, mostramos la lupa.
        actions: appBarActions,

        // Estética del AppBar (colores, gradiente y sombra)
        backgroundColor: Colors.orange[700],
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange[700]!, Colors.orange[500]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
      ),

      // ================== CUERPO ==================
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.orange[100]!, Colors.white],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          // Asegura que el contenido respete los bordes redondeados
          borderRadius: BorderRadius.circular(20),
          child: body,
        ),
      ),

      // ================== FAB ==================
      floatingActionButton: floatingActionButton,
    );
  }
}
