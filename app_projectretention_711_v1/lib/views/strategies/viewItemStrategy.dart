import 'package:app_projectretention_711_v1/main.dart';
import 'package:flutter/material.dart';
import 'package:app_projectretention_711_v1/api/apiRetention.dart'; // Importa tu API

viewItemStrategy(context, itemList) async {
  // Cargar categorías si no están disponibles en memoria
  if (myReactController.getListCategories.isEmpty) {
    await fetchAPICategories();
  }

  // Función para obtener el nombre de la categoría basado en el fkIdCategories
  String getCategoryName(int? fkIdCategories) {
    if (fkIdCategories == null) return 'No disponible';

    final category = myReactController.getListCategories.firstWhere(
      (cat) => cat['id'] == fkIdCategories,
      orElse: () => {'name': 'Categoría no encontrada'},
    );

    return category['name'] ?? 'Categoría no encontrada';
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
              Color.fromARGB(255, 7, 25, 83), // Azul oscuro
              Color.fromARGB(255, 23, 214, 214), // Azul celeste
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
              'Detalle de la Estrategia',
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
                    icon: Icons.lightbulb,
                    title: 'Estrategia',
                    value: itemList['strategy'] ?? 'No disponible',
                    color: Colors.teal,
                  ),
                  _buildDetailCard(
                    icon: Icons.category,
                    title: 'Categoría',
                    value: getCategoryName(itemList['fkIdCategories']),
                    color: Colors.indigo,
                  ),
                  _buildDetailCard(
                    icon: Icons.label,
                    title: 'Nombre de la Categoría',
                    value: itemList['category']?['name'] ?? 'No disponible',
                    color: Colors.deepPurple,
                  ),
                  _buildDetailCard(
                    icon: Icons.description,
                    title: 'Descripción de la Categoría',
                    value:
                        itemList['category']?['description'] ?? 'No disponible',
                    color: Colors.orangeAccent,
                  ),
                  _buildDetailCard(
                    icon: Icons.account_circle,
                    title: 'Responsable',
                    value:
                        itemList['category']?['addressing'] ?? 'No disponible',
                    color: Colors.green,
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

// 🔹 Widget reutilizable con colores personalizados
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
