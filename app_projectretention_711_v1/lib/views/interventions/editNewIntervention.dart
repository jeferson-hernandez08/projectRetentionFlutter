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
// 🔥 NUEVOS CONTROLADORES PARA MOSTRAR NOMBRES
final TextEditingController userNameDisplayController = TextEditingController();

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
        // 🔥 FECHA ACTUAL AUTOMÁTICAMENTE
        selectedCreationDate = DateTime.now();
        creationDateController.text = 
            DateFormat('yyyy-MM-dd HH:mm:ss').format(selectedCreationDate!);
        
        descriptionController.clear();
        fkIdStrategiesController.clear();
        fkIdReportsController.clear();
        fkIdUsersController.clear();
        userNameDisplayController.clear(); // 🔥 LIMPIAR CONTROLADOR DE NOMBRE

        selectedStrategyId = null;
        selectedReportId = null;
        selectedUserId = null;
        
        // 🔥 OBTENER USUARIO LOGUEADO Y SELECCIONARLO AUTOMÁTICAMENTE
        final currentUser = myReactController.getUser;
        if (currentUser != null && currentUser['id'] != null) {
          selectedUserId = currentUser['id'].toString();
          fkIdUsersController.text = selectedUserId!;
          // 🔥 MOSTRAR NOMBRE COMPLETO EN LUGAR DEL ID
          userNameDisplayController.text = "${currentUser['firstName']} ${currentUser['lastName']}";
          print('✅ Usuario autoseleccionado: ${currentUser['firstName']} ${currentUser['lastName']} (ID: ${currentUser['id']})');
        } else {
          selectedUserId = null;
          fkIdUsersController.clear();
          userNameDisplayController.clear();
          print('⚠️ No se pudo obtener el usuario logueado');
        }
      } else {
        // 🔥 PARA EDICIÓN: CARGAR DATOS EXISTENTES
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

        String strategyValue = listItem['fkIdStrategies']?.toString() ?? '';
        selectedStrategyId = strategyValue.isNotEmpty ? strategyValue : null;
        fkIdStrategiesController.text = selectedStrategyId ?? '';

        String reportValue = listItem['fkIdReports']?.toString() ?? '';
        selectedReportId = reportValue.isNotEmpty ? reportValue : null;
        fkIdReportsController.text = selectedReportId ?? '';

        String userValue = listItem['fkIdUsers']?.toString() ?? '';
        selectedUserId = userValue.isNotEmpty ? userValue : null;
        fkIdUsersController.text = selectedUserId ?? '';
        
        // 🔥 PARA EDICIÓN: BUSCAR Y MOSTRAR EL NOMBRE DEL USUARIO
        if (selectedUserId != null) {
          final user = myReactController.getListUsers.firstWhere(
            (u) => u['id'].toString() == selectedUserId,
            orElse: () => null,
          );
          if (user != null) {
            userNameDisplayController.text = "${user['firstName']} ${user['lastName']}";
          } else {
            userNameDisplayController.text = selectedUserId!; // Fallback al ID si no encuentra
          }
        } else {
          userNameDisplayController.clear();
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
                      'Éxito',
                      "Se ha creado correctamente la nueva intervención",
                      colorText: Colors.white,
                      backgroundColor: Colors.green,
                    );
                  } else {
                    Get.snackbar(
                      'Error',
                      "Error al crear la nueva intervención",
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
                      'Éxito',
                      "Se ha editado correctamente la intervención",
                      colorText: Colors.white,
                      backgroundColor: Colors.green,
                    );
                  } else {
                    Get.snackbar(
                      'Error',
                      "Error al editar la intervención",
                      colorText: Colors.white,
                      backgroundColor: Colors.red,
                    );
                  }
                }
              },
            ),
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
                    // 🔥 CAMPO FECHA - AUTOMÁTICA Y SOLO LECTURA
                    TextFormField(
                      controller: creationDateController,
                      readOnly: true, // 🔥 SIEMPRE DE SOLO LECTURA
                      decoration: InputDecoration(
                        labelText: 'Fecha y Hora de Creación *',
                        hintText: 'Fecha generada automáticamente',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(
                          Icons.lock_clock,
                          color: Colors.grey,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Este campo es obligatorio';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 16),

                    // Campo para Descripción
                    TextFormField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Descripción *',
                        hintText: 'Ingrese la descripción de la intervención',
                        border: OutlineInputBorder(),
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
                          child: Text(
                            report['description']?.length > 50 
                                ? '${report['description']?.substring(0, 50)}...' 
                                : report['description'] ?? 'Sin descripción',
                          ),
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

                    // 🔥 CAMPO USUARIO - SOLO LECTURA TANTO PARA CREAR COMO EDITAR
                    TextFormField(
                      controller: userNameDisplayController, // 🔥 USAR CONTROLADOR DE NOMBRE
                      readOnly: true, // 🔥 SIEMPRE DE SOLO LECTURA
                      decoration: InputDecoration(
                        labelText: 'Usuario *',
                        hintText: 'Usuario asignado a la intervención',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(
                          Icons.person,
                          color: Colors.grey,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Este campo es obligatorio';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 30),
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