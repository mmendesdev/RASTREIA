import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Registrar usuário
  Future<UserCredential> registerUser({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    try {
      print('🔵 Iniciando registro de usuário...');
      print('📧 Email: $email');
      print('👤 Nome: $name');
      print('🎭 Role: $role');

      // Criar usuário no Firebase Auth
      print('🔑 Criando usuário no Firebase Auth...');
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('✅ Usuário criado no Auth com ID: ${userCredential.user?.uid}');

      // Salvar informações adicionais no Firestore
      print('💾 Salvando dados no Firestore...');
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('✅ Dados salvos no Firestore com sucesso!');

      return userCredential;
    } catch (e) {
      print('❌ Erro no registro:');
      print('❌ Tipo do erro: ${e.runtimeType}');
      print('❌ Mensagem do erro: $e');
      print('❌ Stack trace:');
      print(StackTrace.current);
      rethrow;
    }
  }

  // Login de usuário
  Future<UserCredential> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('❌ Erro no login: $e');
      rethrow;
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Obter usuário atual
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Verificar se o usuário está logado
  bool isUserLoggedIn() {
    return _auth.currentUser != null;
  }
}
