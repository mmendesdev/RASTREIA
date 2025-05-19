/// Modelo de objeto roubado para o aplicativo
/// 
/// Este modelo representa um objeto roubado registrado por um usuário,
/// contendo informações detalhadas sobre o item, localização e status.
class StolenItem {
  final int? id;
  final int? serverId;
  final String title;
  final String description;
  final String type;
  final String location;
  final DateTime date;
  final bool isRecovered;
  final List<String> images;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;
  
  /// Construtor principal
  StolenItem({
    this.id,
    this.serverId,
    required this.title,
    required this.description,
    required this.type,
    required this.location,
    required this.date,
    this.isRecovered = false,
    this.images = const [],
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.isSynced = false,
  });
  
  /// Cria uma cópia do objeto com os campos atualizados
  StolenItem copyWith({
    int? id,
    int? serverId,
    String? title,
    String? description,
    String? type,
    String? location,
    DateTime? date,
    bool? isRecovered,
    List<String>? images,
    int? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
  }) {
    return StolenItem(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      location: location ?? this.location,
      date: date ?? this.date,
      isRecovered: isRecovered ?? this.isRecovered,
      images: images ?? this.images,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }
  
  /// Converte o modelo para um Map para armazenamento no banco de dados
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'server_id': serverId,
      'title': title,
      'description': description,
      'type': type,
      'location': location,
      'date': date.toIso8601String(),
      'is_recovered': isRecovered ? 1 : 0,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_synced': isSynced ? 1 : 0,
    };
  }
  
  /// Cria um modelo a partir de um Map do banco de dados
  factory StolenItem.fromMap(Map<String, dynamic> map) {
    return StolenItem(
      id: map['id'],
      serverId: map['server_id'],
      title: map['title'],
      description: map['description'],
      type: map['type'],
      location: map['location'],
      date: DateTime.parse(map['date']),
      isRecovered: map['is_recovered'] == 1,
      images: [], // As imagens são carregadas separadamente
      userId: map['user_id'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      isSynced: map['is_synced'] == 1,
    );
  }
  
  /// Converte o modelo para JSON para envio à API
  Map<String, dynamic> toJson() {
    return {
      'id': serverId,
      'title': title,
      'description': description,
      'type': type,
      'location': location,
      'date': date.toIso8601String(),
      'is_recovered': isRecovered,
      'images': images,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
  
  /// Cria um modelo a partir de um JSON da API
  factory StolenItem.fromJson(Map<String, dynamic> json) {
    return StolenItem(
      serverId: json['id'],
      title: json['title'],
      description: json['description'],
      type: json['type'],
      location: json['location'],
      date: DateTime.parse(json['date']),
      isRecovered: json['is_recovered'],
      images: List<String>.from(json['images'] ?? []),
      userId: json['user_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      isSynced: true,
    );
  }
}
