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
  State<ViewTrainingProgramsCPIC> createState() => _ViewTrainingProgramsCPICState();
}

class _ViewTrainingProgramsCPICState extends State<ViewTrainingProgramsCPIC> {
  @override
  void initState() {
    super.initState();
    // Aquí puedes inicializar cualquier cosa que necesites antes de que se construya el widget
    fetchAPITrainingPrograms();         // Metodo que trae los programas de formación 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Boton flotante para crear
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Llamamos la  función para crear el programa de formación
          //viewCreateTrainingProgram(context);
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue, // Personaliza el color
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: myReactController.getListTrainingPrograms.length,
          itemBuilder: (BuildContext context, int index) {
            final itemList = myReactController.getListTrainingPrograms[index];
            return Card(
              child: ListTile(
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.school), 
                    Text(itemList['id'].toString()),
                  ],
                ),
                title: Text(itemList['name'] ?? 'Sin nombre'),
                subtitle: Text('${itemList['level']} - v${itemList['version']}' ?? 'Sin información'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(onPressed: (){
                      viewItemTrainingProgram(context, itemList);
                    }, icon: Icon( Icons.visibility)),
                    IconButton(onPressed: () async {
                      await modalEditNewTrainingProgram(context, "edit", itemList);
                    }, icon: Icon(Icons.edit)),
                    IconButton(onPressed: (){
                      viewDeleteTrainingProgram(context, itemList);
                    }, icon: Icon(Icons.delete)),

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