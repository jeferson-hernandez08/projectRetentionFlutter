import 'package:app_projectretention_711_v1/main.dart';
import 'package:flutter/material.dart';
import 'package:app_projectretention_711_v1/api/apiRetention.dart'; // Importa tu API

viewItemCategory(context, itemList) async {
  // Cargar categorías si no están disponibles (se mantiene la estructura aunque no sea necesario)
  if (myReactController.getListCategories.isEmpty) {
    await fetchAPICategories();
  }

  // Función para formatear texto largo
  String formatText(String? text) {
    if (text == null || text.isEmpty) return 'No disponible';
    return text;
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
              'Detalle de la Categoría',
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
                    icon: Icons.category,
                    title: 'Nombre',
                    value: formatText(itemList['name']),
                    color: Colors.teal,
                  ),
                  _buildDetailCard(
                    icon: Icons.description,
                    title: 'Descripción',
                    value: formatText(itemList['description']),
                    color: Colors.deepPurple,
                    isLongText: true, // 🔹 Indicamos que puede ser texto largo
                  ),
                  _buildDetailCard(
                    icon: Icons.directions,
                    title: 'Direccionamiento',
                    value: formatText(itemList['addressing']),
                    color: Colors.orangeAccent,
                  ),
                  _buildDetailCard(
                    icon: Icons.calendar_today,
                    title: 'Fecha de Creación',
                    value: itemList['createdAt'] != null
                        ? DateTime.parse(itemList['createdAt'])
                            .toString()
                            .split(' ')[0]
                        : 'No disponible',
                    color: Colors.green,
                  ),
                  _buildDetailCard(
                    icon: Icons.update,
                    title: 'Fecha de Actualización',
                    value: itemList['updatedAt'] != null
                        ? DateTime.parse(itemList['updatedAt'])
                            .toString()
                            .split(' ')[0]
                        : 'No disponible',
                    color: Colors.redAccent,
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
  bool isLongText = false, // 🔹 Nuevo parámetro opcional
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
        crossAxisAlignment: CrossAxisAlignment.start, // 🔹 Cambiado para texto largo
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
                  softWrap: true,
                  overflow:
                      isLongText ? TextOverflow.visible : TextOverflow.ellipsis, // 🔹 Aquí el cambio
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
