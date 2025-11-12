// lib/pages/ingrediente_page.dart
//import 'dart:nativewrappers/_internal/vm/lib/ffi_native_type_patch.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
// import 'package:go_router/go_router.dart';
import '../widgets/custom_scaffold.dart';
import '../models/ingrediente.dart'; // Modelo de datos de ingredientes.

class IngredientePage extends StatelessWidget {
  const IngredientePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _nombreIngredienteController =
        TextEditingController();
    final TextEditingController _cantidadController = TextEditingController();
    final TextEditingController _tiendaController = TextEditingController();
    final TextEditingController _precioController = TextEditingController();

    String _estadoSeleccionado = "Pendiente";
    String _prioridadSeleccionada = "Media";
    return CustomScaffold(
        showBackButton: true, // El back del AppBar hace pop()
        body: SafeArea(
            child: Form(
                child: ListView(padding: const EdgeInsets.all(16), children: [
          const Text(
            'Lista de la compra',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          //TODO: NOMBRE (texto, REQUERIDO con mensaje de texto de validación)
          // Campo para el título de la receta.
          TextFormField(
            controller: _nombreIngredienteController,
            decoration: InputDecoration(
              labelText: 'Nombre del ingrediente',
              prefixIcon:
                  Icon(Icons.restaurant_menu, color: Colors.orange[700]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            validator: (value) =>
                value!.isEmpty ? 'Escribe el nombre del ingrediente' : null,
          ),
          const SizedBox(height: 20),

          //TODO: Cantidad (entera, sin decimales)
          TextFormField(
            controller: _cantidadController,
            decoration: InputDecoration(
              labelText: 'Cantidad (entera)',
              prefixIcon:
                  Icon(Icons.restaurant_menu, color: Colors.orange[700]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            validator: (value) =>
                value!.isEmpty ? 'Escribe el nombre del ingrediente' : null,
          ),
          const SizedBox(height: 20),

          //TODO: Estado (Pendiente/Comprado) --> DropdownButtonFormField
          DropdownButtonFormField<String>(
            initialValue: _estadoSeleccionado,
            decoration: const InputDecoration(
              labelText: 'Provincias de la CV',
              prefixIcon: Icon(
                Icons.place,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            items: const [
              DropdownMenuItem(value: 'Pendiente', child: Text('Pendiente')),
              DropdownMenuItem(value: 'Comprado', child: Text('Comprado')),
            ],
            onChanged: (value) {
              // Actualizar la categoría seleccionada

              _estadoSeleccionado = value!;
            },
          ),
          const SizedBox(height: 20),

          //TODO: Tienda (texto)
          TextFormField(
            controller: _tiendaController,
            decoration: InputDecoration(
              labelText: 'Tienda',
              prefixIcon:
                  Icon(Icons.restaurant_menu, color: Colors.orange[700]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            // validator: (value) => value!.isEmpty ? 'Escribe el nombre del ingrediente' : null,
          ),
          const SizedBox(height: 20),

          //TODO: Precio estimado (entero, sin decimales)
          TextFormField(
            controller: _precioController,
            decoration: InputDecoration(
              labelText: 'Precio estimado (entero)',
              prefixIcon:
                  Icon(Icons.restaurant_menu, color: Colors.orange[700]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            // validator: (value) => value!.isEmpty ? 'Escribe el nombre del ingrediente' : null,
          ),
          const SizedBox(height: 20),

          //TODO: Prioridad (Alta, Media, Baja) --> DropdownButtonFormField
          DropdownButtonFormField<String>(
            initialValue: _prioridadSeleccionada,
            decoration: const InputDecoration(
              labelText: 'Provincias de la CV',
              prefixIcon: Icon(
                Icons.place,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            items: const [
              DropdownMenuItem(value: 'Alta', child: Text('Alta')),
              DropdownMenuItem(value: 'Media', child: Text('Media')),
              DropdownMenuItem(value: 'Baja', child: Text('Baja')),
            ],
            onChanged: (value) {
              // Actualizar la categoría seleccionada

              _prioridadSeleccionada = value!;
            },
          ),
          const SizedBox(height: 20),

          //TODO: Botón Agregar Ingrediente
          Builder(
              // Builder para obtener un context HIJO del Form
              builder: (innerContext) => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (_nombreIngredienteController.text.isNotEmpty) {
                        int? cantidad = int.tryParse(_cantidadController.text);
                        int? precio = int.tryParse(_precioController.text);
                        if (cantidad != null && precio != null) {
                          final nuevoIngrediente = Ingrediente(
                              nombreIngrediente:
                                  _nombreIngredienteController.text,
                              cantidad: cantidad,
                              estado: _estadoSeleccionado,
                              tienda: _tiendaController.text,
                              precio: precio,
                              prioridad: _prioridadSeleccionada);

                          context.go('/');
                        } else {
                          // Mostrar un mensaje de error si el título está vacío
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Row(
                                children: const [
                                  Icon(Icons.warning, color: Color(0xFF2D3748)),
                                  SizedBox(width: 8),
                                  Text(
                                      'Los campos Cantidad y Precio deben ser números enteros'),
                                ],
                              ),
                              backgroundColor: const Color(
                                0xFFE53E3E,
                              ), // Color rojo suave
                            ),
                          );
                        }
                      } else {
                        // Mostrar un mensaje de error si el título está vacío
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Row(
                              children: const [
                                Icon(Icons.warning, color: Color(0xFF2D3748)),
                                SizedBox(width: 8),
                                Text(
                                    'El nombre del ingrediente es obligatorio'),
                              ],
                            ),
                            backgroundColor: const Color(
                              0xFFE53E3E,
                            ), // Color rojo suave
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.check),
                    label: const Text("Agregar Ingrediente"),
                  ) //Definir tipo botón ElevatedButton)
                  //TODO: FINALIZA EL BOTÓN DE Agregar Ingrediente

                  ))
        ]))));
  }
}
