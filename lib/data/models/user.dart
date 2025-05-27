/// Modelo de usuário para o aplicativo de registro de objetos roubados
/// 
/// Este modelo representa um usuário do sistema, que pode ser um cidadão
/// comum ou um policial, com diferentes níveis de acesso.
class User {
  final int? id;
  final int? serverId;
  final String name;
  final String email;
  final String? photoUrl;
  final String role; // 'citizen' ou 'police'
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;
  
  /// Construtor principal
  User({
    this.id,
    this.serverId,
    required this.name,
    required this.email,
    this.photoUrl,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    this.isSynced = false,
  });
  
  /// Cria uma cópia do objeto com os campos atualizados
  User copyWith({
    int? id,
    int? serverId,
    String? name,
    String? email,
    String? photoUrl,
    String? role,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
  }) {
    return User(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
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
      'name': name,
      'email': email,
      'photo_url': photoUrl,
      'role': role,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_synced': isSynced ? 1 : 0,
    };
  }
  
  /// Cria um modelo a partir de um Map do banco de dados
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      serverId: map['server_id'],
      name: map['name'],
      email: map['email'],
      photoUrl: map['photo_url'],
      role: map['role'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      isSynced: map['is_synced'] == 1,
    );
  }
  
  /// Converte o modelo para JSON para envio à API
  Map<String, dynamic> toJson() {
    return {
      'id': serverId,
      'name': name,
      'email': email,
      'photo_url': photoUrl,
      'role': role,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
  
  /// Cria um modelo a partir de um JSON da API
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      serverId: json['id'],
      name: json['name'],
      email: json['email'],
      photoUrl: json['photo_url'],
      role: json['role'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      isSynced: true,
    );
  }
}
