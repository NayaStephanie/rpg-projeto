import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'edit_inventory_firestore_screen.dart';

class FirestoreInventoriesListScreen extends StatelessWidget {
  const FirestoreInventoriesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Inventário (Nuvem)')),
        body: const Center(child: Text('Usuário não autenticado')),
      );
    }

    final stream = FirebaseFirestore.instance
        .collection('usuarios')
        .doc(user.uid)
        .collection('inventories')
        .orderBy('createdAt', descending: true)
        .snapshots();

    return Scaffold(
      appBar: AppBar(title: const Text('Inventário (Nuvem)')),
      body: StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Erro ao recuperar dados: ${snapshot.error}'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const FirestoreInventoriesListScreen()),
                      );
                    },
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(child: Text('Nenhum item de inventário na nuvem'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(data['itemName'] ?? 'Sem nome'),
                subtitle: Text('Qtd: ${data['quantity'] ?? ''} • Raridade: ${data['rarity'] ?? ''}'),
                onTap: () {
                  // Abrir tela de edição/detalhe do item (reaproveita EditInventoryFirestoreScreen)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditInventoryFirestoreScreen(docId: doc.id, initialData: data),
                    ),
                  );
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditInventoryFirestoreScreen(
                              docId: doc.id,
                              initialData: data,
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Confirmar deleção'),
                            content: const Text('Excluir este item da nuvem?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
                              TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Excluir')),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          try {
                            await FirebaseFirestore.instance
                                .collection('usuarios')
                                .doc(user.uid)
                                .collection('inventories')
                                .doc(doc.id)
                                .delete();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Item removido')));
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao remover: $e')));
                            }
                          }
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
