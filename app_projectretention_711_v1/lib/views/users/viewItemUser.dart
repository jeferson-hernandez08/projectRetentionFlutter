import 'package:app_projectretention_711_v1/main.dart';
import 'package:flutter/material.dart';
import 'package:app_projectretention_711_v1/api/apiRetention.dart'; // Importa tu API

viewItemUser(context, itemList) async {
  // Cargar roles si no están disponibles
  if (myReactController.getListRols.isEmpty) {
    await fetchAPIRols();
  }

  // Función para obtener el nombre del rol basado en el fkIdRols
  String getRolName(int? fkIdRols) {
    if (fkIdRols == null) return 'No disponible';
    
    // Buscar el rol en la lista de roles del controlador
    final rol = myReactController.getListRols.firstWhere(
      (rol) => rol['id'] == fkIdRols,
      orElse: () => {'name': 'Rol no encontrado'},
    );
    
    return rol['name'] ?? 'Rol no encontrado';
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Detalle del Usuario'),
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
              leading: Icon(Icons.person),
              title: Text('Nombre'),
              subtitle: Text(itemList['firstName'] ?? 'No disponible'),
            ),
            Divider(),

            ListTile(
              leading: Icon(Icons.person_outline),
              title: Text('Apellido'),
              subtitle: Text(itemList['lastName'] ?? 'No disponible'),
            ),
            Divider(),

            ListTile(
              leading: Icon(Icons.email),
              title: Text('Email'),
              subtitle: Text(itemList['email'] ?? 'No disponible'),
            ),
            Divider(),

            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Teléfono'),
              subtitle: Text(itemList['phone'] ?? 'No disponible'),
            ),
            Divider(),

            ListTile(
              leading: Icon(Icons.badge),
              title: Text('Documento'),
              subtitle: Text(itemList['document'] ?? 'No disponible'),
            ),
            Divider(),

            ListTile(
              leading: Icon(Icons.work),
              title: Text('Tipo de Coordinador'),
              subtitle: Text(itemList['coordinadorType'] ?? 'No disponible'),
            ),
            Divider(),

            ListTile(
              leading: Icon(Icons.admin_panel_settings),
              title: Text('Es Manager'),
              subtitle: Text(itemList['manager']?.toString() == 'true' ? 'Sí' : 
                            itemList['manager']?.toString() == 'false' ? 'No' : 
                            'No disponible'),
            ),
            Divider(),

            ListTile(
              leading: Icon(Icons.security),
              title: Text('Rol'),
              subtitle: Text(getRolName(itemList['fkIdRols'])),
            ),
            Divider(),

            ListTile(
              leading: Icon(Icons.lock_reset),
              title: Text('Password Reset Token'),
              subtitle: Text(itemList['passwordResetToken'] ?? 'No disponible'),
            ),
            Divider(),

            ListTile(
              leading: Icon(Icons.timer_off),
              title: Text('Password Reset Expiration'),
              subtitle: Text(itemList['passwordResetExpires'] ?? 'No disponible'),
            ),
            Divider(),
          ],
        ),
      );
    },
  );
}