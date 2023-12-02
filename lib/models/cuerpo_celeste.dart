class CuerpoCeleste {
  final int? id;
  final String nombre;
  final String foto;
  final String descripcion;
  final String tipo;
  final String naturaleza;
  final double tamano;
  final double distancia;
  final int? sistemaId;

  CuerpoCeleste({
    this.id,
    required this.nombre,
    required this.foto,
    required this.descripcion,
    required this.tipo,
    required this.naturaleza,
    required this.tamano,
    required this.distancia,
    this.sistemaId,
  });

  // Método para convertir un mapa en una instancia de CuerpoCeleste
  factory CuerpoCeleste.fromMap(Map<String, dynamic> map) {
    return CuerpoCeleste(
      id: map['id'] as int?,
      nombre: map['nombre'] as String,
      foto: map['foto'] as String,
      descripcion: map['descripcion'] as String,
      tipo: map['tipo'] as String,
      naturaleza: map['naturaleza'] as String,
      tamano: map['tamano'] as double,
      distancia: map['distancia'] as double,
      sistemaId: map['sistemaId'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'foto': foto,
      'descripcion': descripcion,
      'tipo': tipo,
      'naturaleza': naturaleza,
      'tamano': tamano,
      'distancia': distancia,
      'sistemaId': sistemaId,
    };
  }
}
