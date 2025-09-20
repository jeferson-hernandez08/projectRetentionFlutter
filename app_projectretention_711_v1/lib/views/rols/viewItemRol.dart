import 'package:flutter/material.dart';

viewItemRol(context, itemList) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Detalle del Rol'),
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
              leading: Icon(Icons.admin_panel_settings),
              title: Text('Nombre'),
              subtitle: Text(itemList['name'] ?? 'No disponible'),
            ),
            Divider(),
      
          ],
        ),
      );
    },
  );
}