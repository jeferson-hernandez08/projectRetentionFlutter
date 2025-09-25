import 'package:app_projectretention_711_v1/api/apiRetention.dart';
import 'package:app_projectretention_711_v1/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Para formatear fechas

// Controladores para los campos de la intervención
final TextEditingController creationDateController = TextEditingController();
final TextEditingController descriptionController = TextEditingController();
final TextEditingController fkIdStrategiesController = TextEditingController();
final TextEditingController fkIdReportsController = TextEditingController();
final TextEditingController fkIdUsersController = TextEditingController();

modalEditNewIntervention(context, option, dynamic listItem) {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? selectedStrategyId;
  String? selectedReportId;
  String? selectedUserId;
  DateTime? selectedCreationDate;

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) {
      if (option == "new") {
        creationDateController.clear();
        descriptionController.clear();
        fkIdStrategiesController.clear();
        fkIdReportsController.clear();
        fkIdUsersController.clear();

        selectedStrategyId = null;
        selectedReportId = null;
        selectedUserId = null;
        selectedCreationDate = null;
      } else {
        creationDateController.text = listItem['creationDate'] ?? '';
        descriptionController.text = listItem['description'] ?? '';

        String strategyValue = listItem['fkIdStrategies']?.toString() ?? '';
        selectedStrategyId = strategyValue.isNotEmpty ? strategyValue : null;
        fkIdStrategiesController.text = selectedStrategyId ?? '';

        String reportValue = listItem['fkIdReports']?.toString() ?? '';
        selectedReportId = reportValue.isNotEmpty ? reportValue : null;
        fkIdReportsController.text = selectedReportId ?? '';

        String userValue = listItem['fkIdUsers']?.toString() ?? '';
        selectedUserId = userValue.isNotEmpty ? userValue : null;
        fkIdUsersController.text = selectedUserId ?? '';

        if (listItem['creationDate'] != null) {
          try {
            selectedCreationDate = DateTime.parse(listItem['creationDate']);
            creationDateController.text =
                DateFormat('yyyy-MM-dd HH:mm:ss').format(selectedCreationDate!);
          } catch (e) {
            selectedCreationDate = null;
          }
        }
      }

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          if (myReactController.getListStrategies.isEmpty) {
            fetchAPIStrategies().then((_) => setState(() {}));
          }
          if (myReactController.getListReports.isEmpty) {
            fetchAPIReports().then((_) => setState(() {}));
          }
          if (myReactController.getListUsers.isEmpty) {
            fetchAPIUsers().then((_) => setState(() {}));
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
                  bool resp = await newInterventionApi(
                    creationDateController.text,
                    descriptionController.text,
                    selectedStrategyId ?? '',
                    selectedReportId ?? '',
                    selectedUserId ?? '',
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
                  bool resp = await editInterventionApi(
                    listItem['id'],
                    creationDateController.text,
                    descriptionController.text,
                    selectedStrategyId ?? '',
                    selectedReportId ?? '',
                    selectedUserId ?? '',
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
                    Get.snackbar(
                      'Mensaje',
                      "Error al editar la intervención",
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
                    // Campo de Fecha y Hora de Creación
                    TextFormField(
                      controller: creationDateController,
                      decoration: InputDecoration(
                        labelText: 'Fecha y Hora de Creación *',
                        hintText: 'Seleccione fecha y hora',
                      ),
                      readOnly: true,
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
                            final fullDateTime = DateTime(
                              pickedDate.year,
                              pickedDate.month,
                              pickedDate.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );
                            setState(() {
                              selectedCreationDate = fullDateTime;
                              creationDateController.text =
                                  DateFormat('yyyy-MM-dd HH:mm:ss')
                                      .format(fullDateTime);
                            });
                          }
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Este campo es obligatorio';
                        }
                        return null;
                      },
                    ),

                    // Campo para Descripción
                    TextFormField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Descripción *',
                        hintText: 'Ingrese la descripción',
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Este campo es obligatorio';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 16),

                    // Dropdown Estrategia
                    DropdownButtonFormField<String>(
                      value: selectedStrategyId,
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
                          selectedStrategyId = newValue;
                          fkIdStrategiesController.text = newValue ?? '';
                        });
                      },
                      validator: (value) =>
                          value == null || value.isEmpty
                              ? 'Este campo es obligatorio'
                              : null,
                    ),

                    SizedBox(height: 16),

                    // Dropdown Reporte
                    DropdownButtonFormField<String>(
                      value: selectedReportId,
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
                          selectedReportId = newValue;
                          fkIdReportsController.text = newValue ?? '';
                        });
                      },
                      validator: (value) =>
                          value == null || value.isEmpty
                              ? 'Este campo es obligatorio'
                              : null,
                    ),

                    SizedBox(height: 16),

                    // Dropdown Usuario
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
                          child: Text(
                              "${user['firstName']} ${user['lastName']}"),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedUserId = newValue;
                          fkIdUsersController.text = newValue ?? '';
                        });
                      },
                      validator: (value) =>
                          value == null || value.isEmpty
                              ? 'Este campo es obligatorio'
                              : null,
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
