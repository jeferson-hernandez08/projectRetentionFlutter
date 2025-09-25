import 'package:app_projectretention_711_v1/main.dart';
import 'package:flutter/material.dart';
import 'package:app_projectretention_711_v1/api/apiRetention.dart'; // Importa tu API

viewItemStrategy(context, itemList) async {
  // Cargar categorías si no están disponibles en memoria
  if (myReactController.getListCategories.isEmpty) {
    await fetchAPICategories();
  }

  // Función para obtener el nombre de la categoría basado en el fkIdCategories
  String getCategoryName(int? fkIdCategories) {
    if (fkIdCategories == null) return 'No disponible';

    final category = myReactController.getListCategories.firstWhere(
      (cat) => cat['id'] == fkIdCategories,
      orElse: () => {'name': 'Categoría no encontrada'},
    );

    return category['name'] ?? 'Categoría no encontrada';
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Detalle de la Estrategia'),
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
        body: ListView(
          children: [
            // ID de la estrategia
            ListTile(
              leading: Icon(Icons.key),
              title: Text('ID'),
              subtitle: Text(itemList['id'].toString()),
            ),
            Divider(),

            // Texto de la estrategia
            ListTile(
              leading: Icon(Icons.lightbulb),
              title: Text('Estrategia'),
              subtitle: Text(itemList['strategy'] ?? 'No disponible'),
            ),
            Divider(),

            // Categoría (FK)
            ListTile(
              leading: Icon(Icons.category),
              title: Text('Categoría'),
              subtitle: Text(getCategoryName(itemList['fkIdCategories'])),
            ),
            Divider(),

            // Nombre de la categoría (si viene expandida en el objeto)
            ListTile(
              leading: Icon(Icons.label),
              title: Text('Nombre de la Categoría'),
              subtitle: Text(itemList['category']?['name'] ?? 'No disponible'),
            ),
            Divider(),

            // Descripción de la categoría
            ListTile(
              leading: Icon(Icons.description),
              title: Text('Descripción de la Categoría'),
              subtitle: Text(itemList['category']?['description'] ?? 'No disponible'),
            ),
            Divider(),

            // Responsable (addressing)
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Responsable'),
              subtitle: Text(itemList['category']?['addressing'] ?? 'No disponible'),
            ),
            Divider(),
          ],
        ),
      );
    },
  );
}
