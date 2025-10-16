import 'package:app_projectretention_711_v1/main.dart';
import 'package:flutter/material.dart';
import 'package:app_projectretention_711_v1/api/apiRetention.dart';

viewItemApprentice(context, itemList) async {
  if (myReactController.getListGroups.isEmpty) {
    await fetchAPIGroups();
  }

  String getGroupName(int? fkIdGroups) {
    if (fkIdGroups == null) return 'No disponible';
    final group = myReactController.getListGroups.firstWhere(
      (group) => group['id'] == fkIdGroups,
      orElse: () => {'file': 'Grupo no encontrado'},
    );
    return group['file'] ?? 'Grupo no encontrado';
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 7, 25, 83),
              Color.fromARGB(255, 23, 214, 214),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: const Text(
              'Detalle del Aprendiz',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
          ),
          body: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  const SizedBox(height: 10),

                  _buildDetailCard(
                    icon: Icons.key,
                    title: 'ID',
                    value: itemList['id'].toString(),
                    color: Colors.blueAccent,
                  ),
                  _buildDetailCard(
                    icon: Icons.badge,
                    title: 'Tipo de Documento',
                    value: itemList['documentType'] ?? 'No disponible',
                    color: Colors.teal,
                  ),
                  _buildDetailCard(
                    icon: Icons.credit_card,
                    title: 'Documento',
                    value: itemList['document'] ?? 'No disponible',
                    color: Colors.indigo,
                  ),
                  _buildDetailCard(
                    icon: Icons.person,
                    title: 'Nombre',
                    value: itemList['firtsName'] ?? 'No disponible',
                    color: Colors.deepPurple,
                  ),
                  _buildDetailCard(
                    icon: Icons.person_outline,
                    title: 'Apellido',
                    value: itemList['lastName'] ?? 'No disponible',
                    color: Colors.orangeAccent,
                  ),
                  _buildDetailCard(
                    icon: Icons.phone,
                    title: 'Teléfono',
                    value: itemList['phone'] ?? 'No disponible',
                    color: Colors.green,
                  ),
                  _buildDetailCard(
                    icon: Icons.email,
                    title: 'Email',
                    value: itemList['email'] ?? 'No disponible',
                    color: Colors.redAccent,
                  ),
                  _buildDetailCard(
                    icon: Icons.school,
                    title: 'Estado',
                    value: itemList['status'] ?? 'No disponible',
                    color: Colors.cyan,
                  ),
                  _buildDetailCard(
                    icon: Icons.format_list_numbered,
                    title: 'Trimestre',
                    value: itemList['quarter'] ?? 'No disponible',
                    color: Colors.pinkAccent,
                  ),
                  _buildDetailCard(
                    icon: Icons.group,
                    title: 'Grupo',
                    value: getGroupName(itemList['fkIdGroups']),
                    color: Colors.amber,
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

// 🔹 Widget para cada tarjeta de detalle con color personalizado
Widget _buildDetailCard({
  required IconData icon,
  required String title,
  required String value,
  required Color color,
}) {
  return Card(
    elevation: 2,
    margin: const EdgeInsets.symmetric(vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(10),
            child: Icon(
              icon,
              color: color,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
