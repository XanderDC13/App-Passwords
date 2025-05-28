import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:passwords/screens/addaccount.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  List<Map<String, dynamic>> _accounts = [];

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  Future<void> _loadAccounts() async {
    try {
      final response = await Supabase.instance.client
          .from('accounts')
          .select()
          .order(
            'created_at',
            ascending: false,
          ); // Ordenar por fecha de creación

      print('Cuentas cargadas: ${response.length}');

      if (mounted) {
        setState(() {
          _accounts = List<Map<String, dynamic>>.from(response);
        });
      }
    } catch (e) {
      print('Error al cargar cuentas: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al cargar cuentas: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authenticator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () async {
              final selected = await Navigator.pushNamed(context, '/filter');
              if (selected != null && mounted) {
                setState(() {
                  _searchController.text = selected.toString(); // aplica filtro
                });
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddPasswordScreen(),
                ),
              ).then((_) => _loadAccounts());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Buscar por servicio',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {}); // actualiza la búsqueda
              },
            ),
          ),
          Expanded(
            child:
                _accounts.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                      itemCount: _accounts.length,
                      itemBuilder: (context, index) {
                        final item = _accounts[index];
                        final icon = _getIconForService(item['service']);
                        final email = item['email'] ?? '';
                        final service = item['service'] ?? '';

                        if (_searchController.text.isNotEmpty &&
                            !service.toLowerCase().contains(
                              _searchController.text.toLowerCase(),
                            )) {
                          return const SizedBox.shrink();
                        }

                        return ListTile(
                          leading: Icon(icon),
                          title: Text(service),
                          subtitle: Text(email),
                          onTap:
                              () => Navigator.pushNamed(
                                context,
                                '/detail',
                                arguments: item,
                              ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForService(String? service) {
    switch (service?.toLowerCase()) {
      case 'facebook':
        return LucideIcons.facebook;
      case 'gmail':
        return LucideIcons.mail;
      case 'instagram':
        return LucideIcons.instagram;
      case 'twitter':
        return LucideIcons.twitter;
      default:
        return LucideIcons.shield;
    }
  }
}
