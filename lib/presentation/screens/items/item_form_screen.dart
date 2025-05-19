import 'package:flutter/material.dart';
import 'package:stolen_items_app/presentation/widgets/common/app_bar.dart';

/// Tela de cadastro/edição de objetos roubados
class ItemFormScreen extends StatefulWidget {
  const ItemFormScreen({Key? key}) : super(key: key);

  @override
  State<ItemFormScreen> createState() => _ItemFormScreenState();
}

class _ItemFormScreenState extends State<ItemFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _typeController = TextEditingController();
  final _locationController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    // Em um cenário real, verificaríamos se há argumentos da rota
    // para determinar se estamos editando um item existente
    Future.delayed(Duration.zero, () {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is Map<String, dynamic>) {
        _isEditing = true;
        _populateForm(args);
      }
    });
  }

  void _populateForm(Map<String, dynamic> item) {
    setState(() {
      _titleController.text = item['title'] as String;
      _descriptionController.text = item['description'] as String;
      _typeController.text = item['type'] as String;
      _locationController.text = item['location'] as String;
      _selectedDate = item['date'] as DateTime;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _typeController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      // Simulação de salvamento - em produção, conectaria com a API
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditing
                ? 'Objeto atualizado com sucesso!'
                : 'Objeto registrado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        
        Navigator.of(context).pop(); // Volta para a tela anterior
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: _isEditing ? 'Editar Objeto' : 'Registrar Objeto',
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Título',
                        hintText: 'Ex: Smartphone Samsung Galaxy S21',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, digite um título';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Tipo
                    TextFormField(
                      controller: _typeController,
                      decoration: const InputDecoration(
                        labelText: 'Tipo',
                        hintText: 'Ex: Eletrônico, Veículo, Acessório',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, digite o tipo do objeto';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Local do roubo
                    TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                        labelText: 'Local do Roubo',
                        hintText: 'Ex: Av. Paulista, 1000, São Paulo - SP',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, digite o local do roubo';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Data do roubo
                    InkWell(
                      onTap: () => _selectDate(context),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Data do Roubo',
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Descrição
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: 'Descrição',
                        hintText: 'Descreva o objeto com detalhes (marca, modelo, cor, características específicas, etc.)',
                        alignLabelWithHint: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, digite uma descrição';
                        }
                        if (value.length < 10) {
                          return 'A descrição deve ter pelo menos 10 caracteres';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    
                    // Upload de imagens (placeholder)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Imagens',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Center(
                            child: IconButton(
                              icon: const Icon(Icons.add_a_photo),
                              onPressed: () {
                                // Implementação futura: seleção de imagens
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Funcionalidade em desenvolvimento'),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    
                    // Botão de salvar
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveItem,
                        child: Text(_isEditing ? 'ATUALIZAR' : 'REGISTRAR'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
