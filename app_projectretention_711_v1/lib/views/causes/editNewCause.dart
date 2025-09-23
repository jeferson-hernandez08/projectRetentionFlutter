import 'package:app_projectretention_711_v1/api/apiRetention.dart';
import 'package:app_projectretention_711_v1/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controladores de texto para los campos de la tabla causes
final TextEditingController causeController = TextEditingController();
final TextEditingController variableController = TextEditingController();
final TextEditingController fkIdCategoriesController = TextEditingController();

modalEditNewCause(context, option, dynamic listItem) {
  // Creamos una clave global para el formulario
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Variables para valores seleccionados en dropdowns
  String? selectedCategoryId;

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) {
      if (option == "new") {
        // Limpiar campos para nuevo registro
        causeController.clear();
        variableController.clear();
        fkIdCategoriesController.clear();

        // Inicializar valores por defecto
        selectedCategoryId = null;
      } else {
        // Cargar datos existentes para editar
        causeController.text = listItem['cause'] ?? '';
        variableController.text = listItem['variable'] ?? '';

        // Establecer valores para el dropdown con validación
        String categoryValue = listItem['fkIdCategories']?.toString() ?? '';
        selectedCategoryId = categoryValue.isNotEmpty ? categoryValue : null;
        fkIdCategoriesController.text = selectedCategoryId ?? '';
      }

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          // Capturar las categorías solo si no están en memoria
          if (myReactController.getListCategories.isEmpty) {
            fetchAPICategories().then((_) {
              setState(() {}); // Refresca cuando termine la API
            });
          }

          return Scaffold(
            appBar: AppBar(
              title: (option == "new")
                  ? Text('Crear Nueva Causa')
                  : Text('Editar Causa'),
              backgroundColor:
                  (option == "new") ? Colors.green : Colors.blue,
              foregroundColor: Colors.white,
              centerTitle: true,
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor:
                  (option == "new") ? Colors.green : Colors.blue,
              foregroundColor: Colors.white,
              child: Icon(option == "new" ? Icons.add : Icons.edit),
              onPressed: () async {
                // Validar formulario
                if (!_formKey.currentState!.validate()) {
                  Get.snackbar(
                    'Campos incompletos',
                    'Por favor, complete todos los campos obligatorios',
                    colorText: Colors.white,
                    backgroundColor: Colors.orange,
                  );
                  return;
                }

                if (option == "new") {
                  // Crear nueva causa
                  bool resp = await newCauseApi(
                    causeController.text,
                    variableController.text,
                    selectedCategoryId ?? '',
                  );
                  Get.back();
                  if (resp) {
                    Get.snackbar(
                      'Mensaje',
                      "Se ha añadido correctamente una nueva causa",
                      colorText: Colors.white,
                      backgroundColor: Colors.green,
                    );
                  } else {
                    Get.snackbar(
                      'Mensaje',
                      "Error al agregar la nueva causa",
                      colorText: Colors.white,
                      backgroundColor: Colors.red,
                    );
                  }
                } else {
                  // Editar causa existente
                  bool resp = await editCauseApi(
                    listItem['id'],
                    causeController.text,
                    variableController.text,
                    selectedCategoryId ?? '',
                  );
                  Get.back();
                  if (resp) {
                    Get.snackbar(
                      'Mensaje',
                      "Se ha editado correctamente la causa",
                      colorText: Colors.green,
                      backgroundColor: Colors.greenAccent,
                    );
                  } else {
                    Get.snackbar(
                      'Mensaje',
                      "Error al editar la causa",
                      colorText: Colors.red,
                    );
                  }
                }
              },
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    // Campo para cause
                    TextFormField(
                      controller: causeController,
                      decoration: InputDecoration(
                        labelText: 'Causa *',
                        hintText: 'Ingrese la causa',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Este campo es obligatorio';
                        }
                        return null;
                      },
                    ),

                    // Campo para variable
                    TextFormField(
                      controller: variableController,
                      decoration: InputDecoration(
                        labelText: 'Variable *',
                        hintText: 'Ingrese la variable asociada',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Este campo es obligatorio';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 16),

                    // Dropdown para Categoría
                    DropdownButtonFormField<String>(
                      value: selectedCategoryId,
                      decoration: InputDecoration(
                        labelText: 'Categoría *',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      ),
                      hint: Text('Seleccione una categoría'),
                      items: myReactController.getListCategories
                          .map<DropdownMenuItem<String>>((cat) {
                        return DropdownMenuItem<String>(
                          value: cat['id'].toString(),
                          child: Text(cat['name']),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCategoryId = newValue;
                          fkIdCategoriesController.text = newValue ?? '';
                        });
                      },
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
        },
      );
    },
  );
}
