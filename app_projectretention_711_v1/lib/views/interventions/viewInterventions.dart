import 'package:app_projectretention_711_v1/api/apiRetention.dart';
import 'package:app_projectretention_711_v1/main.dart';
import 'package:app_projectretention_711_v1/views/interventions/editNewIntervention.dart';
import 'package:app_projectretention_711_v1/views/interventions/viewDeleteIntervention.dart';
import 'package:app_projectretention_711_v1/views/interventions/viewItemIntervention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ViewInterventionsCPIC extends StatefulWidget {
  const ViewInterventionsCPIC({super.key});

  @override
  State<ViewInterventionsCPIC> createState() => _ViewInterventionsCPICState();
}

class _ViewInterventionsCPICState extends State<ViewInterventionsCPIC> {
  @override
  void initState() {
    super.initState();
    fetchAPIInterventions(); // 🔹 Cargar lista de intervenciones al iniciar
  }

  // 🔹 Formatear fecha y hora
  String formatDateTime(String? date) {
    if (date == null) return 'Sin fecha';
    try {
      final parsed = DateTime.parse(date);
      return DateFormat('dd/MM/yyyy HH:mm').format(parsed);
    } catch (e) {
      return 'Formato inválido';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          // viewCreateIntervention(context);
        },
      ),
      body: Obx(
        () => myReactController.getListInterventions.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.flag_circle, size: 90, color: Colors.grey[400]),
                    const SizedBox(height: 18),
                    Text(
                      'No hay intervenciones registradas',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Presiona el botón + para agregar una nueva',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                itemCount: myReactController.getListInterventions.length,
                itemBuilder: (BuildContext context, int index) {
                  final itemList =
                      myReactController.getListInterventions[index];
                  final id = itemList['id']?.toString() ?? '0';
                  final description =
                      itemList['description'] ?? 'Sin descripción';
                  final creationDate =
                      formatDateTime(itemList['creationDate']);
                  final strategy =
                      itemList['strategy']?['strategy'] ?? 'Sin estrategia';

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
                          // 🔹 Columna izquierda con ícono e ID
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
                                      const Icon(Icons.flag,
                                          color: Colors.blue, size: 26),
                                      const SizedBox(height: 4),
                                      Text(
                                        'ID: $id',
                                        style: const TextStyle(
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

                          const SizedBox(width: 20),

                          // 🔹 Contenido principal
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  description,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Icon(Icons.date_range,
                                        size: 18, color: Colors.grey[600]),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        creationDate,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[700],
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Icon(Icons.lightbulb,
                                        size: 18, color: Colors.grey[600]),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        'Estrategia: $strategy',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[700],
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 14),

                          // 🔹 Acciones
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                tooltip: 'Ver intervención',
                                onPressed: () {
                                  viewItemIntervention(context, itemList);
                                },
                                icon: const Icon(Icons.visibility,
                                    color: Colors.blue),
                              ),
                              IconButton(
                                tooltip: 'Editar intervención',
                                onPressed: () async {
                                  await modalEditNewIntervention(
                                      context, "edit", itemList);
                                },
                                icon: const Icon(Icons.edit,
                                    color: Colors.orange, size: 26),
                              ),
                              IconButton(
                                tooltip: 'Eliminar intervención',
                                onPressed: () {
                                  viewDeleteIntervention(context, itemList);
                                },
                                icon: const Icon(Icons.delete,
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
