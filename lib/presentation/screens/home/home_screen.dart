import 'package:flutter/material.dart';
import 'package:stolen_items_app/presentation/widgets/common/app_bar.dart';
import 'package:stolen_items_app/config/routes/routes.dart';
import 'package:stolen_items_app/presentation/widgets/items/item_card.dart';

/// Tela principal do aplicativo
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Lista de telas para o bottom navigation
  final List<Widget> _screens = [
    const _DashboardTab(),
    const _MyItemsTab(),
    const _ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 40,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
            const Text('RastreIA'),
          ],
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.settings);
            },
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Meus Itens',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.itemForm);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// Tab de Dashboard
class _DashboardTab extends StatelessWidget {
  const _DashboardTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Estatísticas
          _buildStatisticsSection(context),
          const SizedBox(height: 24),
          
          // Últimos itens registrados
          _buildRecentItemsSection(context),
        ],
      ),
    );
  }

  Widget _buildStatisticsSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estatísticas',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    Icons.report_problem,
                    '125',
                    'Itens Registrados',
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    context,
                    Icons.check_circle,
                    '42',
                    'Itens Recuperados',
                    Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    IconData icon,
    String count,
    String label,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            count,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentItemsSection(BuildContext context) {
    // Dados de exemplo
    final recentItems = [
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
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Itens Recentes',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.itemList);
              },
              child: const Text('Ver Todos'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: recentItems.length,
          itemBuilder: (context, index) {
            final item = recentItems[index];
            return ItemCard(
              title: item['title'] as String,
              type: item['type'] as String,
              location: item['location'] as String,
              date: item['date'] as DateTime,
              isRecovered: item['isRecovered'] as bool,
              onTap: () {
                Navigator.of(context).pushNamed(AppRoutes.itemDetail);
              },
            );
          },
        ),
      ],
    );
  }
}

/// Tab de Meus Itens
class _MyItemsTab extends StatelessWidget {
  const _MyItemsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dados de exemplo
    final myItems = [
      {
        'title': 'Smartphone Samsung Galaxy S21',
        'type': 'Eletrônico',
        'location': 'Av. Zequinha Freire, Teresina-PI',
        'date': DateTime.now().subtract(const Duration(days: 2)),
        'isRecovered': false,
      },
      {
        'title': 'Bicicleta Mountain Bike Caloi',
        'type': 'Veículo',
        'location': 'J4, Teresina-PI',
        'date': DateTime.now().subtract(const Duration(days: 5)),
        'isRecovered': true,
      },
      {
        'title': 'Notebook Dell Inspiron',
        'type': 'Eletrônico',
        'location': 'Teresina Shopping, Teresina-PI',
        'date': DateTime.now().subtract(const Duration(days: 7)),
        'isRecovered': false,
      },
      {
        'title': 'Carteira de Couro',
        'type': 'Acessório',
        'location': 'Vale Quem Tem, Teresina-PI',
        'date': DateTime.now().subtract(const Duration(days: 10)),
        'isRecovered': false,
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Meus Itens Registrados',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: myItems.length,
              itemBuilder: (context, index) {
                final item = myItems[index];
                return ItemCard(
                  title: item['title'] as String,
                  type: item['type'] as String,
                  location: item['location'] as String,
                  date: item['date'] as DateTime,
                  isRecovered: item['isRecovered'] as bool,
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRoutes.itemDetail);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Tab de Perfil
class _ProfileTab extends StatelessWidget {
  const _ProfileTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text(
            'João Silva',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(
            'joao.silva@exemplo.com',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            'Cidadão',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 32),
          _buildProfileMenuItem(
            context,
            Icons.edit,
            'Editar Perfil',
            () {},
          ),
          _buildProfileMenuItem(
            context,
            Icons.notifications,
            'Notificações',
            () {},
          ),
          _buildProfileMenuItem(
            context,
            Icons.security,
            'Segurança',
            () {},
          ),
          _buildProfileMenuItem(
            context,
            Icons.help,
            'Ajuda e Suporte',
            () {},
          ),
          _buildProfileMenuItem(
            context,
            Icons.exit_to_app,
            'Sair',
            () {
              Navigator.of(context).pushReplacementNamed(AppRoutes.login);
            },
            isLogout: true,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isLogout = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isLogout ? Colors.red : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isLogout ? Colors.red : null,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
