import 'package:app_projectretention_711_v1/api/apiRetention.dart';
import 'package:app_projectretention_711_v1/main.dart';
import 'package:app_projectretention_711_v1/views/interventions/editNewIntervention.dart';
import 'package:app_projectretention_711_v1/views/interventions/viewDeleteIntervention.dart';
import 'package:app_projectretention_711_v1/views/interventions/viewItemIntervention.dart';
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
    fetchAPIInterventions();         // Método del ambiente que trae las intervenciones
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Botón flotante para crear
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Llamamos la función para crear la intervención
          //viewCreateIntervention(context);
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.teal, // Personaliza el color
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: myReactController.getListInterventions.length,
          itemBuilder: (BuildContext context, int index) {
            final itemList = myReactController.getListInterventions[index];
            return Card(
              child: ListTile(
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.flag), 
                    Text(itemList['id'].toString()),
                  ],
                ),
                // Mostramos la descripción de la intervención como título
                title: Text(itemList['description'] ?? 'Sin descripción'),
                // Mostramos la fecha de creación como subtítulo
                subtitle: Text(itemList['creationDate'] ?? 'Sin fecha'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 👁 Ver detalle de la intervención
                    IconButton(
                      onPressed: () {
                        viewItemIntervention(context, itemList);
                      }, 
                      icon: const Icon(Icons.visibility)
                    ),
                    // ✏️ Editar intervención
                    IconButton(
                      onPressed: () async {
                        await modalEditNewIntervention(context, "edit", itemList);
                      }, 
                      icon: const Icon(Icons.edit)
                    ),
                    // 🗑 Eliminar intervención
                    IconButton(
                      onPressed: () {
                        viewDeleteIntervention(context, itemList);
                      }, 
                      icon: const Icon(Icons.delete)
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
