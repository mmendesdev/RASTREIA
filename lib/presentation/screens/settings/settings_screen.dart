import 'package:flutter/material.dart';
import 'package:stolen_items_app/presentation/widgets/common/app_bar.dart';

/// Tela de configurações do aplicativo
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _locationEnabled = true;
  String _syncFrequency = 'auto';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Configurações',
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Seção de Conta
          _buildSectionHeader(context, 'Conta'),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Perfil'),
            subtitle: const Text('Editar informações pessoais'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Implementação futura: navegação para tela de perfil
            },
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Segurança'),
            subtitle: const Text('Alterar senha e configurações de segurança'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Implementação futura: navegação para tela de segurança
            },
          ),
          const Divider(),

          // Seção de Notificações
          _buildSectionHeader(context, 'Notificações'),
          SwitchListTile(
            title: const Text('Notificações'),
            subtitle: const Text('Receber alertas sobre objetos'),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          const Divider(),

          // Seção de Aparência
          _buildSectionHeader(context, 'Aparência'),
          SwitchListTile(
            title: const Text('Modo Escuro'),
            subtitle: const Text('Alterar tema do aplicativo'),
            value: _darkModeEnabled,
            onChanged: (value) {
              setState(() {
                _darkModeEnabled = value;
              });
            },
          ),
          const Divider(),

          // Seção de Privacidade
          _buildSectionHeader(context, 'Privacidade'),
          SwitchListTile(
            title: const Text('Localização'),
            subtitle: const Text('Permitir acesso à localização'),
            value: _locationEnabled,
            onChanged: (value) {
              setState(() {
                _locationEnabled = value;
              });
            },
          ),
          const Divider(),

          // Seção de Sincronização
          _buildSectionHeader(context, 'Sincronização'),
          ListTile(
            title: const Text('Frequência de Sincronização'),
            subtitle: Text(_getSyncFrequencyText()),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              _showSyncFrequencyDialog();
            },
          ),
          ListTile(
            leading: const Icon(Icons.sync),
            title: const Text('Sincronizar Agora'),
            onTap: () {
              _syncData();
            },
          ),
          const Divider(),

          // Seção de Sobre
          _buildSectionHeader(context, 'Sobre'),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Sobre o Aplicativo'),
            subtitle: const Text('Versão 1.0.0'),
            onTap: () {
              // Implementação futura: exibir informações sobre o app
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Ajuda e Suporte'),
            onTap: () {
              // Implementação futura: navegação para tela de ajuda
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  String _getSyncFrequencyText() {
    switch (_syncFrequency) {
      case 'auto':
        return 'Automática';
      case 'hourly':
        return 'A cada hora';
      case 'daily':
        return 'Diária';
      case 'manual':
        return 'Manual';
      default:
        return 'Automática';
    }
  }

  void _showSyncFrequencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Frequência de Sincronização'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildRadioOption('Automática', 'auto'),
            _buildRadioOption('A cada hora', 'hourly'),
            _buildRadioOption('Diária', 'daily'),
            _buildRadioOption('Manual', 'manual'),
          ],
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
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOption(String label, String value) {
    return RadioListTile<String>(
      title: Text(label),
      value: value,
      groupValue: _syncFrequency,
      onChanged: (newValue) {
        setState(() {
          _syncFrequency = newValue!;
          Navigator.of(context).pop();
        });
      },
    );
  }

  void _syncData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sincronizando dados...'),
        duration: Duration(seconds: 2),
      ),
    );
    
    // Simulação de sincronização
    Future.delayed(const Duration(seconds: 2), () {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dados sincronizados com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }
}
