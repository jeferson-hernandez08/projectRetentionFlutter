import 'package:app_projectretention_711_v1/api/apiRetention.dart';
import 'package:app_projectretention_711_v1/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Para formatear fechas

final TextEditingController fileController = TextEditingController();
final TextEditingController trainingStartController = TextEditingController();
final TextEditingController trainingEndController = TextEditingController();
final TextEditingController practiceStartController = TextEditingController();
final TextEditingController practiceEndController = TextEditingController();
final TextEditingController managerNameController = TextEditingController();
final TextEditingController shiftController = TextEditingController();
final TextEditingController modalityController = TextEditingController();
final TextEditingController trainingProgramIdController = TextEditingController();

modalEditNewGroup(context, option, dynamic listItem) {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? selectedShift;
  String? selectedModality;
  String? selectedTrainingProgramId;

  DateTime? selectedTrainingStart;
  DateTime? selectedTrainingEnd;
  DateTime? selectedPracticeStart;
  DateTime? selectedPracticeEnd;

  Future<void> _selectDate(
      BuildContext context,
      TextEditingController controller,
      Function(DateTime?) onDateSelected) async {
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
    backgroundColor: Colors.transparent,
    builder: (context) {
      if (option == "new") {
        fileController.clear();
        trainingStartController.clear();
        trainingEndController.clear();
        practiceStartController.clear();
        practiceEndController.clear();
        managerNameController.clear();
        shiftController.clear();
        modalityController.clear();
        trainingProgramIdController.clear();
      } else {
        fileController.text = listItem['file'] ?? '';
        managerNameController.text = listItem['managerName'] ?? '';
        selectedShift = listItem['shift']?.toString();
        selectedModality = listItem['modality']?.toString();
        selectedTrainingProgramId =
            listItem['fkIdTrainingPrograms']?.toString();

        trainingStartController.text = listItem['trainingStart'] ?? '';
        trainingEndController.text = listItem['trainingEnd'] ?? '';
        practiceStartController.text = listItem['practiceStart'] ?? '';
        practiceEndController.text = listItem['practiceEnd'] ?? '';
      }

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          if (myReactController.getListTrainingPrograms.isEmpty) {
            fetchAPITrainingPrograms().then((_) => setState(() {}));
          }

          // 🎨 Estilo de campos reutilizable con colores por ícono
          InputDecoration customInputDecoration(String label, {IconData? icon}) {
            Color iconColor;

            switch (icon) {
              case Icons.folder_copy:
                iconColor = Colors.blueAccent;
                break;
              case Icons.person:
                iconColor = Colors.deepPurple;
                break;
              case Icons.calendar_today:
              case Icons.calendar_today_outlined:
              case Icons.date_range:
                iconColor = Colors.teal;
                break;
              case Icons.play_circle_outline:
                iconColor = Colors.green;
                break;
              case Icons.stop_circle_outlined:
                iconColor = Colors.redAccent;
                break;
              case Icons.access_time:
                iconColor = Colors.orangeAccent;
                break;
              case Icons.school:
                iconColor = Colors.cyan;
                break;
              case Icons.book:
                iconColor = Colors.amber;
                break;
              default:
                iconColor = const Color.fromARGB(255, 7, 25, 83);
            }

            return InputDecoration(
              labelText: label,
              prefixIcon: icon != null ? Icon(icon, color: iconColor) : null,
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

          // 🔹 Función para obtener el nombre del programa seleccionado
          String? getSelectedProgramName() {
            if (selectedTrainingProgramId == null) return null;
            final program = myReactController.getListTrainingPrograms.firstWhere(
              (p) => p['id'].toString() == selectedTrainingProgramId,
              orElse: () => {'name': ''},
            );
            return program['name'];
          }

          return Scaffold(
            backgroundColor: const Color(0xFFF5F5F5),
            appBar: AppBar(
              title: Text(
                (option == "new") ? 'Nuevo Grupo' : 'Editar Grupo',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: const Color.fromARGB(255, 7, 25, 83),
              foregroundColor: Colors.white,
              centerTitle: true,
            ),
            floatingActionButton: FloatingActionButton.extended(
              backgroundColor: option == "new"
                  ? const Color(0xFF00BFFF) // 💙 Celeste para "Crear"
                  : Colors.orange,          // 🟧 Naranja para "Editar"
              foregroundColor: Colors.white,
              icon: Icon(option == "new" ? Icons.add : Icons.edit),
              label: Text(option == "new" ? 'Crear' : 'Editar'),
              onPressed: () async {
                if (!_formKey.currentState!.validate()) {
                  Get.snackbar(
                    'Campos incompletos',
                    'Por favor complete todos los campos obligatorios',
                    colorText: Colors.white,
                    backgroundColor: const Color.fromARGB(255, 23, 214, 214),
                  );
                  return;
                }

                bool resp;
                if (option == "new") {
                  resp = await newGroupApi(
                    fileController.text,
                    trainingStartController.text,
                    trainingEndController.text,
                    practiceStartController.text,
                    practiceEndController.text,
                    managerNameController.text,
                    selectedShift ?? '',
                    selectedModality ?? '',
                    selectedTrainingProgramId ?? '',
                  );
                  Get.back();
                  Get.snackbar(
                    'Mensaje',
                    resp
                        ? 'Se ha añadido correctamente un nuevo grupo'
                        : 'Error al agregar el nuevo grupo',
                    colorText: Colors.white,
                    backgroundColor:
                        resp ? Colors.green : Colors.red, // ✅ Igual que en el ejemplo
                  );
                } else {
                  resp = await editGroupApi(
                    listItem['id'],
                    fileController.text,
                    trainingStartController.text,
                    trainingEndController.text,
                    practiceStartController.text,
                    practiceEndController.text,
                    managerNameController.text,
                    selectedShift ?? '',
                    selectedModality ?? '',
                    selectedTrainingProgramId ?? '',
                  );
                  Get.back();
                  Get.snackbar(
                    'Mensaje',
                    resp
                        ? 'Se ha editado correctamente el grupo'
                        : 'Error al editar el grupo',
                    colorText: Colors.white,
                    backgroundColor:
                        resp ? Colors.green : Colors.red, // ✅ Igual que en el ejemplo
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
                              controller: fileController,
                              decoration: customInputDecoration('Ficha *',
                                  icon: Icons.folder_copy),
                              validator: (v) => (v == null || v.isEmpty)
                                  ? 'Campo obligatorio'
                                  : null,
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: managerNameController,
                              decoration: customInputDecoration(
                                  'Nombre del Gestor *',
                                  icon: Icons.person),
                              validator: (v) => (v == null || v.isEmpty)
                                  ? 'Campo obligatorio'
                                  : null,
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: trainingStartController,
                              readOnly: true,
                              decoration: customInputDecoration(
                                  'Inicio Etapa Lectiva',
                                  icon: Icons.calendar_today).copyWith(
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.date_range,
                                      color: Colors.teal),
                                  onPressed: () => _selectDate(context,
                                      trainingStartController, (date) {
                                    setState(() {
                                      selectedTrainingStart = date;
                                    });
                                  }),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: trainingEndController,
                              readOnly: true,
                              decoration: customInputDecoration(
                                  'Fin Etapa Lectiva',
                                  icon: Icons.calendar_today_outlined).copyWith(
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.date_range,
                                      color: Colors.teal),
                                  onPressed: () => _selectDate(
                                      context, trainingEndController, (date) {
                                    setState(() {
                                      selectedTrainingEnd = date;
                                    });
                                  }),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: practiceStartController,
                              readOnly: true,
                              decoration: customInputDecoration(
                                  'Inicio Etapa Productiva',
                                  icon: Icons.play_circle_outline).copyWith(
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.date_range,
                                      color: Colors.teal),
                                  onPressed: () => _selectDate(
                                      context, practiceStartController, (date) {
                                    setState(() {
                                      selectedPracticeStart = date;
                                    });
                                  }),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: practiceEndController,
                              readOnly: true,
                              decoration: customInputDecoration(
                                  'Fin Etapa Productiva',
                                  icon: Icons.stop_circle_outlined).copyWith(
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.date_range,
                                      color: Colors.teal),
                                  onPressed: () => _selectDate(
                                      context, practiceEndController, (date) {
                                    setState(() {
                                      selectedPracticeEnd = date;
                                    });
                                  }),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            DropdownButtonFormField<String>(
                              value: selectedShift,
                              decoration: customInputDecoration('Jornada *',
                                  icon: Icons.access_time),
                              items: const [
                                DropdownMenuItem(
                                    value: 'Diurna', child: Text('Diurna')),
                                DropdownMenuItem(
                                    value: 'Mixta', child: Text('Mixta')),
                                DropdownMenuItem(
                                    value: 'Nocturna',
                                    child: Text('Nocturna')),
                              ],
                              onChanged: (val) {
                                setState(() {
                                  selectedShift = val;
                                });
                              },
                              validator: (v) => (v == null || v.isEmpty)
                                  ? 'Campo obligatorio'
                                  : null,
                            ),
                            const SizedBox(height: 10),
                            DropdownButtonFormField<String>(
                              value: selectedModality,
                              decoration: customInputDecoration('Modalidad *',
                                  icon: Icons.school),
                              items: const [
                                DropdownMenuItem(
                                    value: 'Presencial',
                                    child: Text('Presencial')),
                                DropdownMenuItem(
                                    value: 'Virtual', child: Text('Virtual')),
                              ],
                              onChanged: (val) {
                                setState(() {
                                  selectedModality = val;
                                });
                              },
                              validator: (v) => (v == null || v.isEmpty)
                                  ? 'Campo obligatorio'
                                  : null,
                            ),
                            const SizedBox(height: 10),

                            // 🔹 Campo mejorado: muestra nombre completo al abrir, pero truncado dentro
                            DropdownButtonFormField<String>(
                              value: selectedTrainingProgramId,
                              decoration: customInputDecoration(
                                'Programa de Formación *',
                                icon: Icons.book,
                              ),
                              selectedItemBuilder: (BuildContext context) {
                                return myReactController
                                    .getListTrainingPrograms
                                    .map<Widget>((program) {
                                  return SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: Text(
                                      program['name'] ?? 'Sin nombre',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  );
                                }).toList();
                              },
                              items: myReactController.getListTrainingPrograms
                                  .map<DropdownMenuItem<String>>((program) {
                                return DropdownMenuItem<String>(
                                  value: program['id'].toString(),
                                  child: Text(program['name'] ?? 'Sin nombre'),
                                );
                              }).toList(),
                              onChanged: (val) {
                                setState(() {
                                  selectedTrainingProgramId = val;
                                });
                              },
                              validator: (v) => (v == null || v.isEmpty)
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
