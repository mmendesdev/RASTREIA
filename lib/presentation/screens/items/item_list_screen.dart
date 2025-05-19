import 'package:flutter/material.dart';
import 'package:stolen_items_app/presentation/widgets/common/app_bar.dart';
import 'package:stolen_items_app/presentation/widgets/items/item_card.dart';

/// Tela de listagem de objetos roubados
class ItemListScreen extends StatefulWidget {
  const ItemListScreen({Key? key}) : super(key: key);

  @override
  State<ItemListScreen> createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'all'; // 'all', 'recovered', 'not_recovered'
  bool _isLoading = false;

  // Dados de exemplo
  final List<Map<String, dynamic>> _allItems = [
    {
      'title': 'Smartphone Samsung Galaxy S21',
      'type': 'Eletrônico',
      'location': 'Av. Paulista, São Paulo',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'isRecovered': false,
    },
    {
      'title': 'Bicicleta Mountain Bike Caloi',
      'type': 'Veículo',
      'location': 'Parque Ibirapuera, São Paulo',
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'isRecovered': true,
    },
    {
      'title': 'Notebook Dell Inspiron',
      'type': 'Eletrônico',
      'location': 'Shopping Morumbi, São Paulo',
      'date': DateTime.now().subtract(const Duration(days: 7)),
      'isRecovered': false,
    },
    {
      'title': 'Carteira de Couro',
      'type': 'Acessório',
      'location': 'Metrô Sé, São Paulo',
      'date': DateTime.now().subtract(const Duration(days: 10)),
      'isRecovered': false,
    },
    {
      'title': 'Relógio Apple Watch',
      'type': 'Eletrônico',
      'location': 'Academia Smart Fit, São Paulo',
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'isRecovered': true,
    },
    {
      'title': 'Mochila North Face',
      'type': 'Acessório',
      'location': 'Terminal Tietê, São Paulo',
      'date': DateTime.now().subtract(const Duration(days: 15)),
      'isRecovered': false,
    },
  ];

  List<Map<String, dynamic>> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = _allItems;
    _searchController.addListener(_filterItems);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterItems);
    _searchController.dispose();
    super.dispose();
  }

  void _filterItems() {
    setState(() {
      final query = _searchController.text.toLowerCase();
      _filteredItems = _allItems.where((item) {
        final matchesQuery = item['title'].toString().toLowerCase().contains(query) ||
            item['type'].toString().toLowerCase().contains(query) ||
            item['location'].toString().toLowerCase().contains(query);
        
        final matchesFilter = _selectedFilter == 'all' ||
            (_selectedFilter == 'recovered' && item['isRecovered'] == true) ||
            (_selectedFilter == 'not_recovered' && item['isRecovered'] == false);
        
        return matchesQuery && matchesFilter;
      }).toList();
    });
  }

  void _applyFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
      _filterItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Objetos Roubados',
      ),
      body: Column(
        children: [
          // Barra de pesquisa
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Pesquisar objetos...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          
          // Filtros
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Text('Filtrar por:'),
                const SizedBox(width: 8),
                _buildFilterChip('Todos', 'all'),
                const SizedBox(width: 8),
                _buildFilterChip('Recuperados', 'recovered'),
                const SizedBox(width: 8),
                _buildFilterChip('Não Recuperados', 'not_recovered'),
              ],
            ),
          ),
          
          // Lista de itens
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredItems.isEmpty
                    ? const Center(
                        child: Text('Nenhum objeto encontrado'),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: _filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = _filteredItems[index];
                          return ItemCard(
                            title: item['title'] as String,
                            type: item['type'] as String,
                            location: item['location'] as String,
                            date: item['date'] as DateTime,
                            isRecovered: item['isRecovered'] as bool,
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                '/items/detail',
                                arguments: item,
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        _applyFilter(value);
      },
      backgroundColor: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : null,
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
      checkmarkColor: Theme.of(context).primaryColor,
    );
  }
}
