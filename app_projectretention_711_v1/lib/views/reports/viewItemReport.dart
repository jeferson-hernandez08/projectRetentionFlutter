import 'package:flutter/material.dart';
import 'package:app_projectretention_711_v1/main.dart';
import 'package:app_projectretention_711_v1/api/apiRetention.dart'; // Importa tu API

viewItemReport(context, itemList) async {
  // Cargar listas si no están disponibles (si es necesario, por ejemplo aprendices o usuarios)
  if (myReactController.getListApprentices.isEmpty) {
    await fetchAPIApprentices();
  }
  if (myReactController.getListUsers.isEmpty) {
    await fetchAPIUsers();
  }

  // Función para obtener el nombre completo del aprendiz basado en fkIdApprentices
  String getApprenticeName(int? fkIdApprentices) {
    if (fkIdApprentices == null) return 'No disponible';

    final apprentice = myReactController.getListApprentices.firstWhere(
      (apprentice) => apprentice['id'] == fkIdApprentices,
      orElse: () => {'firtsName': 'Aprendiz', 'lastName': 'no encontrado'},
    );

    return '${apprentice['firtsName'] ?? ''} ${apprentice['lastName'] ?? ''}'.trim();
  }

  // Función para obtener el nombre completo del usuario basado en fkIdUsers
  String getUserName(int? fkIdUsers) {
    if (fkIdUsers == null) return 'No disponible';

    final user = myReactController.getListUsers.firstWhere(
      (user) => user['id'] == fkIdUsers,
      orElse: () => {'firstName': 'Usuario', 'lastName': 'no encontrado'},
    );

    return '${user['firstName'] ?? ''} ${user['lastName'] ?? ''}'.trim();
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Detalle del Reporte'),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        body: ListView(
          children: [
            // ID del Reporte
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
              subtitle: Text(itemList['creationDate'] ?? 'No disponible'),
            ),
            Divider(),

            // Descripción
            ListTile(
              leading: Icon(Icons.description),
              title: Text('Descripción'),
              subtitle: Text(itemList['description'] ?? 'No disponible'),
            ),
            Divider(),

            // Direccionamiento (Coordinador Académico o Coordinador de Formación)
            ListTile(
              leading: Icon(Icons.account_tree),
              title: Text('Direccionamiento'),
              subtitle: Text(itemList['addressing'] ?? 'No disponible'),
            ),
            Divider(),

            // Estado (Registrado, En proceso, Retenido, Desertado)
            ListTile(
              leading: Icon(Icons.flag),
              title: Text('Estado'),
              subtitle: Text(itemList['state'] ?? 'No disponible'),
            ),
            Divider(),

            // Aprendiz relacionado
            ListTile(
              leading: Icon(Icons.school),
              title: Text('Aprendiz'),
              subtitle: Text(getApprenticeName(itemList['fkIdApprentices'])),
            ),
            Divider(),

            // Documento del Aprendiz
            ListTile(
              leading: Icon(Icons.badge),
              title: Text('Documento Aprendiz'),
              subtitle: Text(itemList['apprentice']?['document'] ?? 'No disponible'),
            ),
            Divider(),

            // Usuario que creó el reporte
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Usuario Responsable'),
              subtitle: Text(getUserName(itemList['fkIdUsers'])),
            ),
            Divider(),

            // Documento del Usuario
            ListTile(
              leading: Icon(Icons.credit_card),
              title: Text('Documento Usuario'),
              subtitle: Text(itemList['user']?['document'] ?? 'No disponible'),
            ),
            Divider(),
          ],
        ),
      );
    },
  );
}
