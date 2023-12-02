class Sistema {
  final int? id;
  final String nombre;
  final String foto;
  final String descripcion;
  final double tamano;
  final double distancia;

  Sistema({
    this.id,
    required this.nombre,
    required this.foto,
    required this.descripcion,
    required this.tamano,
    required this.distancia,
  });

  // Método para convertir un mapa en una instancia de Sistema
  factory Sistema.fromMap(Map<String, dynamic> map) {
    return Sistema(
      id: map['id'] as int?,
      nombre: map['nombre'] as String,
      foto: map['foto'] as String,
      descripcion: map['descripcion'] as String,
      tamano: map['tamano'] as double,
      distancia: map['distancia'] as double,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'foto': foto,
      'descripcion': descripcion,
      'tamano': tamano,
      'distancia': distancia,
    };
  }
}
