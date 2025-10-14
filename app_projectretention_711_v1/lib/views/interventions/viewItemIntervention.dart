import 'package:app_projectretention_711_v1/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 👈 Para formatear fechas

viewItemIntervention(context, itemList) async {
  // 🔹 Formateador de fecha + hora
  String formatDateTime(String? date) {
    if (date == null) return 'No disponible';
    try {
      final parsedDate = DateTime.parse(date);
      return DateFormat('dd/MM/yyyy HH:mm:ss').format(parsedDate);
    } catch (e) {
      return 'Formato inválido';
    }
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
              'Detalle de la Intervención',
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
                    icon: Icons.date_range,
                    title: 'Fecha de Creación',
                    value: formatDateTime(itemList['creationDate']),
                    color: Colors.teal,
                  ),
                  _buildDetailCard(
                    icon: Icons.description,
                    title: 'Descripción',
                    value: itemList['description'] ?? 'No disponible',
                    color: Colors.indigo,
                  ),
                  _buildDetailCard(
                    icon: Icons.lightbulb,
                    title: 'Estrategia',
                    value: itemList['strategy']?['strategy'] ?? 'No disponible',
                    color: Colors.deepPurple,
                  ),
                  _buildDetailCard(
                    icon: Icons.category,
                    title: 'Categoría de Estrategia',
                    value: itemList['strategy']?['category']?['name'] ??
                        'No disponible',
                    color: Colors.orangeAccent,
                  ),
                  _buildDetailCard(
                    icon: Icons.assignment,
                    title: 'Reporte Asociado',
                    value: itemList['report']?['description'] ?? 'No disponible',
                    color: Colors.green,
                  ),
                  _buildDetailCard(
                    icon: Icons.flag,
                    title: 'Estado del Reporte',
                    value: itemList['report']?['state'] ?? 'No disponible',
                    color: Colors.cyan,
                  ),
                  _buildDetailCard(
                    icon: Icons.school,
                    title: 'Aprendiz',
                    value: "${itemList['report']?['apprentice']?['firtsName'] ?? ''} "
                                "${itemList['report']?['apprentice']?['lastName'] ?? ''}"
                            .trim()
                            .isNotEmpty
                        ? "${itemList['report']?['apprentice']?['firtsName'] ?? ''} ${itemList['report']?['apprentice']?['lastName'] ?? ''}"
                        : 'No disponible',
                    color: Colors.pinkAccent,
                  ),
                  _buildDetailCard(
                    icon: Icons.person,
                    title: 'Usuario Responsable',
                    value:
                        "${itemList['user']?['firstName'] ?? ''} ${itemList['user']?['lastName'] ?? ''}"
                                .trim()
                                .isNotEmpty
                            ? "${itemList['user']?['firstName'] ?? ''} ${itemList['user']?['lastName'] ?? ''}"
                            : 'No disponible',
                    color: Colors.amber,
                  ),
                  _buildDetailCard(
                    icon: Icons.badge,
                    title: 'Documento del Usuario',
                    value: itemList['user']?['document'] ?? 'No disponible',
                    color: Colors.deepOrange,
                  ),
                  _buildDetailCard(
                    icon: Icons.security,
                    title: 'Rol del Usuario',
                    value: itemList['user']?['rol']?['name'] ?? 'No disponible',
                    color: Colors.lightGreen,
                  ),
                  _buildDetailCard(
                    icon: Icons.email,
                    title: 'Email del Usuario',
                    value: itemList['user']?['email'] ?? 'No disponible',
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
