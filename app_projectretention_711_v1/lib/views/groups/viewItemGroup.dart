import 'package:app_projectretention_711_v1/main.dart';
import 'package:flutter/material.dart';
import 'package:app_projectretention_711_v1/api/apiRetention.dart'; // Importa tu API

viewItemGroup(context, itemList) async {
  // Cargar programas de formación si no están disponibles
  if (myReactController.getListTrainingPrograms.isEmpty) {
    await fetchAPITrainingPrograms();
  }

  // Obtener el nombre del programa de formación basado en fkIdTrainingPrograms
  String getTrainingProgramName(int? fkIdTrainingPrograms) {
    if (fkIdTrainingPrograms == null) return 'No disponible';
    final program = myReactController.getListTrainingPrograms.firstWhere(
      (prog) => prog['id'] == fkIdTrainingPrograms,
      orElse: () => {'name': 'Programa no encontrado'},
    );
    return program['name'] ?? 'Programa no encontrado';
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 7, 25, 83), // Azul oscuro
              Color.fromARGB(255, 23, 214, 214), // Azul celeste
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: const Text(
              'Detalle del Grupo',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
          ),
          body: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  const SizedBox(height: 10),

                  // 🔹 Íconos de colores personalizados
                  _buildDetailCard(
                    icon: Icons.key,
                    title: 'ID',
                    value: itemList['id'].toString(),
                    color: Colors.blueAccent,
                  ),
                  _buildDetailCard(
                    icon: Icons.insert_drive_file,
                    title: 'Ficha',
                    value: itemList['file'] ?? 'No disponible',
                    color: Colors.deepPurple,
                  ),
                  _buildDetailCard(
                    icon: Icons.date_range,
                    title: 'Inicio Etapa Lectiva',
                    value: itemList['trainingStart'] ?? 'No disponible',
                    color: Colors.teal,
                  ),
                  _buildDetailCard(
                    icon: Icons.date_range_outlined,
                    title: 'Fin Etapa Lectiva',
                    value: itemList['trainingEnd'] ?? 'No disponible',
                    color: Colors.orangeAccent,
                  ),
                  _buildDetailCard(
                    icon: Icons.play_circle_outline,
                    title: 'Inicio Etapa Productiva',
                    value: itemList['practiceStart'] ?? 'No disponible',
                    color: Colors.pinkAccent,
                  ),
                  _buildDetailCard(
                    icon: Icons.stop_circle_outlined,
                    title: 'Fin Etapa Productiva',
                    value: itemList['practiceEnd'] ?? 'No disponible',
                    color: Colors.lightGreen,
                  ),
                  _buildDetailCard(
                    icon: Icons.person,
                    title: 'Nombre del Gestor',
                    value: itemList['managerName'] ?? 'No disponible',
                    color: Colors.indigo,
                  ),
                  _buildDetailCard(
                    icon: Icons.access_time,
                    title: 'Jornada',
                    value: itemList['shift'] ?? 'No disponible',
                    color: Colors.cyan,
                  ),
                  _buildDetailCard(
                    icon: Icons.school,
                    title: 'Modalidad',
                    value: itemList['modality'] ?? 'No disponible',
                    color: Colors.amber,
                  ),
                  _buildDetailCard(
                    icon: Icons.book,
                    title: 'Programa de Formación',
                    value: getTrainingProgramName(itemList['fkIdTrainingPrograms']),
                    color: Colors.redAccent,
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

// 🔹 Widget reutilizable con color personalizado por ítem
Widget _buildDetailCard({
  required IconData icon,
  required String title,
  required String value,
  required Color color,
}) {
  return Card(
    elevation: 2,
    margin: const EdgeInsets.symmetric(vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(10),
            child: Icon(
              icon,
              color: color,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
