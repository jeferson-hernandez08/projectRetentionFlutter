import 'package:app_projectretention_711_v1/main.dart';
import 'package:flutter/material.dart';
import 'package:app_projectretention_711_v1/api/apiRetention.dart'; // Importa tu API

viewItemGroup(context, itemList) async {
  // Cargar programas de formación si no están disponibles
  if (myReactController.getListTrainingPrograms.isEmpty) {
    await fetchAPITrainingPrograms();
  }

  // Función para obtener el nombre del programa de formación basado en fkIdTrainingPrograms
  String getTrainingProgramName(int? fkIdTrainingPrograms) {
    if (fkIdTrainingPrograms == null) return 'No disponible';
    
    // Buscar el programa en la lista de programas del controlador
    final program = myReactController.getListTrainingPrograms.firstWhere(
      (prog) => prog['id'] == fkIdTrainingPrograms,
      orElse: () => {'name': 'Programa no encontrado'},
    );
    
    return program['name'] ?? 'Programa no encontrado';
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Detalle del Grupo'),
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
              leading: Icon(Icons.insert_drive_file),
              title: Text('Ficha'),
              subtitle: Text(itemList['file'] ?? 'No disponible'),
            ),
            Divider(),

            ListTile(
              leading: Icon(Icons.date_range),
              title: Text('Inicio Etapa Lectiva'),
              subtitle: Text(itemList['trainingStart'] ?? 'No disponible'),
            ),
            Divider(),

            ListTile(
              leading: Icon(Icons.date_range_outlined),
              title: Text('Fin Etapa Lectiva'),
              subtitle: Text(itemList['trainingEnd'] ?? 'No disponible'),
            ),
            Divider(),

            ListTile(
              leading: Icon(Icons.play_circle_outline),
              title: Text('Inicio Etapa Productiva'),
              subtitle: Text(itemList['practiceStart'] ?? 'No disponible'),
            ),
            Divider(),

            ListTile(
              leading: Icon(Icons.stop_circle_outlined),
              title: Text('Fin Etapa Productiva'),
              subtitle: Text(itemList['practiceEnd'] ?? 'No disponible'),
            ),
            Divider(),

            ListTile(
              leading: Icon(Icons.person),
              title: Text('Nombre del Gestor'),
              subtitle: Text(itemList['managerName'] ?? 'No disponible'),
            ),
            Divider(),

            ListTile(
              leading: Icon(Icons.access_time),
              title: Text('Jornada'),
              subtitle: Text(itemList['shift'] ?? 'No disponible'),
            ),
            Divider(),

            ListTile(
              leading: Icon(Icons.school),
              title: Text('Modalidad'),
              subtitle: Text(itemList['modality'] ?? 'No disponible'),
            ),
            Divider(),

            ListTile(
              leading: Icon(Icons.book),
              title: Text('Programa de Formación'),
              subtitle: Text(getTrainingProgramName(itemList['fkIdTrainingPrograms'])),
            ),
            Divider(),
          ],
        ),
      );
    },
  );
}
