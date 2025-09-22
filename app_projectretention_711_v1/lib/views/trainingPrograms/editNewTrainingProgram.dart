import 'package:app_projectretention_711_v1/api/apiRetention.dart';
import 'package:app_projectretention_711_v1/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Para formatear fechas

final TextEditingController nameController = TextEditingController();
final TextEditingController levelController = TextEditingController();
final TextEditingController versionController = TextEditingController();

modalEditNewTrainingProgram(context, option, dynamic listItem) {
  // Creamos una clave global para el formulario
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  showModalBottomSheet(
    isScrollControlled: true,
    context: context, 
    builder: (context) {
      if(option == "new") { 
        // Limpiar campos para nuevo programa de formación
        nameController.clear();
        levelController.clear();
        versionController.clear();
      } else {
        // Cargar datos existentes para editar
        nameController.text = listItem['name'] ?? '';
        levelController.text = listItem['level'] ?? '';
        versionController.text = listItem['version'] ?? '';
      }

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Scaffold(
            appBar: AppBar(
              title: (option == "new") ? Text('Crear Nuevo Programa de Formación') : Text('Editar Programa de Formación'),
              backgroundColor: (option == "new") ? Colors.green : Colors.blue,
              foregroundColor: Colors.white,
              centerTitle: true,
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: (option == "new") ? Colors.green : Colors.blue,
              foregroundColor: Colors.white,
              child: Icon(option == "new" ? Icons.add : Icons.edit),
              onPressed: () async {
                // Validar formulario
                if (!_formKey.currentState!.validate()) {
                  Get.snackbar(
                    'Campos incompletos', 
                    'Por favor, complete todos los campos obligatorios',
                    colorText: Colors.white,
                    backgroundColor: Colors.orange
                  );
                  return;
                }
                
                if(option == "new") {
                  // Crear nuevo programa de formación
                  bool resp = await newTrainingProgramApi(
                    nameController.text, 
                    levelController.text,
                    versionController.text,
                  );
                  Get.back();
                  if(resp) {
                    Get.snackbar(
                      'Mensaje', "Se ha añadido correctamente un nuevo programa de formación", 
                      colorText: Colors.white,
                      backgroundColor: Colors.green
                    );
                  } else {
                    Get.snackbar(
                      'Mensaje', "Error al agregar el nuevo programa de formación", 
                      colorText: Colors.white,
                      backgroundColor: Colors.red
                    );
                  }
                } else {   
                  // Editar programa de formación existente
                  bool resp = await editTrainingProgramApi(
                    listItem['id'],
                    nameController.text, 
                    levelController.text,
                    versionController.text,
                  );
                  Get.back();
                  if(resp) {
                    Get.snackbar(
                      'Mensaje', "Se ha editado correctamente el programa de formación", 
                      colorText: Colors.green,
                      backgroundColor: Colors.greenAccent
                    );
                  } else {
                    Get.snackbar('Mensaje', "Error al editar el programa de formación", colorText: Colors.red);
                  }
                }
              }),

              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Nombre *',
                          hintText: 'Ingrese el nombre del programa',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Este campo es obligatorio';
                          }
                          return null;
                        },
                      ),

                      TextFormField(
                        controller: levelController,
                        decoration: InputDecoration(
                          labelText: 'Nivel *',
                          hintText: 'Ingrese el nivel del programa',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Este campo es obligatorio';
                          }
                          return null;
                        },
                      ),

                      TextFormField(
                        controller: versionController,
                        decoration: InputDecoration(
                          labelText: 'Versión *',
                          hintText: 'Ingrese la versión del programa',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Este campo es obligatorio';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
          );
        }
      );
    }
  );
}