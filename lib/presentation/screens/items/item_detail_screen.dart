import 'package:flutter/material.dart';
import 'package:stolen_items_app/presentation/widgets/common/app_bar.dart';

/// Tela de detalhes de um objeto roubado
class ItemDetailScreen extends StatefulWidget {
  const ItemDetailScreen({Key? key}) : super(key: key);

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    // Em um cenário real, receberíamos os dados via argumentos da rota
    // Por enquanto, usamos dados de exemplo
    final Map<String, dynamic> item = {
      'title': 'Smartphone Samsung Galaxy S21',
      'description': 'Smartphone Samsung Galaxy S21 Ultra, cor preta, 256GB de armazenamento. Possui uma pequena rachadura no canto superior direito da tela. IMEI: 123456789012345.',
      'type': 'Eletrônico',
      'location': 'Av. Paulista, 1000, São Paulo - SP',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'isRecovered': false,
      'images': [
        'https://example.com/image1.jpg',
        'https://example.com/image2.jpg',
      ],
      'userId': 1,
      'createdAt': DateTime.now().subtract(const Duration(days: 2, hours: 3)),
      'updatedAt': DateTime.now().subtract(const Duration(days: 1)),
    };

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Detalhes do Objeto',
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).pushNamed('/items/form', arguments: item);
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status do objeto
                  _buildStatusBadge(item['isRecovered'] as bool),
                  const SizedBox(height: 16),
                  
                  // Título
                  Text(
                    item['title'] as String,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Imagens (placeholder)
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Icon(Icons.image, size: 64, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Informações do objeto
                  _buildInfoSection(
                    context,
                    'Informações do Objeto',
                    [
                      _buildInfoItem(context, 'Tipo', item['type'] as String),
                      _buildInfoItem(
                        context,
                        'Data do Roubo',
                        _formatDate(item['date'] as DateTime),
                      ),
                      _buildInfoItem(
                        context,
                        'Local do Roubo',
                        item['location'] as String,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Descrição
                  _buildInfoSection(
                    context,
                    'Descrição',
                    [
                      Text(
                        item['description'] as String,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Informações de registro
                  _buildInfoSection(
                    context,
                    'Informações de Registro',
                    [
                      _buildInfoItem(
                        context,
                        'Registrado em',
                        _formatDateTime(item['createdAt'] as DateTime),
                      ),
                      _buildInfoItem(
                        context,
                        'Última atualização',
                        _formatDateTime(item['updatedAt'] as DateTime),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  // Botão para marcar como recuperado
                  if (!item['isRecovered'])
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _markAsRecovered(context);
                        },
                        icon: const Icon(Icons.check_circle),
                        label: const Text('MARCAR COMO RECUPERADO'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildStatusBadge(bool isRecovered) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isRecovered ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isRecovered ? Icons.check_circle : Icons.report_problem,
            size: 16,
            color: isRecovered ? Colors.green : Colors.orange,
          ),
          const SizedBox(width: 4),
          Text(
            isRecovered ? 'Recuperado' : 'Não Recuperado',
            style: TextStyle(
              color: isRecovered ? Colors.green : Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 0,
          color: Colors.grey.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatDateTime(DateTime dateTime) {
    return '${_formatDate(dateTime)} às ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _markAsRecovered(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Recuperação'),
        content: const Text(
          'Tem certeza que deseja marcar este objeto como recuperado?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('CANCELAR'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _isLoading = true;
              });
              
              // Simulação de atualização - em produção, conectaria com a API
              Future.delayed(const Duration(seconds: 1), () {
                setState(() {
                  _isLoading = false;
                });
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Objeto marcado como recuperado com sucesso!'),
                    backgroundColor: Colors.green,
                  ),
                );
                
                Navigator.of(context).pop(); // Volta para a tela anterior
              });
            },
            child: const Text('CONFIRMAR'),
          ),
        ],
      ),
    );
  }
}
