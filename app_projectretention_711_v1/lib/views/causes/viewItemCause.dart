import 'package:app_projectretention_711_v1/main.dart';
import 'package:flutter/material.dart';
import 'package:app_projectretention_711_v1/api/apiRetention.dart';

// Importa tu API
viewItemCause(context, itemList) async {
  // Cargar categorías si no están disponibles
  if (myReactController.getListCategories.isEmpty) {
    await fetchAPICategories();
  }

  // Función para obtener el nombre de la categoría basado en el fkIdCategories
  String getCategoryName(int? fkIdCategories) {
    if (fkIdCategories == null) return 'No disponible';

    // Buscar la categoría en la lista de categorías del controlador
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
              'Detalle de la Causa',
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

                  // Campo ID
                  _buildDetailCard(
                    icon: Icons.key,
                    title: 'ID',
                    value: itemList['id'].toString(),
                    color: Colors.blueAccent,
                  ),

                  // Campo Causa (texto completo)
                  _buildDetailCard(
                    icon: Icons.warning_amber_rounded,
                    title: 'Causa',
                    value: itemList['cause'] ?? 'No disponible',
                    color: Colors.orangeAccent,
                    showFullText: true,
                  ),

                  // Campo Variable (texto completo)
                  _buildDetailCard(
                    icon: Icons.scatter_plot_outlined,
                    title: 'Variable',
                    value: itemList['variable'] ?? 'No disponible',
                    color: Colors.deepPurple,
                    showFullText: true,
                  ),

                  // Campo Categoría
                  _buildDetailCard(
                    icon: Icons.layers,
                    title: 'Categoría',
                    value: itemList['category'] != null
                        ? itemList['category']['name'] ?? 'No disponible'
                        : getCategoryName(itemList['fkIdCategories']),
                    color: Colors.teal,
                  ),

                  // Campo Descripción Categoría (texto completo)
                  _buildDetailCard(
                    icon: Icons.description_outlined,
                    title: 'Descripción Categoría',
                    value: itemList['category'] != null
                        ? itemList['category']['description'] ?? 'No disponible'
                        : 'No disponible',
                    color: Colors.redAccent,
                    showFullText: true,
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

// 🔹 Widget reutilizable para cada campo de detalle con color personalizado
Widget _buildDetailCard({
  required IconData icon,
  required String title,
  required String value,
  required Color color,
  bool showFullText = false, // 👈 nueva opción para mostrar texto completo
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  softWrap: true, // 👈 permite saltos de línea
                  overflow:
                      showFullText ? TextOverflow.visible : TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
