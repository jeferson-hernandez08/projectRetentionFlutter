import 'package:app_projectretention_711_v1/main.dart';
import 'package:flutter/material.dart';
import 'package:app_projectretention_711_v1/api/apiRetention.dart'; // Importa tu API

viewItemApprentice(context, itemList) async {
  // Cargar grupos si no están disponibles
  if (myReactController.getListGroups.isEmpty) {
    await fetchAPIGroups();
  }

  // Función para obtener el nombre del grupo basado en el fkIdGroups
  String getGroupName(int? fkIdGroups) {
    if (fkIdGroups == null) return 'No disponible';
    
    // Buscar el grupo en la lista de grupos del controlador
    final group = myReactController.getListGroups.firstWhere(
      (group) => group['id'] == fkIdGroups,
      orElse: () => {'file': 'Grupo no encontrado'},
    );
    
    return group['file'] ?? 'Grupo no encontrado';
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Detalle del Aprendiz'),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        body: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.key),
              title: Text('ID'),
              subtitle: Text(itemList['id'].toString()),
            ),
            Divider(),

            ListTile(
              leading: Icon(Icons.badge),
              title: Text('Tipo de Documento'),
              subtitle: Text(itemList['documentType'] ?? 'No disponible'),
            ),
            Divider(),

            ListTile(
              leading: Icon(Icons.credit_card),
              title: Text('Documento'),
              subtitle: Text(itemList['document'] ?? 'No disponible'),
            ),
            Divider(),

            ListTile(
              leading: Icon(Icons.person),
              title: Text('Nombre'),
              subtitle: Text(itemList['firtsName'] ?? 'No disponible'),
            ),
            Divider(),

            ListTile(
              leading: Icon(Icons.person_outline),
              title: Text('Apellido'),
              subtitle: Text(itemList['lastName'] ?? 'No disponible'),
            ),
            Divider(),

            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Teléfono'),
              subtitle: Text(itemList['phone'] ?? 'No disponible'),
            ),
            Divider(),

            ListTile(
              leading: Icon(Icons.email),
              title: Text('Email'),
              subtitle: Text(itemList['email'] ?? 'No disponible'),
            ),
            Divider(),

            ListTile(
              leading: Icon(Icons.school),
              title: Text('Estado'),
              subtitle: Text(itemList['status'] ?? 'No disponible'),
            ),
            Divider(),

            ListTile(
              leading: Icon(Icons.format_list_numbered),
              title: Text('Trimestre'),
              subtitle: Text(itemList['quarter'] ?? 'No disponible'),
            ),
            Divider(),

            ListTile(
              leading: Icon(Icons.group),
              title: Text('Grupo'),
              subtitle: Text(getGroupName(itemList['fkIdGroups'])),
            ),
            Divider(),

            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('Fecha de Creación'),
              subtitle: Text(itemList['createdAt']?.toString() ?? 'No disponible'),
            ),
            Divider(),

            ListTile(
              leading: Icon(Icons.update),
              title: Text('Fecha de Actualización'),
              subtitle: Text(itemList['updatedAt']?.toString() ?? 'No disponible'),
            ),
            Divider(),
          ],
        ),
      );
    },
  );
}