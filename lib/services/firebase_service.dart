import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> testConnection() async {
    try {
      print('🔄 Iniciando teste completo do Firebase...');

      // Tenta criar um documento de teste
      print('📝 Criando documento de teste...');
      final docRef = await _firestore.collection('test').add({
        'timestamp': FieldValue.serverTimestamp(),
        'test': 'Conexão funcionando!',
        'testId': DateTime.now().millisecondsSinceEpoch.toString()
      });

      print('📖 Lendo documento criado...');
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        print('✅ Documento criado e lido com sucesso!');
        print('📄 Dados do documento: ${docSnapshot.data()}');

        // Limpa o documento de teste
        print('🧹 Limpando documento de teste...');
        await docRef.delete();
        print('✨ Teste concluído com sucesso!');
        return true;
      } else {
        print('❌ Documento não encontrado após criação');
        return false;
      }
    } catch (e) {
      print('❌ Erro no teste do Firebase:');
      print('❌ Detalhes do erro: $e');
      print('❌ Verifique se:');
      print('  1. As configurações no firebase_options.dart estão corretas');
      print('  2. O projeto está criado no Firebase Console');
      print('  3. O Firestore está habilitado no Console');
      return false;
    }
  }
}
