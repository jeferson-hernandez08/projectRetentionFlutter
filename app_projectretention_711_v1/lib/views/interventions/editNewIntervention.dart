import 'package:app_projectretention_711_v1/api/apiRetention.dart';
import 'package:app_projectretention_711_v1/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Para formatear fechas

// Controladores
final TextEditingController creationDateController = TextEditingController();
final TextEditingController descriptionController = TextEditingController();
final TextEditingController fkIdStrategiesController = TextEditingController();
final TextEditingController fkIdReportsController = TextEditingController();
final TextEditingController fkIdUsersController = TextEditingController();
final TextEditingController userNameDisplayController = TextEditingController();

modalEditNewIntervention(context, option, dynamic listItem) {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? selectedStrategyId;
  String? selectedReportId;
  String? selectedUserId;
  DateTime? selectedCreationDate;

  // 🔍 CONTROLADORES DE BÚSQUEDA
  final TextEditingController strategySearchController = TextEditingController();
  final TextEditingController reportSearchController = TextEditingController();
  
  // 🔍 LISTAS FILTRADAS
  List<dynamic> filteredStrategies = [];
  List<dynamic> filteredReports = [];

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      if (option == "new") {
        selectedCreationDate = DateTime.now();
        creationDateController.text =
            DateFormat('yyyy-MM-dd HH:mm:ss').format(selectedCreationDate!);
        descriptionController.clear();
        fkIdStrategiesController.clear();
        fkIdReportsController.clear();
        fkIdUsersController.clear();
        userNameDisplayController.clear();

        final currentUser = myReactController.getUser;
        if (currentUser != null && currentUser['id'] != null) {
          selectedUserId = currentUser['id'].toString();
          fkIdUsersController.text = selectedUserId!;
          userNameDisplayController.text =
              "${currentUser['firstName']} ${currentUser['lastName']}";
        }
      } else {
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

        selectedStrategyId =
            listItem['fkIdStrategies']?.toString().isNotEmpty == true
                ? listItem['fkIdStrategies'].toString()
                : null;
        fkIdStrategiesController.text = selectedStrategyId ?? '';

        selectedReportId =
            listItem['fkIdReports']?.toString().isNotEmpty == true
                ? listItem['fkIdReports'].toString()
                : null;
        fkIdReportsController.text = selectedReportId ?? '';

        selectedUserId = listItem['fkIdUsers']?.toString();
        fkIdUsersController.text = selectedUserId ?? '';

        if (selectedUserId != null) {
          final user = myReactController.getListUsers.firstWhere(
            (u) => u['id'].toString() == selectedUserId,
            orElse: () => null,
          );
          userNameDisplayController.text = user != null
              ? "${user['firstName']} ${user['lastName']}"
              : selectedUserId!;
        }
      }

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          
          // 🔍 FUNCIÓN: Filtrar estrategias (CON PROTECCIÓN PARA VALOR SELECCIONADO)
          void filterStrategies(String query) {
            setState(() {
              if (query.isEmpty) {
                filteredStrategies = myReactController.getListStrategies;
              } else {
                filteredStrategies = myReactController.getListStrategies.where((strategy) {
                  final strategyName = strategy['strategy'].toString().toLowerCase();
                  final searchLower = query.toLowerCase();
                  return strategyName.contains(searchLower);
                }).toList();

                // 🔥 CRÍTICO: Si hay un valor seleccionado, asegurarse de que esté en la lista filtrada
                if (selectedStrategyId != null && selectedStrategyId!.isNotEmpty) {
                  final selectedExists = filteredStrategies.any(
                    (strategy) => strategy['id'].toString() == selectedStrategyId
                  );
                  
                  if (!selectedExists) {
                    // Buscar el item seleccionado en la lista completa y agregarlo
                    final selectedItem = myReactController.getListStrategies.firstWhere(
                      (strategy) => strategy['id'].toString() == selectedStrategyId,
                      orElse: () => null,
                    );
                    if (selectedItem != null) {
                      filteredStrategies.insert(0, selectedItem);
                    }
                  }
                }
              }
            });
          }

          // 🔍 FUNCIÓN: Filtrar reportes (CON PROTECCIÓN PARA VALOR SELECCIONADO)
          void filterReports(String query) {
            setState(() {
              if (query.isEmpty) {
                filteredReports = myReactController.getListReports;
              } else {
                filteredReports = myReactController.getListReports.where((report) {
                  final description = report['description']?.toString().toLowerCase() ?? '';
                  final searchLower = query.toLowerCase();
                  return description.contains(searchLower);
                }).toList();

                // 🔥 CRÍTICO: Si hay un valor seleccionado, asegurarse de que esté en la lista filtrada
                if (selectedReportId != null && selectedReportId!.isNotEmpty) {
                  final selectedExists = filteredReports.any(
                    (report) => report['id'].toString() == selectedReportId
                  );
                  
                  if (!selectedExists) {
                    // Buscar el item seleccionado en la lista completa y agregarlo
                    final selectedItem = myReactController.getListReports.firstWhere(
                      (report) => report['id'].toString() == selectedReportId,
                      orElse: () => null,
                    );
                    if (selectedItem != null) {
                      filteredReports.insert(0, selectedItem);
                    }
                  }
                }
              }
            });
          }

          // 🔥 INICIALIZAR LISTAS FILTRADAS
          if (filteredStrategies.isEmpty && myReactController.getListStrategies.isNotEmpty) {
            filteredStrategies = myReactController.getListStrategies;
          }
          if (filteredReports.isEmpty && myReactController.getListReports.isNotEmpty) {
            filteredReports = myReactController.getListReports;
          }

          // Cargar datos si no están en memoria
          if (myReactController.getListStrategies.isEmpty) {
            fetchAPIStrategies().then((_) => setState(() {
              filteredStrategies = myReactController.getListStrategies;
            }));
          }
          if (myReactController.getListReports.isEmpty) {
            fetchAPIReports().then((_) => setState(() {
              filteredReports = myReactController.getListReports;
            }));
          }
          if (myReactController.getListUsers.isEmpty) {
            fetchAPIUsers().then((_) => setState(() {}));
          }

          // 📏 FUNCIÓN: Truncar texto largo
          String truncateText(String text, int maxLength) {
            if (text.length <= maxLength) {
              return text;
            }
            return '${text.substring(0, maxLength)}...';
          }

          // 🎨 Colores personalizados de íconos
          InputDecoration customInputDecoration(String label, {IconData? icon}) {
            Color iconColor;
            switch (icon) {
              case Icons.lock_clock:
                iconColor = Colors.blueAccent;
                break;
              case Icons.description:
                iconColor = Colors.teal;
                break;
              case Icons.flag:
                iconColor = Colors.orangeAccent;
                break;
              case Icons.report:
                iconColor = Colors.pinkAccent;
                break;
              case Icons.person:
                iconColor = Colors.green;
                break;
              default:
                iconColor = const Color.fromARGB(255, 7, 25, 83);
            }
            return InputDecoration(
              labelText: label,
              prefixIcon:
                  icon != null ? Icon(icon, color: iconColor) : null,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            );
          }

          InputDecoration customDropdownDecoration(String label, {IconData? icon}) {
            Color iconColor;
            switch (icon) {
              case Icons.flag:
                iconColor = Colors.orangeAccent;
                break;
              case Icons.report:
                iconColor = Colors.pinkAccent;
                break;
              default:
                iconColor = const Color.fromARGB(255, 7, 25, 83);
            }
            return InputDecoration(
              labelText: label,
              prefixIcon:
                  icon != null ? Icon(icon, color: iconColor) : null,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            );
          }

          return Scaffold(
            backgroundColor: const Color(0xFFF5F5F5),
            appBar: AppBar(
              title: Text(
                (option == "new")
                    ? 'Nueva Intervención'
                    : 'Editar Intervención',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: const Color.fromARGB(255, 7, 25, 83),
              foregroundColor: Colors.white,
              centerTitle: true,
            ),
            floatingActionButton: FloatingActionButton.extended(
              backgroundColor: option == "new"
                  ? const Color(0xFF00BFFF) // 💙 Celeste para "Crear"
                  : Colors.orange, // 🟧 Naranja para "Editar"
              foregroundColor: Colors.white,
              icon: Icon(option == "new" ? Icons.add : Icons.edit),
              label: Text(option == "new" ? 'Crear' : 'Editar'),
              onPressed: () async {
                if (!_formKey.currentState!.validate()) {
                  Get.snackbar(
                    'Campos incompletos',
                    'Por favor complete todos los campos obligatorios',
                    colorText: Colors.white,
                    backgroundColor:
                        const Color.fromARGB(255, 23, 214, 214), // 💬 Celeste
                  );
                  return;
                }

                bool resp;
                if (option == "new") {
                  resp = await newInterventionApi(
                    creationDateController.text,
                    descriptionController.text,
                    selectedStrategyId ?? '',
                    selectedReportId ?? '',
                    selectedUserId ?? '',
                  );
                  Get.back();
                  Get.snackbar(
                    'Mensaje',
                    resp
                        ? 'Se ha creado correctamente la intervención'
                        : 'Error al crear la intervención',
                    colorText: Colors.white,
                    backgroundColor:
                        resp ? Colors.green : Colors.red, // ✅❌ colores de mensaje
                  );
                } else {
                  resp = await editInterventionApi(
                    listItem['id'],
                    creationDateController.text,
                    descriptionController.text,
                    selectedStrategyId ?? '',
                    selectedReportId ?? '',
                    selectedUserId ?? '',
                  );
                  Get.back();
                  Get.snackbar(
                    'Mensaje',
                    resp
                        ? 'Se ha editado correctamente la intervención'
                        : 'Error al editar la intervención',
                    colorText: Colors.white,
                    backgroundColor:
                        resp ? Colors.green : Colors.red, // ✅❌ colores de mensaje
                  );
                }
              },
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: creationDateController,
                              readOnly: true,
                              decoration: customInputDecoration(
                                'Fecha y Hora de Creación *',
                                icon: Icons.lock_clock,
                              ),
                              validator: (v) =>
                                  (v == null || v.isEmpty)
                                      ? 'Campo obligatorio'
                                      : null,
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: descriptionController,
                              decoration: customInputDecoration(
                                  'Descripción *',
                                  icon: Icons.description),
                              maxLines: 3,
                              validator: (v) =>
                                  (v == null || v.isEmpty)
                                      ? 'Campo obligatorio'
                                      : null,
                            ),
                            const SizedBox(height: 10),

                            // 🔍 BUSCADOR DE ESTRATEGIAS
                            TextField(
                              controller: strategySearchController,
                              decoration: InputDecoration(
                                labelText: 'Buscar estrategia',
                                prefixIcon: Icon(Icons.search, color: Colors.orangeAccent),
                                suffixIcon: strategySearchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: Icon(Icons.clear, size: 20),
                                        onPressed: () {
                                          setState(() {
                                            strategySearchController.clear();
                                            filterStrategies('');
                                          });
                                        },
                                      )
                                    : null,
                                filled: true,
                                fillColor: Colors.orange[50],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              ),
                              onChanged: filterStrategies,
                            ),
                            const SizedBox(height: 8),

                            // 🎯 Dropdown para Estrategia - TEXTO COMPLETO EN MENÚ, TRUNCADO SELECCIONADO
                            DropdownButtonFormField<String>(
                              value: selectedStrategyId,
                              decoration: customDropdownDecoration(
                                  'Estrategia *', icon: Icons.flag),
                              hint: const Text('Seleccione una estrategia'),
                              isExpanded: true,
                              selectedItemBuilder: (BuildContext context) {
                                // TEXTO TRUNCADO para el valor seleccionado en el formulario
                                return filteredStrategies
                                    .map<Widget>((strategy) {
                                  final text = strategy['strategy'] ?? '';
                                  return Text(
                                    truncateText(text, 40),
                                    overflow: TextOverflow.ellipsis,
                                  );
                                }).toList();
                              },
                              items: filteredStrategies
                                  .map<DropdownMenuItem<String>>((strategy) {
                                // TEXTO COMPLETO en el menú desplegable
                                return DropdownMenuItem<String>(
                                  value: strategy['id'].toString(),
                                  child: Text(strategy['strategy']), // Sin truncar
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedStrategyId = newValue;
                                  fkIdStrategiesController.text =
                                      newValue ?? '';
                                });
                              },
                              validator: (value) => value == null || value.isEmpty
                                  ? 'Campo obligatorio'
                                  : null,
                            ),
                            const SizedBox(height: 10),

                            // 🔍 BUSCADOR DE REPORTES
                            TextField(
                              controller: reportSearchController,
                              decoration: InputDecoration(
                                labelText: 'Buscar reporte',
                                prefixIcon: Icon(Icons.search, color: Colors.pinkAccent),
                                suffixIcon: reportSearchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: Icon(Icons.clear, size: 20),
                                        onPressed: () {
                                          setState(() {
                                            reportSearchController.clear();
                                            filterReports('');
                                          });
                                        },
                                      )
                                    : null,
                                filled: true,
                                fillColor: Colors.pink[50],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              ),
                              onChanged: filterReports,
                            ),
                            const SizedBox(height: 8),

                            // 🎯 Dropdown para Reporte - TEXTO COMPLETO EN MENÚ, TRUNCADO SELECCIONADO
                            DropdownButtonFormField<String>(
                              value: selectedReportId,
                              decoration: customDropdownDecoration(
                                  'Reporte *', icon: Icons.report),
                              hint: const Text('Seleccione un reporte'),
                              isExpanded: true,
                              selectedItemBuilder: (BuildContext context) {
                                // TEXTO TRUNCADO para el valor seleccionado en el formulario
                                return filteredReports
                                    .map<Widget>((report) {
                                  final desc = report['description'] ?? 'Sin descripción';
                                  return Text(
                                    truncateText(desc, 50),
                                    overflow: TextOverflow.ellipsis,
                                  );
                                }).toList();
                              },
                              items: filteredReports
                                  .map<DropdownMenuItem<String>>((report) {
                                // TEXTO COMPLETO en el menú desplegable
                                return DropdownMenuItem<String>(
                                  value: report['id'].toString(),
                                  child: Text(
                                    report['description'] ?? 'Sin descripción',
                                  ), // Sin truncar
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedReportId = newValue;
                                  fkIdReportsController.text =
                                      newValue ?? '';
                                });
                              },
                              validator: (value) => value == null || value.isEmpty
                                  ? 'Campo obligatorio'
                                  : null,
                            ),
                            const SizedBox(height: 10),

                            TextFormField(
                              controller: userNameDisplayController,
                              readOnly: true,
                              decoration: customInputDecoration(
                                  'Usuario *', icon: Icons.person),
                              validator: (v) =>
                                  (v == null || v.isEmpty)
                                      ? 'Campo obligatorio'
                                      : null,
                            ),
                          ],
                        ),
                      ),
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