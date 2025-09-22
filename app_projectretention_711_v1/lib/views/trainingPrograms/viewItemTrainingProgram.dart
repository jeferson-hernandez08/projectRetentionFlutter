import 'package:app_projectretention_711_v1/main.dart';
import 'package:flutter/material.dart';
import 'package:app_projectretention_711_v1/api/apiRetention.dart'; // Importa tu API

viewItemTrainingProgram(context, itemList) async {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Detalle del Programa de Formación'),
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
              leading: Icon(Icons.school),
              title: Text('Nombre'),
              subtitle: Text(itemList['name'] ?? 'No disponible'),
            ),
            Divider(),

            ListTile(
              leading: Icon(Icons.bar_chart),
              title: Text('Nivel'),
              subtitle: Text(itemList['level'] ?? 'No disponible'),
            ),
            Divider(),

            ListTile(
              leading: Icon(Icons.code),
              title: Text('Versión'),
              subtitle: Text(itemList['version'] ?? 'No disponible'),
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