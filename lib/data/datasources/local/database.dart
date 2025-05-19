import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Classe responsável pela configuração e gerenciamento do banco de dados SQLite
/// 
/// Esta classe implementa o padrão Singleton para garantir uma única instância
/// do banco de dados durante toda a execução do aplicativo.
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;
  
  // Nome do banco de dados
  final String _databaseName = 'stolen_items.db';
  
  // Versão do banco de dados
  final int _databaseVersion = 1;
  
  // Construtor factory para retornar a instância singleton
  factory DatabaseHelper() {
    return _instance;
  }
  
  // Construtor privado
  DatabaseHelper._internal();
  
  /// Obtém a instância do banco de dados, criando-a se necessário
  Future<Database> get database async {
    if (_database != null) return _database!;
    
    _database = await _initDatabase();
    return _database!;
  }
  
  /// Inicializa o banco de dados
  Future<Database> _initDatabase() async {
    // Obtém o caminho para o diretório de banco de dados
    String path = join(await getDatabasesPath(), _databaseName);
    
    // Abre/cria o banco de dados
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }
  
  /// Cria as tabelas do banco de dados na primeira execução
  Future<void> _onCreate(Database db, int version) async {
    // Tabela de usuários
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        server_id INTEGER,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        photo_url TEXT,
        role TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        is_synced INTEGER NOT NULL DEFAULT 0
      )
    ''');
    
    // Tabela de objetos roubados
    await db.execute('''
      CREATE TABLE stolen_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        server_id INTEGER,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        type TEXT NOT NULL,
        location TEXT NOT NULL,
        date TEXT NOT NULL,
        is_recovered INTEGER NOT NULL DEFAULT 0,
        user_id INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        is_synced INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');
    
    // Tabela de imagens dos objetos
    await db.execute('''
      CREATE TABLE item_images (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        stolen_item_id INTEGER NOT NULL,
        image_path TEXT NOT NULL,
        is_synced INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (stolen_item_id) REFERENCES stolen_items (id)
      )
    ''');
    
    // Tabela de fila de sincronização
    await db.execute('''
      CREATE TABLE sync_queue (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        entity_type TEXT NOT NULL,
        entity_id INTEGER NOT NULL,
        operation TEXT NOT NULL,
        data TEXT NOT NULL,
        created_at TEXT NOT NULL,
        attempts INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }
  
  /// Atualiza o esquema do banco de dados quando a versão é incrementada
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Implementar migrações futuras aqui
    if (oldVersion < 2) {
      // Exemplo: adicionar nova coluna em uma atualização futura
      // await db.execute('ALTER TABLE users ADD COLUMN new_column TEXT');
    }
  }
  
  /// Fecha a conexão com o banco de dados
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
    }
  }
}
