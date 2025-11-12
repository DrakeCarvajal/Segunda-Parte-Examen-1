import 'dart:convert'; // Para codificación/decodificación JSON.
import 'package:flutter/foundation.dart' show Uint8List;

// Clase que representa un ingrediente con nombre y cantidad en gramos.
class Ingredient {
  final String name; // Nombre del ingrediente.
  final int grams;   // Cantidad en gramos.

  Ingredient({required this.name, required this.grams});

  // Convertir un ingrediente a JSON.
  Map<String, dynamic> toJson() => {
        'name': name,
        'grams': grams,
      };

  // Crear un ingrediente desde JSON.
  factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient(
        name: json['name'] as String,
        // A veces un número en JSON llega como num/double.
        // Usamos num → toInt() para evitar errores de tipo.
        grams: (json['grams'] as num).toInt(),
      );
}

// Clase que representa una receta con título, tiempo, ingredientes, instrucciones y foto.
class Recipe {
  String? id; // ID único de la receta (null al crear una nueva).
  final String title; // Título de la receta.
  final int preparationTime; // Tiempo de preparación en minutos.
  final List<Ingredient> ingredients; // Lista de ingredientes.
  final String? instructions; // Instrucciones de elaboración.
  final String? photoPath; // Ruta de la imagen (nativo, no persistida).
  final Uint8List? photoBytes; // Bytes de la imagen (web y persistencia).

  bool isFavorite;
  String category; // Desayuno, Comida, Cena

  Recipe({
    this.id,
    required this.title,
    required this.preparationTime,
    required this.ingredients,
    this.instructions,
    this.photoPath,
    this.photoBytes,
    this.isFavorite = false,
    this.category = 'Comida', // Valor por defecto (compatibilidad con datos antiguos)
  });

  // Convertir una receta a JSON.
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'preparationTime': preparationTime,
        'ingredients': ingredients.map((ing) => ing.toJson()).toList(),
        'instructions': instructions,
        // Guardamos la imagen como base64 si existe (null si no hay)
        'photoBytes': photoBytes != null ? base64Encode(photoBytes!) : null,
        'isFavorite': isFavorite,
        'category': category, // ✅ incluir categoría en persistencia
      };

  // Crear una receta desde JSON.
  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        id: json['id'] as String?,
        title: json['title'] as String,
        // Igual que en Ingredient: puede venir como num → lo convertimos a int.
        preparationTime: (json['preparationTime'] as num).toInt(),
        //i 'ingredients' no existe o es null, usamos lista vacía para evitar fallos.
        ingredients: (json['ingredients'] as List<dynamic>? ?? [])
            .map((item) => Ingredient.fromJson(item as Map<String, dynamic>))
            .toList(),
        instructions: json['instructions'] as String?,
        photoBytes: json['photoBytes'] != null
            ? base64Decode(json['photoBytes'] as String)
            : null,
        photoPath: null, // No persistir photoPath, ya que es temporal.
        isFavorite: (json['isFavorite'] as bool?) ?? false,
        // cast nullable para que el '?? "Comida"' tenga efecto real.
        category: (json['category'] as String?) ?? 'Comida',
      );
}
