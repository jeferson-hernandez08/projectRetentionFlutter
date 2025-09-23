import 'package:app_projectretention_711_v1/main.dart';
import 'package:flutter/material.dart';
import 'package:app_projectretention_711_v1/api/apiRetention.dart'; // Importa tu API

viewItemCategory(context, itemList) async {
  // Cargar categorías si no están disponibles (se mantiene la estructura aunque no sea necesario)
  if (myReactController.getListCategories.isEmpty) {
    await fetchAPICategories();
  }

  // Función para formatear texto largo (similar a la función original pero adaptada)
  String formatText(String? text) {
    if (text == null || text.isEmpty) return 'No disponible';
    return text;
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Detalle de la Categoría'),
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
              leading: Icon(Icons.category),
              title: Text('Nombre'),
              subtitle: Text(formatText(itemList['name'])),
            ),
            Divider(),

            ListTile(
              leading: Icon(Icons.description),
              title: Text('Descripción'),
              subtitle: Text(formatText(itemList['description'])),
            ),
            Divider(),

            ListTile(
              leading: Icon(Icons.directions),
              title: Text('Direccionamiento'),
              subtitle: Text(formatText(itemList['addressing'])),
            ),
            Divider(),

            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('Fecha de Creación'),
              subtitle: Text(itemList['createdAt'] != null 
                  ? DateTime.parse(itemList['createdAt']).toString().split(' ')[0]
                  : 'No disponible'),
            ),
            Divider(),

            ListTile(
              leading: Icon(Icons.update),
              title: Text('Fecha de Actualización'),
              subtitle: Text(itemList['updatedAt'] != null 
                  ? DateTime.parse(itemList['updatedAt']).toString().split(' ')[0]
                  : 'No disponible'),
            ),
            Divider(),
          ],
        ),
      );
    },
  );
}