import 'package:app_projectretention_711_v1/api/apiRetention.dart';
import 'package:app_projectretention_711_v1/main.dart';
import 'package:app_projectretention_711_v1/views/interventions/viewDeleteIntervention.dart';
import 'package:app_projectretention_711_v1/views/interventions/viewItemIntervention.dart';
import 'package:app_projectretention_711_v1/views/interventions/editNewIntervention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewInterventionsCPIC extends StatefulWidget {
  const ViewInterventionsCPIC({super.key});

  @override
  State<ViewInterventionsCPIC> createState() => _ViewInterventionsCPICState();
}

class _ViewInterventionsCPICState extends State<ViewInterventionsCPIC> {
  @override
  void initState() {
    super.initState();
    // Aquí puedes inicializar cualquier cosa que necesites antes de que se construya el widget
    fetchAPIInterventions(); // Método del API que trae las intervenciones
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Botón flotante para crear una nueva intervención
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Llamamos la función para crear una nueva intervención
          //viewCreateIntervention(context);
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue, // Personaliza el color
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: myReactController.getListInterventions.length,
          itemBuilder: (BuildContext context, int index) {
            final itemList = myReactController.getListInterventions[index];

            // Formatear la fecha (creationDate)
            String fechaCreacion = "Sin fecha";
            if (itemList['creationDate'] != null) {
              DateTime fecha = DateTime.parse(itemList['creationDate']);
              fechaCreacion =
                  "${fecha.day.toString().padLeft(2, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.year} ${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}:${fecha.second.toString().padLeft(2, '0')}";
            }

            return Card(
              child: ListTile(
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.assignment), // Ícono de intervención
                    Text(itemList['id'].toString()), // ID de la intervención
                  ],
                ),
                title: Text(
                  itemList['description'] ?? 'Sin descripción',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text("Fecha: $fechaCreacion"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Ver detalles de la intervención
                    IconButton(
                        onPressed: () {
                          viewItemIntervention(context, itemList);
                        },
                        icon: const Icon(Icons.visibility)),

                    // Editar intervención
                    IconButton(
                        onPressed: () async {
                          await modalEditNewIntervention(
                              context, "edit", itemList);
                        },
                        icon: const Icon(Icons.edit)),

                    // Eliminar intervención
                    IconButton(
                        onPressed: () {
                          viewDeleteIntervention(context, itemList);
                        },
                        icon: const Icon(Icons.delete)),
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
