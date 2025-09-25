import 'package:app_projectretention_711_v1/api/apiRetention.dart';
import 'package:app_projectretention_711_v1/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Para formatear fechas

// Controladores para cada campo del formulario
final TextEditingController creationDateController = TextEditingController();
final TextEditingController descriptionController = TextEditingController();
final TextEditingController addressingController = TextEditingController();
final TextEditingController stateController = TextEditingController();
final TextEditingController apprenticeIdController = TextEditingController();
final TextEditingController userIdController = TextEditingController();

modalEditNewReport(context, option, dynamic listItem) {
  // Creamos una clave global para el formulario
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Variables para los valores seleccionados en los dropdowns
  String? selectedAddressing;
  String? selectedState;
  String? selectedApprenticeId;
  String? selectedUserId;
  DateTime? selectedCreationDate;

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) {
      if (option == "new") {
        // Limpiar campos para nuevo reporte
        creationDateController.clear();
        descriptionController.clear();
        addressingController.clear();
        stateController.clear();
        apprenticeIdController.clear();
        userIdController.clear();

        // Inicializar valores por defecto
        selectedAddressing = null;
        selectedState = null;
        selectedApprenticeId = null;
        selectedUserId = null;
        selectedCreationDate = null;
      } else {
        // Cargar datos existentes para editar
        if (listItem['creationDate'] != null) {
          try {
            selectedCreationDate = DateTime.parse(listItem['creationDate']);
            creationDateController.text =
                DateFormat('yyyy-MM-dd HH:mm:ss').format(selectedCreationDate!);
          } catch (e) {
            creationDateController.clear();
          }
        }

        descriptionController.text = listItem['description'] ?? '';

        String addressingValue = listItem['addressing'] ?? '';
        selectedAddressing =
            (['Coordinador Académico', 'Coordinador de Formación']
                    .contains(addressingValue))
                ? addressingValue
                : null;
        addressingController.text = selectedAddressing ?? '';

        String stateValue = listItem['state'] ?? '';
        selectedState = (['Registrado', 'En proceso', 'Retenido', 'Desertado']
                .contains(stateValue))
            ? stateValue
            : null;
        stateController.text = selectedState ?? '';

        String apprenticeValue = listItem['fkIdApprentices']?.toString() ?? '';
        selectedApprenticeId =
            apprenticeValue.isNotEmpty ? apprenticeValue : null;
        apprenticeIdController.text = selectedApprenticeId ?? '';

        String userValue = listItem['fkIdUsers']?.toString() ?? '';
        selectedUserId = userValue.isNotEmpty ? userValue : null;
        userIdController.text = selectedUserId ?? '';
      }

      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        // Capturar aprendices y usuarios solo si no están en memoria
        if (myReactController.getListApprentices.isEmpty) {
          fetchAPIApprentices().then((_) {
            setState(() {});
          });
        }
        if (myReactController.getListUsers.isEmpty) {
          fetchAPIUsers().then((_) {
            setState(() {});
          });
        }

        return Scaffold(
          appBar: AppBar(
            title: (option == "new")
                ? Text('Crear Nuevo Reporte')
                : Text('Editar Reporte'),
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
                      backgroundColor: Colors.orange);
                  return;
                }

                if (option == "new") {
                  // Crear nuevo reporte
                  bool resp = await newReportApi(
                    creationDateController.text,
                    descriptionController.text,
                    selectedAddressing ?? '',
                    selectedState ?? '',
                    selectedApprenticeId ?? '',
                    selectedUserId ?? '',
                  );
                  Get.back();
                  if (resp) {
                    Get.snackbar('Mensaje',
                        "Se ha añadido correctamente un nuevo reporte",
                        colorText: Colors.white,
                        backgroundColor: Colors.green);
                  } else {
                    Get.snackbar('Mensaje', "Error al agregar el nuevo reporte",
                        colorText: Colors.white, backgroundColor: Colors.red);
                  }
                } else {
                  // Editar reporte existente
                  bool resp = await editReportApi(
                    listItem['id'],
                    creationDateController.text,
                    descriptionController.text,
                    selectedAddressing ?? '',
                    selectedState ?? '',
                    selectedApprenticeId ?? '',
                    selectedUserId ?? '',
                  );
                  Get.back();
                  if (resp) {
                    Get.snackbar(
                        'Mensaje', "Se ha editado correctamente el reporte",
                        colorText: Colors.green,
                        backgroundColor: Colors.greenAccent);
                  } else {
                    Get.snackbar('Mensaje', "Error al editar el reporte",
                        colorText: Colors.red);
                  }
                }
              }),
          body: Padding(
            padding: EdgeInsets.only(
              left: 8,
              right: 8,
              top: 8,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  // Fecha de creación (fecha + hora)
                  TextFormField(
                    controller: creationDateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Fecha y hora de creación *',
                      hintText: 'Seleccione fecha y hora',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () async {
                          // Seleccionar la fecha
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate:
                                selectedCreationDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );

                          if (pickedDate != null) {
                            // Seleccionar la hora
                            final TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime:
                                  TimeOfDay.fromDateTime(DateTime.now()),
                            );

                            if (pickedTime != null) {
                              setState(() {
                                selectedCreationDate = DateTime(
                                  pickedDate.year,
                                  pickedDate.month,
                                  pickedDate.day,
                                  pickedTime.hour,
                                  pickedTime.minute,
                                );

                                // Guardamos fecha y hora en formato timestamp
                                creationDateController.text =
                                    DateFormat('yyyy-MM-dd HH:mm:ss')
                                        .format(selectedCreationDate!);
                              });
                            }
                          }
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Este campo es obligatorio';
                      }
                      return null;
                    },
                  ),

                  // Descripción
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Descripción *',
                      hintText: 'Ingrese la descripción',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Este campo es obligatorio';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 16),

                  // Dropdown para Addressing
                  DropdownButtonFormField<String>(
                    value: selectedAddressing,
                    decoration: InputDecoration(
                      labelText: 'Direccionamiento *',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    ),
                    hint: Text('Seleccione el direccionamiento'),
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

                  SizedBox(height: 16),

                  // Dropdown para State
                  DropdownButtonFormField<String>(
                    value: selectedState,
                    decoration: InputDecoration(
                      labelText: 'Estado *',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    ),
                    hint: Text('Seleccione un estado'),
                    items: [
                      DropdownMenuItem(
                        value: 'Registrado',
                        child: Text('Registrado'),
                      ),
                      DropdownMenuItem(
                        value: 'En proceso',
                        child: Text('En proceso'),
                      ),
                      DropdownMenuItem(
                        value: 'Retenido',
                        child: Text('Retenido'),
                      ),
                      DropdownMenuItem(
                        value: 'Desertado',
                        child: Text('Desertado'),
                      ),
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedState = newValue;
                        stateController.text = newValue ?? '';
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Este campo es obligatorio';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 16),

                  // Dropdown para Aprendiz
                  DropdownButtonFormField<String>(
                    value: selectedApprenticeId,
                    decoration: InputDecoration(
                      labelText: 'Aprendiz *',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    ),
                    hint: Text('Seleccione un aprendiz'),
                    items: myReactController.getListApprentices
                        .map<DropdownMenuItem<String>>((apprentice) {
                      return DropdownMenuItem<String>(
                        value: apprentice['id'].toString(),
                        child: Text(
                            "${apprentice['firtsName']} ${apprentice['lastName']}"),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedApprenticeId = newValue;
                        apprenticeIdController.text = newValue ?? '';
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Este campo es obligatorio';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 16),

                  // Dropdown para Usuario
                  DropdownButtonFormField<String>(
                    value: selectedUserId,
                    decoration: InputDecoration(
                      labelText: 'Usuario *',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    ),
                    hint: Text('Seleccione un usuario'),
                    items: myReactController.getListUsers
                        .map<DropdownMenuItem<String>>((user) {
                      return DropdownMenuItem<String>(
                        value: user['id'].toString(),
                        child:
                            Text("${user['firstName']} ${user['lastName']}"),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedUserId = newValue;
                        userIdController.text = newValue ?? '';
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
      });
    },
  );
}
