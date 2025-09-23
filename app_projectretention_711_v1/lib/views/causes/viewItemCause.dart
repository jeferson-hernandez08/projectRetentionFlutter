import 'package:app_projectretention_711_v1/main.dart';
import 'package:flutter/material.dart';
import 'package:app_projectretention_711_v1/api/apiRetention.dart'; // Importa tu API

viewItemCause(context, itemList) async {
  // Cargar categorías si no están disponibles
  if (myReactController.getListCategories.isEmpty) {
    await fetchAPICategories();
  }

  // Función para obtener el nombre de la categoría basado en el fkIdCategories
  String getCategoryName(int? fkIdCategories) {
    if (fkIdCategories == null) return 'No disponible';

    // Buscar la categoría en la lista de categorías del controlador
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
          title: Text('Detalle de la Causa'),
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
        body: ListView(
          children: [
            // Campo ID
            ListTile(
              leading: Icon(Icons.key),
              title: Text('ID'),
              subtitle: Text(itemList['id'].toString()),
            ),
            Divider(),

            // Campo Cause
            ListTile(
              leading: Icon(Icons.warning),
              title: Text('Causa'),
              subtitle: Text(itemList['cause'] ?? 'No disponible'),
            ),
            Divider(),

            // Campo Variable
            ListTile(
              leading: Icon(Icons.category_outlined),
              title: Text('Variable'),
              subtitle: Text(itemList['variable'] ?? 'No disponible'),
            ),
            Divider(),

            // Campo Categoría (con nombre desde la relación)
            ListTile(
              leading: Icon(Icons.layers),
              title: Text('Categoría'),
              subtitle: Text(
                itemList['category'] != null
                    ? itemList['category']['name'] ?? 'No disponible'
                    : getCategoryName(itemList['fkIdCategories']),
              ),
            ),
            Divider(),

            // Campo Descripción de Categoría (extra para mayor detalle)
            ListTile(
              leading: Icon(Icons.description),
              title: Text('Descripción Categoría'),
              subtitle: Text(
                itemList['category'] != null
                    ? itemList['category']['description'] ?? 'No disponible'
                    : 'No disponible',
              ),
            ),
            Divider(),
          ],
        ),
      );
    },
  );
}
