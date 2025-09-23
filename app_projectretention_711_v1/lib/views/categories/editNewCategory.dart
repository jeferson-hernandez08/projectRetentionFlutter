import 'package:app_projectretention_711_v1/api/apiRetention.dart';
import 'package:app_projectretention_711_v1/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//**********Controladores para los campos de Categorías**********//
final TextEditingController nameCategoryController = TextEditingController();
final TextEditingController descriptionCategoryController = TextEditingController();

// Variable para guardar la opción seleccionada en el campo Addressing
String? selectedAddressing;

modalEditNewCategory(context, option, dynamic listItem) {
  // Creamos una clave global para el formulario
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  showModalBottomSheet(
    isScrollControlled: true,
    context: context, 
    builder: (context) {
      if(option == "new") { 
        // Limpiar campos para nueva categoría
        nameCategoryController.clear();
        descriptionCategoryController.clear();
        selectedAddressing = null;
      } else {
        // Cargar datos existentes para editar
        nameCategoryController.text = listItem['name'] ?? '';
        descriptionCategoryController.text = listItem['description'] ?? '';
        selectedAddressing = listItem['addressing'];
      }

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {

          return Scaffold(
            appBar: AppBar(
              title: (option == "new") ? Text('Crear Nueva Categoría') : Text('Editar Categoría'),
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
                  // Crear nueva categoría
                  bool resp = await newCategoryApi(
                    nameCategoryController.text,
                    descriptionCategoryController.text,
                    selectedAddressing,
                  );
                  Get.back();
                  if(resp) {
                    Get.snackbar(
                      'Mensaje', "Se ha añadido correctamente una nueva categoría", 
                      colorText: Colors.white,
                      backgroundColor: Colors.green
                    );
                  } else {
                    Get.snackbar(
                      'Mensaje', "Error al agregar la nueva categoría", 
                      colorText: Colors.white,
                      backgroundColor: Colors.red
                    );
                  }
                } else {   
                  // Editar categoría existente
                  bool resp = await editCategoryApi(
                    listItem['id'],
                    nameCategoryController.text,
                    descriptionCategoryController.text,
                    selectedAddressing,
                  );
                  Get.back();
                  if(resp) {
                    Get.snackbar(
                      'Mensaje', "Se ha editado correctamente la categoría", 
                      colorText: Colors.green,
                      backgroundColor: Colors.greenAccent
                    );
                  } else {
                    Get.snackbar('Mensaje', "Error al editar la categoría", colorText: Colors.red);
                  }
                }
              }),

              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      // Campo de nombre de la categoría
                      TextFormField(
                        controller: nameCategoryController,
                        decoration: InputDecoration(
                          labelText: 'Nombre *',
                          hintText: 'Ingrese el nombre de la categoría',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Este campo es obligatorio';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 16),

                      // Campo de descripción
                      TextFormField(
                        controller: descriptionCategoryController,
                        decoration: InputDecoration(
                          labelText: 'Descripción *',
                          hintText: 'Ingrese la descripción de la categoría',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Este campo es obligatorio';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 16),

                      // Campo de responsable de atención (addressing) con opciones fijas
                      DropdownButtonFormField<String>(
                        value: selectedAddressing,
                        decoration: InputDecoration(
                          labelText: 'Responsable de Atención *',
                        ),
                        items: [
                          DropdownMenuItem(
                            value: 'Coordinador Académico',
                            child: Text('Coordinador Académico'),
                          ),
                          DropdownMenuItem(
                            value: 'Coordinador de Formación',
                            child: Text('Coordinador de Formación'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedAddressing = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Debe seleccionar una opción';
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
