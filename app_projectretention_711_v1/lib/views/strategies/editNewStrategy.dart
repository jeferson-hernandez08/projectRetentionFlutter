import 'package:app_projectretention_711_v1/api/apiRetention.dart';
import 'package:app_projectretention_711_v1/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controladores de texto para los campos de la estrategia
final TextEditingController strategyController = TextEditingController();
final TextEditingController categoryIdController = TextEditingController();

modalEditNewStrategy(context, option, dynamic listItem) {
  // Creamos una clave global para el formulario
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Variables para valores seleccionados
  String? selectedCategoryId;

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) {
      if (option == "new") {
        // Limpiar campos para nueva estrategia
        strategyController.clear();
        categoryIdController.clear();

        // Inicializar valores por defecto
        selectedCategoryId = null;
      } else {
        // Cargar datos existentes para editar
        strategyController.text = listItem['strategy'] ?? '';

        // Establecer valores para el dropdown con validación
        String categoryValue = listItem['fkIdCategories']?.toString() ?? '';
        selectedCategoryId = categoryValue.isNotEmpty ? categoryValue : null;
        categoryIdController.text = selectedCategoryId ?? '';
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
                  ? Text('Crear Nueva Estrategia')
                  : Text('Editar Estrategia'),
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
                  // Crear nueva estrategia
                  bool resp = await newStrategyApi(
                    strategyController.text,
                    selectedCategoryId ?? '',
                  );
                  Get.back();
                  if (resp) {
                    Get.snackbar(
                      'Mensaje',
                      "Se ha añadido correctamente una nueva estrategia",
                      colorText: Colors.white,
                      backgroundColor: Colors.green,
                    );
                  } else {
                    Get.snackbar(
                      'Mensaje',
                      "Error al agregar la nueva estrategia",
                      colorText: Colors.white,
                      backgroundColor: Colors.red,
                    );
                  }
                } else {
                  // Editar estrategia existente
                  bool resp = await editStrategyApi(
                    listItem['id'],
                    strategyController.text,
                    selectedCategoryId ?? '',
                  );
                  Get.back();
                  if (resp) {
                    Get.snackbar(
                      'Mensaje',
                      "Se ha editado correctamente la estrategia",
                      colorText: Colors.green,
                      backgroundColor: Colors.greenAccent,
                    );
                  } else {
                    Get.snackbar(
                        'Mensaje', "Error al editar la estrategia",
                        colorText: Colors.red);
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
                    TextFormField(
                      controller: strategyController,
                      decoration: InputDecoration(
                        labelText: 'Estrategia *',
                        hintText: 'Ingrese la estrategia',
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
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
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
                          categoryIdController.text = newValue ?? '';
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
