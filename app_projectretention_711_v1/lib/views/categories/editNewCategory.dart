import 'package:app_projectretention_711_v1/api/apiRetention.dart';
import 'package:app_projectretention_711_v1/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Para formatear fechas

// Controladores para los campos de la categoría
final TextEditingController nameController = TextEditingController();
final TextEditingController descriptionController = TextEditingController();
final TextEditingController addressingController = TextEditingController();

modalEditNewCategory(context, option, dynamic listItem) {
  // Creamos una clave global para el formulario
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Variables para los valores seleccionados en los dropdowns
  String? selectedAddressing;

  // Función para seleccionar fecha (se mantiene por consistencia aunque no se use)
  Future<void> _selectDate(BuildContext context, TextEditingController controller, Function(DateTime?) onDateSelected) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
      onDateSelected(picked);
    }
  }

  showModalBottomSheet(
    isScrollControlled: true,
    context: context, 
    builder: (context) {
      if(option == "new") { 
        // Limpiar campos para nueva categoría
        nameController.clear();
        descriptionController.clear();
        addressingController.clear();
        
        // Inicializar valores por defecto
        selectedAddressing = null;
      } else {
        // Cargar datos existentes para editar
        nameController.text = listItem['name'] ?? '';
        descriptionController.text = listItem['description'] ?? '';
        addressingController.text = listItem['addressing'] ?? '';
        
        // Establecer valores para los dropdowns con validación
        String addressingValue = listItem['addressing']?.toString() ?? '';
        selectedAddressing = addressingValue; // Usamos el valor directamente ya que coinciden
        addressingController.text = selectedAddressing ?? '';
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
                    nameController.text,
                    descriptionController.text,
                    selectedAddressing ?? '',
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
                    nameController.text,
                    descriptionController.text,
                    selectedAddressing ?? '',
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
                      TextFormField(
                        controller: nameController,
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

                      // Campo de descripción (sustituye campo de fecha de inicio de formación)
                      TextFormField(
                        controller: descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Descripción *',
                          hintText: 'Ingrese la descripción de la categoría',
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Este campo es obligatorio';
                          }
                          return null;
                        },
                      ),

                      // Campo de atención/abordaje (sustituye campo de fecha de fin de formación)
                      TextFormField(
                        controller: addressingController,
                        decoration: InputDecoration(
                          labelText: 'Atención/Abordaje',
                          hintText: 'Información de atención/abordaje',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.info),
                            onPressed: () {
                              // Acción informativa (se mantiene estructura similar al calendario)
                              Get.snackbar(
                                'Información', 
                                'Este campo describe el tipo de atención o abordaje',
                                colorText: Colors.white,
                                backgroundColor: Colors.blue
                              );
                            },
                          ),
                        ),
                        readOnly: true,
                      ),

                      // Espaciador (se mantiene la estructura original)
                      SizedBox(height: 16),

                      // Dropdown para Direccionamiento - ADAPTADO
                      DropdownButtonFormField<String>(
                        value: selectedAddressing,
                        decoration: InputDecoration(
                          labelText: 'Direccionamiento *',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        ),
                        hint: Text('Seleccione el direccionamiento'),
                        items: [
                          DropdownMenuItem(
                            value: 'Coordinador académico',
                            child: Text('Coordinador académico'),
                          ),
                          DropdownMenuItem(
                            value: 'Coordinador de formación',
                            child: Text('Coordinador de formación'),
                          ),
                        ],
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedAddressing = newValue;
                            addressingController.text = newValue ?? '';
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Este campo es obligatorio';
                          }
                          return null;
                        },
                      ),

                      // Espaciadores adicionales para mantener estructura similar
                      SizedBox(height: 16),
                      SizedBox(height: 16),
                      SizedBox(height: 16),
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