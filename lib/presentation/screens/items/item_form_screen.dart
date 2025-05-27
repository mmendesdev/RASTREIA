import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stolen_items_app/core/services/cep_service.dart';
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

  // Controladores para os campos de endereço
  final _cepController = TextEditingController();
  final _logradouroController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _estadoController = TextEditingController();
  final _complementoController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  bool _isEditing = false;
  bool _isFetchingCep = false;

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
      _cepController.text = item['cep'] as String? ?? '';
      _logradouroController.text = item['logradouro'] as String? ?? '';
      _bairroController.text = item['bairro'] as String? ?? '';
      _cidadeController.text = item['cidade'] as String? ?? '';
      _estadoController.text = item['estado'] as String? ?? '';
      _complementoController.text = item['complemento'] as String? ?? '';
      _selectedDate = item['date'] as DateTime;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _typeController.dispose();
    _cepController.dispose();
    _logradouroController.dispose();
    _bairroController.dispose();
    _cidadeController.dispose();
    _estadoController.dispose();
    _complementoController.dispose();
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

  // Busca o endereço pelo CEP
  Future<void> _fetchAddressByCep() async {
    final cep = _cepController.text.trim();

    if (!CepService.isValidCep(cep)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('CEP inválido. Digite um CEP com 8 dígitos.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isFetchingCep = true;
    });

    try {
      final addressData = await CepService.getAddressByCep(cep);

      if (addressData.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('CEP não encontrado. Verifique o número digitado.'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        setState(() {
          _logradouroController.text = addressData['logradouro'] ?? '';
          _bairroController.text = addressData['bairro'] ?? '';
          _cidadeController.text = addressData['localidade'] ?? '';
          _estadoController.text = addressData['uf'] ?? '';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Endereço encontrado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao buscar CEP: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isFetchingCep = false;
      });
    }
  }

  // Formata o endereço completo para o campo location (se necessário)
  String _getFullAddress() {
    final parts = <String>[];

    if (_logradouroController.text.isNotEmpty) {
      parts.add(_logradouroController.text);
    }

    if (_complementoController.text.isNotEmpty) {
      parts.add(_complementoController.text);
    }

    if (_bairroController.text.isNotEmpty) {
      parts.add(_bairroController.text);
    }

    if (_cidadeController.text.isNotEmpty) {
      final cidade = _cidadeController.text;
      final estado = _estadoController.text;
      parts.add('$cidade${estado.isNotEmpty ? ' - $estado' : ''}');
    }

    if (_cepController.text.isNotEmpty) {
      parts.add('CEP: ${_cepController.text}');
    }

    return parts.join(', ');
  }

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulação de salvamento - em produção, conectaria com a API
      // Você precisará adaptar esta parte para usar os novos campos de endereço
      // e salvar no Firebase ou onde for necessário.
      // Exemplo:
      // final item = StolenItem.create(
      //   title: _titleController.text,
      //   description: _descriptionController.text,
      //   type: _typeController.text,
      //   date: _selectedDate,
      //   cep: _cepController.text,
      //   logradouro: _logradouroController.text,
      //   bairro: _bairroController.text,
      //   cidade: _cidadeController.text,
      //   estado: _estadoController.text,
      //   complemento: _complementoController.text,
      //   location: _getFullAddress(), // Ou use os campos individuais
      //   userId: 'user_id_atual', // Obtenha o ID do usuário logado
      // );
      // await repository.saveItem(item);

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

                    // CEP com botão de busca
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _cepController,
                            decoration: const InputDecoration(
                              labelText: 'CEP',
                              hintText: 'Ex: 64060-400',
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(8),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, digite o CEP';
                              }
                              if (!CepService.isValidCep(value)) {
                                return 'CEP inválido';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _isFetchingCep ? null : _fetchAddressByCep,
                          child: _isFetchingCep
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Buscar'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Logradouro
                    TextFormField(
                      controller: _logradouroController,
                      decoration: const InputDecoration(
                        labelText: 'Logradouro',
                        hintText: 'Ex: Rua Doutor Mariano Mendes',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, digite o logradouro';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Complemento
                    TextFormField(
                      controller: _complementoController,
                      decoration: const InputDecoration(
                        labelText: 'Complemento (opcional)',
                        hintText: 'Ex: Apto 101, Bloco B',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Bairro
                    TextFormField(
                      controller: _bairroController,
                      decoration: const InputDecoration(
                        labelText: 'Bairro',
                        hintText: 'Ex: Porto do Centro',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, digite o bairro';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Cidade e Estado em linha
                    Row(
                      children: [
                        // Cidade
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: _cidadeController,
                            decoration: const InputDecoration(
                              labelText: 'Cidade',
                              hintText: 'Ex: Teresina',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, digite a cidade';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Estado
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller: _estadoController,
                            decoration: const InputDecoration(
                              labelText: 'UF',
                              hintText: 'Ex: PI',
                            ),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(2),
                              TextInputFormatter.withFunction(
                                (oldValue, newValue) => TextEditingValue(
                                  text: newValue.text.toUpperCase(),
                                  selection: newValue.selection,
                                ),
                              ),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'UF';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
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
                        hintText:
                            'Descreva o objeto com detalhes (marca, modelo, cor, características específicas, etc.)',
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
                                    content: Text(
                                        'Funcionalidade em desenvolvimento'),
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
