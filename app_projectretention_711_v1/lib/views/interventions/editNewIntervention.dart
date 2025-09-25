import 'package:app_projectretention_711_v1/api/apiRetention.dart';
import 'package:app_projectretention_711_v1/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Para formatear fechas

// Controladores de texto
final TextEditingController descriptionController = TextEditingController();
final TextEditingController strategyController = TextEditingController();
final TextEditingController reportController = TextEditingController();
final TextEditingController userController = TextEditingController();

modalEditNewIntervention(context, option, dynamic listItem) {
  // Creamos una clave global para el formulario
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Variables para los valores seleccionados en los dropdowns
  String? selectedStrategy;
  String? selectedReport;
  String? selectedUser;
  DateTime? selectedCreationDate;

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) {
      if (option == "new") {
        // Limpiar campos para nueva intervención
        descriptionController.clear();
        strategyController.clear();
        reportController.clear();
        userController.clear();

        // Inicializar valores por defecto
        selectedStrategy = null;
        selectedReport = null;
        selectedUser = null;
        selectedCreationDate = null;
      } else {
        // Cargar datos existentes para editar
        descriptionController.text = listItem['description'] ?? '';

        String strategyValue = listItem['fkIdStrategies']?.toString() ?? '';
        selectedStrategy = strategyValue.isNotEmpty ? strategyValue : null;
        strategyController.text = selectedStrategy ?? '';

        String reportValue = listItem['fkIdReports']?.toString() ?? '';
        selectedReport = reportValue.isNotEmpty ? reportValue : null;
        reportController.text = selectedReport ?? '';

        String userValue = listItem['fkIdUsers']?.toString() ?? '';
        selectedUser = userValue.isNotEmpty ? userValue : null;
        userController.text = selectedUser ?? '';

        // Procesar fecha de creación si existe
        if (listItem['creationDate'] != null) {
          try {
            selectedCreationDate = DateTime.parse(listItem['creationDate']);
          } catch (e) {
            selectedCreationDate = null;
          }
        }
      }

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          // Capturar listas solo si no están en memoria
          if (myReactController.getListStrategies.isEmpty) {
            fetchAPIStrategies().then((_) {
              setState(() {}); // Refresca cuando termine la API
            });
          }
          if (myReactController.getListReports.isEmpty) {
            fetchAPIReports().then((_) {
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
                  ? Text('Crear Nueva Intervención')
                  : Text('Editar Intervención'),
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
                    backgroundColor: Colors.orange,
                  );
                  return;
                }

                if (option == "new") {
                  // Crear nueva intervención
                  bool resp = await newInterventionApi(
                    descriptionController.text,
                    selectedCreationDate?.toIso8601String() ?? '',
                    selectedStrategy ?? '',
                    selectedReport ?? '',
                    selectedUser ?? '',
                  );
                  Get.back();
                  if (resp) {
                    Get.snackbar(
                      'Mensaje',
                      "Se ha añadido correctamente una nueva intervención",
                      colorText: Colors.white,
                      backgroundColor: Colors.green,
                    );
                  } else {
                    Get.snackbar(
                      'Mensaje',
                      "Error al agregar la nueva intervención",
                      colorText: Colors.white,
                      backgroundColor: Colors.red,
                    );
                  }
                } else {
                  // Editar intervención existente
                  bool resp = await editInterventionApi(
                    listItem['id'],
                    descriptionController.text,
                    selectedCreationDate?.toIso8601String() ?? '',
                    selectedStrategy ?? '',
                    selectedReport ?? '',
                    selectedUser ?? '',
                  );
                  Get.back();
                  if (resp) {
                    Get.snackbar(
                      'Mensaje',
                      "Se ha editado correctamente la intervención",
                      colorText: Colors.green,
                      backgroundColor: Colors.greenAccent,
                    );
                  } else {
                    Get.snackbar('Mensaje', "Error al editar la intervención",
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

                    // Selector de Fecha y Hora de Creación
                    ListTile(
                      title: Text(selectedCreationDate == null
                          ? 'Seleccionar fecha y hora de creación *'
                          : 'Fecha: ${DateFormat('yyyy-MM-dd – kk:mm').format(selectedCreationDate!)}'),
                      trailing: Icon(Icons.calendar_today),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate:
                              selectedCreationDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );

                        if (pickedDate != null) {
                          TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                                selectedCreationDate ?? DateTime.now()),
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
                            });
                          }
                        }
                      },
                    ),

                    SizedBox(height: 16),

                    // Dropdown para Estrategia
                    DropdownButtonFormField<String>(
                      value: selectedStrategy,
                      decoration: InputDecoration(
                        labelText: 'Estrategia *',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      ),
                      hint: Text('Seleccione una estrategia'),
                      items: myReactController.getListStrategies
                          .map<DropdownMenuItem<String>>((strategy) {
                        return DropdownMenuItem<String>(
                          value: strategy['id'].toString(),
                          child: Text(strategy['strategy']),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedStrategy = newValue;
                          strategyController.text = newValue ?? '';
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

                    // Dropdown para Reporte
                    DropdownButtonFormField<String>(
                      value: selectedReport,
                      decoration: InputDecoration(
                        labelText: 'Reporte *',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      ),
                      hint: Text('Seleccione un reporte'),
                      items: myReactController.getListReports
                          .map<DropdownMenuItem<String>>((report) {
                        return DropdownMenuItem<String>(
                          value: report['id'].toString(),
                          child: Text(report['description']),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedReport = newValue;
                          reportController.text = newValue ?? '';
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
                      value: selectedUser,
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
                          child: Text(
                              '${user['firstName']} ${user['lastName']}'),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedUser = newValue;
                          userController.text = newValue ?? '';
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
