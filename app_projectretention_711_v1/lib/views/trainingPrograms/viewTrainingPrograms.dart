import 'package:app_projectretention_711_v1/api/apiRetention.dart';
import 'package:app_projectretention_711_v1/main.dart';
import 'package:app_projectretention_711_v1/views/trainingPrograms/editNewTrainingProgram.dart';
import 'package:app_projectretention_711_v1/views/trainingPrograms/viewDeleteTrainingProgram.dart';
import 'package:app_projectretention_711_v1/views/trainingPrograms/viewItemTrainingProgram.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewTrainingProgramsCPIC extends StatefulWidget {
  const ViewTrainingProgramsCPIC({super.key});

  @override
  State<ViewTrainingProgramsCPIC> createState() =>
      _ViewTrainingProgramsCPICState();
}

class _ViewTrainingProgramsCPICState extends State<ViewTrainingProgramsCPIC> {
  @override
  void initState() {
    super.initState();
    fetchAPITrainingPrograms(); // Método que trae los programas de formación
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // viewCreateTrainingProgram(context);
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Obx(
        () => myReactController.getListTrainingPrograms.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.school, size: 90, color: Colors.grey[400]),
                    SizedBox(height: 18),
                    Text(
                      'No hay programas registrados',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Presiona el botón + para agregar uno nuevo',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                itemCount: myReactController.getListTrainingPrograms.length,
                itemBuilder: (BuildContext context, int index) {
                  final itemList =
                      myReactController.getListTrainingPrograms[index];
                  final name = itemList['name'] ?? 'Sin nombre';
                  final level = itemList['level'] ?? 'Sin nivel';
                  final version = itemList['version'] ?? '0';

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Columna izquierda con ícono e ID
                          Column(
                            children: [
                              Container(
                                width: 65,
                                height: 65,
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: Colors.blue,
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.menu_book,
                                          color: Colors.blue, size: 26),
                                      SizedBox(height: 4),
                                      Text(
                                        'ID: ${itemList['id']}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(width: 20),

                          // Contenido principal
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 12),
                                Row(
                                  children: [
                                    Icon(Icons.layers,
                                        size: 18, color: Colors.grey[600]),
                                    SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        'Nivel: $level',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[700],
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                Row(
                                  children: [
                                    Icon(Icons.verified,
                                        size: 18, color: Colors.grey[600]),
                                    SizedBox(width: 6),
                                    Text(
                                      'Versión: v$version',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          SizedBox(width: 14),

                          // Acciones
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                tooltip: 'Ver programa',
                                onPressed: () {
                                  viewItemTrainingProgram(context, itemList);
                                },
                                icon: Icon(Icons.visibility,
                                    color: Colors.blue, size: 26),
                              ),
                              IconButton(
                                tooltip: 'Editar programa',
                                onPressed: () async {
                                  await modalEditNewTrainingProgram(
                                      context, "edit", itemList);
                                },
                                icon: Icon(Icons.edit,
                                    color: Colors.orange, size: 26),
                              ),
                              IconButton(
                                tooltip: 'Eliminar programa',
                                onPressed: () {
                                  viewDeleteTrainingProgram(context, itemList);
                                },
                                icon: Icon(Icons.delete,
                                    color: Colors.red, size: 26),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
