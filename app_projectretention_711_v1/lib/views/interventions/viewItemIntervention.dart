import 'package:app_projectretention_711_v1/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatear fecha y hora
import 'package:app_projectretention_711_v1/api/apiRetention.dart'; // Importa tu API

viewItemIntervention(context, itemList) async {
  // Cargar estrategias, reportes y usuarios si no están disponibles
  if (myReactController.getListStrategies.isEmpty) {
    await fetchAPIStrategies();
  }
  if (myReactController.getListReports.isEmpty) {
    await fetchAPIReports();
  }
  if (myReactController.getListUsers.isEmpty) {
    await fetchAPIUsers();
  }

  // Función para formatear fecha con hora, minutos y segundos
  String formatDate(String? date) {
    if (date == null) return 'No disponible';
    try {
      final parsedDate = DateTime.parse(date);
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(parsedDate);
    } catch (e) {
      return 'Fecha inválida';
    }
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Detalle de la Intervención'),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        body: ListView(
          children: [
            // ID de la intervención
            ListTile(
              leading: Icon(Icons.key),
              title: Text('ID'),
              subtitle: Text(itemList['id'].toString()),
            ),
            Divider(),

            // Fecha de creación
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('Fecha de Creación'),
              subtitle: Text(formatDate(itemList['creationDate'])),
            ),
            Divider(),

            // Descripción
            ListTile(
              leading: Icon(Icons.description),
              title: Text('Descripción'),
              subtitle: Text(itemList['description'] ?? 'No disponible'),
            ),
            Divider(),

            // Estrategia asociada
            ListTile(
              leading: Icon(Icons.lightbulb),
              title: Text('Estrategia'),
              subtitle: Text(itemList['strategy']?['strategy'] ?? 'No disponible'),
            ),
            Divider(),

            // Categoría de la estrategia
            ListTile(
              leading: Icon(Icons.category),
              title: Text('Categoría de Estrategia'),
              subtitle: Text(itemList['strategy']?['category']?['name'] ?? 'No disponible'),
            ),
            Divider(),

            // Reporte asociado
            ListTile(
              leading: Icon(Icons.report),
              title: Text('Reporte Asociado'),
              subtitle: Text(itemList['report']?['description'] ?? 'No disponible'),
            ),
            Divider(),

            // Estado del reporte
            ListTile(
              leading: Icon(Icons.flag),
              title: Text('Estado del Reporte'),
              subtitle: Text(itemList['report']?['state'] ?? 'No disponible'),
            ),
            Divider(),

            // Aprendiz del reporte
            ListTile(
              leading: Icon(Icons.school),
              title: Text('Aprendiz del Reporte'),
              subtitle: Text(
                "${itemList['report']?['apprentice']?['firtsName'] ?? 'Nombre'} "
                "${itemList['report']?['apprentice']?['lastName'] ?? 'Apellido'}",
              ),
            ),
            Divider(),

            // Usuario que registró la intervención
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Usuario que Registró'),
              subtitle: Text(
                "${itemList['user']?['firstName'] ?? 'Nombre'} "
                "${itemList['user']?['lastName'] ?? 'Apellido'}",
              ),
            ),
            Divider(),

            // Rol del usuario
            ListTile(
              leading: Icon(Icons.security),
              title: Text('Rol del Usuario'),
              subtitle: Text(itemList['user']?['rol']?['name'] ?? 'No disponible'),
            ),
            Divider(),
          ],
        ),
      );
    },
  );
}
