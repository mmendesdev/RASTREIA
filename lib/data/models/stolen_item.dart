// Arquivo: lib/data/models/stolen_item.dart
// Modelo atualizado para trabalhar com Firestore e incluir campos de endereço detalhados

class StolenItem {
  final String id;
  final String title;
  final String description;
  final String type;
  final DateTime date;

  // Campos de endereço detalhados
  final String cep;
  final String logradouro;
  final String bairro;
  final String cidade;
  final String estado;
  final String complemento;

  // Campo de localização completa (para compatibilidade com código existente)
  final String location;

  final bool isRecovered;
  final String userId;
  final List<String> images;
  final String serialNumber;

  StolenItem({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.date,
    this.cep = '',
    this.logradouro = '',
    this.bairro = '',
    this.cidade = '',
    this.estado = '',
    this.complemento = '',
    required this.location,
    this.isRecovered = false,
    required this.userId,
    this.images = const [],
    this.serialNumber = '',
  });

  // Método para criar cópia com campos atualizados
  StolenItem copyWith({
    String? id,
    String? title,
    String? description,
    String? type,
    DateTime? date,
    String? cep,
    String? logradouro,
    String? bairro,
    String? cidade,
    String? estado,
    String? complemento,
    String? location,
    bool? isRecovered,
    String? userId,
    List<String>? images,
    String? serialNumber,
  }) {
    return StolenItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      date: date ?? this.date,
      cep: cep ?? this.cep,
      logradouro: logradouro ?? this.logradouro,
      bairro: bairro ?? this.bairro,
      cidade: cidade ?? this.cidade,
      estado: estado ?? this.estado,
      complemento: complemento ?? this.complemento,
      location: location ?? this.location,
      isRecovered: isRecovered ?? this.isRecovered,
      userId: userId ?? this.userId,
      images: images ?? this.images,
      serialNumber: serialNumber ?? this.serialNumber,
    );
  }

  // Conversão para JSON (Firestore)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'date': date.toIso8601String(),
      'cep': cep,
      'logradouro': logradouro,
      'bairro': bairro,
      'cidade': cidade,
      'estado': estado,
      'complemento': complemento,
      'location': location,
      'isRecovered': isRecovered,
      'userId': userId,
      'images': images,
      'serialNumber': serialNumber,
      'updatedAt':
          DateTime.now().toIso8601String(), // Para controle de sincronização
    };
  }

  // Criação a partir de JSON (Firestore)
  factory StolenItem.fromJson(Map<String, dynamic> json) {
    return StolenItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? '',
      date:
          json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      cep: json['cep'] ?? '',
      logradouro: json['logradouro'] ?? '',
      bairro: json['bairro'] ?? '',
      cidade: json['cidade'] ?? '',
      estado: json['estado'] ?? '',
      complemento: json['complemento'] ?? '',
      location: json['location'] ?? '',
      isRecovered: json['isRecovered'] ?? false,
      userId: json['userId'] ?? '',
      images: json['images'] != null ? List<String>.from(json['images']) : [],
      serialNumber: json['serialNumber'] ?? '',
    );
  }

  // Criação de um novo item com ID gerado
  factory StolenItem.create({
    required String title,
    required String description,
    required String type,
    required DateTime date,
    String cep = '',
    String logradouro = '',
    String bairro = '',
    String cidade = '',
    String estado = '',
    String complemento = '',
    required String location,
    required String userId,
    List<String> images = const [],
    String serialNumber = '',
  }) {
    // ID temporário que será substituído pelo ID do Firestore
    final id = DateTime.now().millisecondsSinceEpoch.toString();

    return StolenItem(
      id: id,
      title: title,
      description: description,
      type: type,
      date: date,
      cep: cep,
      logradouro: logradouro,
      bairro: bairro,
      cidade: cidade,
      estado: estado,
      complemento: complemento,
      location: location,
      isRecovered: false,
      userId: userId,
      images: images,
      serialNumber: serialNumber,
    );
  }
}
