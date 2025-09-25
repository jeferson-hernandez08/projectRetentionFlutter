import 'package:app_projectretention_711_v1/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 👈 Para formatear fechas

viewItemIntervention(context, itemList) async {
  // Formateador de fecha + hora
  String formatDateTime(String? date) {
    if (date == null) return 'No disponible';
    try {
      final parsedDate = DateTime.parse(date);
      // 👇 Formato con fecha + hora completa
      return DateFormat('dd/MM/yyyy HH:mm:ss').format(parsedDate);
    } catch (e) {
      return 'Formato inválido';
    }
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Detalle de la Intervención'),
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
        body: ListView(
          children: [
            // ID de la intervención
            ListTile(
              leading: const Icon(Icons.key),
              title: const Text('ID'),
              subtitle: Text(itemList['id'].toString()),
            ),
            const Divider(),

            // Fecha de creación con hora
            ListTile(
              leading: const Icon(Icons.date_range),
              title: const Text('Fecha de Creación'),
              subtitle: Text(formatDateTime(itemList['creationDate'])),
            ),
            const Divider(),

            // Descripción
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text('Descripción'),
              subtitle: Text(itemList['description'] ?? 'No disponible'),
            ),
            const Divider(),

            // Estrategia asociada
            ListTile(
              leading: const Icon(Icons.lightbulb),
              title: const Text('Estrategia'),
              subtitle: Text(itemList['strategy']?['strategy'] ?? 'No disponible'),
            ),
            const Divider(),

            // Categoría de la estrategia
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text('Categoría de Estrategia'),
              subtitle: Text(itemList['strategy']?['category']?['name'] ?? 'No disponible'),
            ),
            const Divider(),

            // Reporte asociado
            ListTile(
              leading: const Icon(Icons.assignment),
              title: const Text('Reporte Asociado'),
              subtitle: Text(itemList['report']?['description'] ?? 'No disponible'),
            ),
            const Divider(),

            // Estado del reporte
            ListTile(
              leading: const Icon(Icons.flag),
              title: const Text('Estado del Reporte'),
              subtitle: Text(itemList['report']?['state'] ?? 'No disponible'),
            ),
            const Divider(),

            // Aprendiz asociado al reporte
            ListTile(
              leading: const Icon(Icons.school),
              title: const Text('Aprendiz'),
              subtitle: Text(
                "${itemList['report']?['apprentice']?['firtsName'] ?? ''} "
                "${itemList['report']?['apprentice']?['lastName'] ?? ''}".trim().isNotEmpty
                    ? "${itemList['report']?['apprentice']?['firtsName'] ?? ''} ${itemList['report']?['apprentice']?['lastName'] ?? ''}"
                    : 'No disponible',
              ),
            ),
            const Divider(),

            // Usuario que realizó la intervención
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Usuario Responsable'),
              subtitle: Text(
                "${itemList['user']?['firstName'] ?? ''} ${itemList['user']?['lastName'] ?? ''}".trim().isNotEmpty
                    ? "${itemList['user']?['firstName'] ?? ''} ${itemList['user']?['lastName'] ?? ''}"
                    : 'No disponible',
              ),
            ),
            const Divider(),

            // Documento del usuario
            ListTile(
              leading: const Icon(Icons.badge),
              title: const Text('Documento del Usuario'),
              subtitle: Text(itemList['user']?['document'] ?? 'No disponible'),
            ),
            const Divider(),

            // Rol del usuario
            ListTile(
              leading: const Icon(Icons.security),
              title: const Text('Rol del Usuario'),
              subtitle: Text(itemList['user']?['rol']?['name'] ?? 'No disponible'),
            ),
            const Divider(),

            // Email del usuario
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Email del Usuario'),
              subtitle: Text(itemList['user']?['email'] ?? 'No disponible'),
            ),
            const Divider(),
          ],
        ),
      );
    },
  );
}
