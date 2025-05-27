import 'dart:convert';
import 'package:http/http.dart' as http;

/// Serviço para consulta de CEP utilizando a API ViaCEP
class CepService {
  /// URL base da API ViaCEP
  static const String _baseUrl = 'https://viacep.com.br/ws';

  /// Busca endereço pelo CEP
  /// 
  /// Retorna um Map com os dados do endereço ou um Map vazio caso o CEP seja inválido
  static Future<Map<String, dynamic>> getAddressByCep(String cep ) async {
    // Remove caracteres não numéricos do CEP
    final cleanCep = cep.replaceAll(RegExp(r'[^0-9]'), '');
    
    // Verifica se o CEP tem 8 dígitos
    if (cleanCep.length != 8) {
      return {};
    }
    
    try {
      // Faz a requisição para a API ViaCEP
      final response = await http.get(Uri.parse('$_baseUrl/$cleanCep/json' ));
      
      // Verifica se a requisição foi bem sucedida
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Verifica se o CEP existe (a API retorna "erro": true para CEPs inexistentes)
        if (data.containsKey('erro') && data['erro'] == true) {
          return {};
        }
        
        // Formata o resultado para o padrão da aplicação
        return {
          'cep': data['cep']?.replaceAll('-', '') ?? '',
          'logradouro': data['logradouro'] ?? '',
          'complemento': data['complemento'] ?? '',
          'bairro': data['bairro'] ?? '',
          'localidade': data['localidade'] ?? '',
          'uf': data['uf'] ?? '',
          'ibge': data['ibge'] ?? '',
          'ddd': data['ddd'] ?? '',
        };
      }
      
      return {};
    } catch (e) {
      print('Erro ao buscar CEP: $e');
      return {};
    }
  }
  
  /// Formata o endereço completo a partir dos dados retornados pela API
  static String formatFullAddress(Map<String, dynamic> addressData) {
    if (addressData.isEmpty) {
      return '';
    }
    
    final parts = <String>[];
    
    if (addressData['logradouro']?.isNotEmpty ?? false) {
      parts.add(addressData['logradouro']);
    }
    
    if (addressData['bairro']?.isNotEmpty ?? false) {
      parts.add('${addressData['bairro']}');
    }
    
    if (addressData['localidade']?.isNotEmpty ?? false) {
      final city = addressData['localidade'];
      final state = addressData['uf'] ?? '';
      parts.add('$city${state.isNotEmpty ? ' - $state' : ''}');
    }
    
    if (addressData['cep']?.isNotEmpty ?? false) {
      final cep = addressData['cep'];
      final formattedCep = cep.length == 8 
          ? '${cep.substring(0, 5)}-${cep.substring(5)}' 
          : cep;
      parts.add('CEP: $formattedCep');
    }
    
    return parts.join(', ');
  }
  
  /// Valida se um CEP está no formato correto
  static bool isValidCep(String cep) {
    final cleanCep = cep.replaceAll(RegExp(r'[^0-9]'), '');
    return cleanCep.length == 8;
  }
}
