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
          if (myReactController.getListStrategies.isEmpty) {
            fetchAPIStrategies().then((_) => setState(() {}));
          }
          if (myReactController.getListReports.isEmpty) {
            fetchAPIReports().then((_) => setState(() {}));
          }
          if (myReactController.getListUsers.isEmpty) {
            fetchAPIUsers().then((_) => setState(() {}));
          }

          // 🎨 Colores personalizados de íconos (como en el ejemplo del aprendiz)
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
                            DropdownButtonFormField<String>(
                              value: selectedStrategyId,
                              decoration: customDropdownDecoration(
                                  'Estrategia *', icon: Icons.flag),
                              hint: const Text('Seleccione una estrategia'),
                              isExpanded: true,
                              items: myReactController.getListStrategies
                                  .map<DropdownMenuItem<String>>((strategy) {
                                return DropdownMenuItem<String>(
                                  value: strategy['id'].toString(),
                                  child: Text(
                                    strategy['strategy'],
                                    overflow: TextOverflow.visible,
                                    softWrap: true,
                                  ),
                                );
                              }).toList(),
                              selectedItemBuilder: (BuildContext context) {
                                return myReactController.getListStrategies
                                    .map<Widget>((strategy) {
                                  final text = strategy['strategy'] ?? '';
                                  return Text(
                                    text.length > 40
                                        ? '${text.substring(0, 40)}...'
                                        : text,
                                    overflow: TextOverflow.ellipsis,
                                  );
                                }).toList();
                              },
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
                            DropdownButtonFormField<String>(
                              value: selectedReportId,
                              decoration: customDropdownDecoration(
                                  'Reporte *', icon: Icons.report),
                              hint: const Text('Seleccione un reporte'),
                              isExpanded: true,
                              items: myReactController.getListReports
                                  .map<DropdownMenuItem<String>>((report) {
                                return DropdownMenuItem<String>(
                                  value: report['id'].toString(),
                                  child: Text(
                                    report['description'] ?? 'Sin descripción',
                                    overflow: TextOverflow.visible,
                                    softWrap: true,
                                  ),
                                );
                              }).toList(),
                              selectedItemBuilder: (BuildContext context) {
                                return myReactController.getListReports
                                    .map<Widget>((report) {
                                  final desc = report['description'] ?? '';
                                  return Text(
                                    desc.length > 50
                                        ? '${desc.substring(0, 50)}...'
                                        : desc,
                                    overflow: TextOverflow.ellipsis,
                                  );
                                }).toList();
                              },
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
