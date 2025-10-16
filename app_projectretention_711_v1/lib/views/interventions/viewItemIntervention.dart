import 'package:app_projectretention_711_v1/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

viewItemIntervention(context, itemList) async {
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

                  // 🔹 Información básica de la intervención
                  _buildSectionTitle('Información de la Intervención'),

                  _buildDetailCard(
                    icon: Icons.key,
                    title: 'ID',
                    value: '#${itemList['id'].toString()}',
                    color: Colors.blueAccent,
                  ),
                  _buildDetailCard(
                    icon: Icons.calendar_today,
                    title: 'Fecha de Creación',
                    value: formatDateTime(itemList['creationDate']),
                    color: Colors.deepOrange,
                  ),
                  _buildDetailCard(
                    icon: Icons.description,
                    title: 'Descripción',
                    value: itemList['description'] ?? 'No disponible',
                    color: Colors.purple,
                  ),
                  _buildDetailCard(
                    icon: Icons.lightbulb,
                    title: 'Estrategia',
                    value: itemList['strategy']?['strategy'] ?? 'No disponible',
                    color: Colors.teal,
                  ),
                  _buildDetailCard(
                    icon: Icons.category,
                    title: 'Categoría de Estrategia',
                    value: itemList['strategy']?['category']?['name'] ?? 'No disponible',
                    color: Colors.orangeAccent,
                  ),

                  const SizedBox(height: 20),

                  // 🔹 Información del Reporte Asociado
                  Row(
                    children: const [
                      Icon(Icons.assignment, color: Colors.green),
                      SizedBox(width: 8),
                      Text(
                        'Reporte Asociado',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  _buildGroupedCard(
                    backgroundColor: Colors.green[50]!,
                    items: [
                      _GroupedCardItem(
                        icon: Icons.description,
                        title: 'Descripción del Reporte',
                        value: itemList['report']?['description'] ?? 'No disponible',
                        color: Colors.blue,
                      ),
                      _GroupedCardItem(
                        icon: Icons.flag,
                        title: 'Estado del Reporte',
                        value: itemList['report']?['state'] ?? 'No disponible',
                        color: Colors.redAccent,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 🔹 Información del Aprendiz
                  Row(
                    children: const [
                      Icon(Icons.school, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        'Información del Aprendiz',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  _buildGroupedCard(
                    backgroundColor: Colors.blue[50]!,
                    items: [
                      _GroupedCardItem(
                        icon: Icons.person,
                        title: 'Nombre',
                        value:
                            "${itemList['report']?['apprentice']?['firtsName'] ?? ''} ${itemList['report']?['apprentice']?['lastName'] ?? ''}"
                                    .trim()
                                    .isNotEmpty
                                ? "${itemList['report']?['apprentice']?['firtsName'] ?? ''} ${itemList['report']?['apprentice']?['lastName'] ?? ''}"
                                : 'No disponible',
                        color: Colors.deepPurple,
                      ),
                      _GroupedCardItem(
                        icon: Icons.credit_card,
                        title: 'Documento',
                        value: itemList['report']?['apprentice']?['document'] ?? 'No disponible',
                        color: Colors.indigo,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 🔹 Información del Usuario Responsable
                  Row(
                    children: const [
                      Icon(Icons.person, color: Colors.deepPurple),
                      SizedBox(width: 8),
                      Text(
                        'Usuario Responsable',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                  _buildGroupedCard(
                    backgroundColor: Colors.purple[50]!,
                    items: [
                      _GroupedCardItem(
                        icon: Icons.person,
                        title: 'Nombre',
                        value:
                            "${itemList['user']?['firstName'] ?? ''} ${itemList['user']?['lastName'] ?? ''}"
                                    .trim()
                                    .isNotEmpty
                                ? "${itemList['user']?['firstName'] ?? ''} ${itemList['user']?['lastName'] ?? ''}"
                                : 'No disponible',
                        color: Colors.purple,
                      ),
                      _GroupedCardItem(
                        icon: Icons.badge,
                        title: 'Documento',
                        value: itemList['user']?['document'] ?? 'No disponible',
                        color: Colors.orange,
                      ),
                      _GroupedCardItem(
                        icon: Icons.security,
                        title: 'Rol',
                        value: itemList['user']?['rol']?['name'] ?? 'No disponible',
                        color: Colors.teal,
                      ),
                      _GroupedCardItem(
                        icon: Icons.email,
                        title: 'Email',
                        value: itemList['user']?['email'] ?? 'No disponible',
                        color: Colors.redAccent,
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

// 🔹 Reutilizado del ejemplo anterior
class _GroupedCardItem {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  _GroupedCardItem({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });
}

Widget _buildGroupedCard({
  required Color backgroundColor,
  required List<_GroupedCardItem> items,
}) {
  return Card(
    elevation: 2,
    margin: const EdgeInsets.symmetric(vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    color: backgroundColor,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: item.color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Icon(item.icon, color: item.color, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.title,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: item.color)),
                        const SizedBox(height: 6),
                        Text(
                          item.value,
                          style: const TextStyle(
                              fontSize: 15, color: Colors.black87),
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (index < items.length - 1) ...[
                const SizedBox(height: 12),
                Divider(color: Colors.grey[300], thickness: 1),
                const SizedBox(height: 12),
              ],
            ],
          );
        }).toList(),
      ),
    ),
  );
}

// 🔹 Tarjetas simples de detalle
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
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: color)),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

// 🔹 Título de sección
Widget _buildSectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color.fromARGB(255, 7, 25, 83),
      ),
    ),
  );
}
