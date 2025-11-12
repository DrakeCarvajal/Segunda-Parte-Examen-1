class Ingrediente {
  final String? nombreIngrediente;
  final int? cantidad;
  final String? estado;
  final String? tienda;
  final int? precio;
  final String? prioridad;

  Ingrediente(
      {required this.nombreIngrediente,
      this.cantidad,
      this.estado,
      this.tienda,
      this.precio,
      this.prioridad});
}
