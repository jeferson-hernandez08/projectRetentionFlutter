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
  // Creamos una clave global para el formulario
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Variables para los valores seleccionados en los dropdowns
  String? selectedShift;
  String? selectedModality;
  String? selectedTrainingProgramId;
  DateTime? selectedTrainingStart;
  DateTime? selectedTrainingEnd;
  DateTime? selectedPracticeStart;
  DateTime? selectedPracticeEnd;

  // Función para seleccionar fecha
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
        // Limpiar campos para nuevo grupo
        fileController.clear();
        trainingStartController.clear();
        trainingEndController.clear();
        practiceStartController.clear();
        practiceEndController.clear();
        managerNameController.clear();
        shiftController.clear();
        modalityController.clear();
        trainingProgramIdController.clear();
        
        // Inicializar valores por defecto
        selectedShift = null;
        selectedModality = null;
        selectedTrainingProgramId = null;
        selectedTrainingStart = null;
        selectedTrainingEnd = null;
        selectedPracticeStart = null;
        selectedPracticeEnd = null;
      } else {
        // Cargar datos existentes para editar
        fileController.text = listItem['file'] ?? '';
        managerNameController.text = listItem['managerName'] ?? '';
        
        // Establecer valores para los dropdowns con validación
        String shiftValue = listItem['shift']?.toString() ?? '';
        selectedShift = shiftValue; // Usamos el valor directamente ya que coinciden
        shiftController.text = selectedShift ?? '';
        
        String modalityValue = listItem['modality']?.toString() ?? '';
        selectedModality = modalityValue; // Usamos el valor directamente ya que coinciden
        modalityController.text = selectedModality ?? '';
        
        String trainingProgramValue = listItem['fkIdTrainingPrograms']?.toString() ?? '';
        selectedTrainingProgramId = trainingProgramValue.isNotEmpty ? trainingProgramValue : null;
        trainingProgramIdController.text = selectedTrainingProgramId ?? '';
        
        // Procesar fechas si existen
        if (listItem['trainingStart'] != null) {
          try {
            selectedTrainingStart = DateTime.parse(listItem['trainingStart']);
            trainingStartController.text = DateFormat('yyyy-MM-dd').format(selectedTrainingStart!);
          } catch (e) {
            selectedTrainingStart = null;
          }
        }
        
        if (listItem['trainingEnd'] != null) {
          try {
            selectedTrainingEnd = DateTime.parse(listItem['trainingEnd']);
            trainingEndController.text = DateFormat('yyyy-MM-dd').format(selectedTrainingEnd!);
          } catch (e) {
            selectedTrainingEnd = null;
          }
        }
        
        if (listItem['practiceStart'] != null) {
          try {
            selectedPracticeStart = DateTime.parse(listItem['practiceStart']);
            practiceStartController.text = DateFormat('yyyy-MM-dd').format(selectedPracticeStart!);
          } catch (e) {
            selectedPracticeStart = null;
          }
        }
        
        if (listItem['practiceEnd'] != null) {
          try {
            selectedPracticeEnd = DateTime.parse(listItem['practiceEnd']);
            practiceEndController.text = DateFormat('yyyy-MM-dd').format(selectedPracticeEnd!);
          } catch (e) {
            selectedPracticeEnd = null;
          }
        }
      }

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          // Capturar los programas de formación solo si no están en memoria
          if (myReactController.getListTrainingPrograms.isEmpty) {
            fetchAPITrainingPrograms().then((_) {
              setState(() {}); // Refresca cuando termine la API
            });
          }

          return Scaffold(
            appBar: AppBar(
              title: (option == "new") ? Text('Crear Nuevo Grupo') : Text('Editar Grupo'),
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
                  // Crear nuevo grupo
                  bool resp = await newGroupApi(
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
                  if(resp) {
                    Get.snackbar(
                      'Mensaje', "Se ha añadido correctamente un nuevo grupo", 
                      colorText: Colors.white,
                      backgroundColor: Colors.green
                    );
                  } else {
                    Get.snackbar(
                      'Mensaje', "Error al agregar el nuevo grupo", 
                      colorText: Colors.white,
                      backgroundColor: Colors.red
                    );
                  }
                } else {   
                  // Editar grupo existente
                  bool resp = await editGroupApi(
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
                  if(resp) {
                    Get.snackbar(
                      'Mensaje', "Se ha editado correctamente el grupo", 
                      colorText: Colors.green,
                      backgroundColor: Colors.greenAccent
                    );
                  } else {
                    Get.snackbar('Mensaje', "Error al editar el grupo", colorText: Colors.red);
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
                        controller: fileController,
                        decoration: InputDecoration(
                          labelText: 'Ficha *',
                          hintText: 'Ingrese la ficha del grupo',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Este campo es obligatorio';
                          }
                          return null;
                        },
                      ),

                      // Campo de fecha de inicio de formación
                      TextFormField(
                        controller: trainingStartController,
                        decoration: InputDecoration(
                          labelText: 'Fecha inicio formación',
                          hintText: 'Seleccione la fecha',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () => _selectDate(context, trainingStartController, (date) {
                              setState(() {
                                selectedTrainingStart = date;
                              });
                            }),
                          ),
                        ),
                        readOnly: true,
                      ),

                      // Campo de fecha de fin de formación
                      TextFormField(
                        controller: trainingEndController,
                        decoration: InputDecoration(
                          labelText: 'Fecha fin formación',
                          hintText: 'Seleccione la fecha',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () => _selectDate(context, trainingEndController, (date) {
                              setState(() {
                                selectedTrainingEnd = date;
                              });
                            }),
                          ),
                        ),
                        readOnly: true,
                      ),

                      // Campo de fecha de inicio de práctica
                      TextFormField(
                        controller: practiceStartController,
                        decoration: InputDecoration(
                          labelText: 'Fecha inicio práctica',
                          hintText: 'Seleccione la fecha',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () => _selectDate(context, practiceStartController, (date) {
                              setState(() {
                                selectedPracticeStart = date;
                              });
                            }),
                          ),
                        ),
                        readOnly: true,
                      ),

                      // Campo de fecha de fin de práctica
                      TextFormField(
                        controller: practiceEndController,
                        decoration: InputDecoration(
                          labelText: 'Fecha fin práctica',
                          hintText: 'Seleccione la fecha',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () => _selectDate(context, practiceEndController, (date) {
                              setState(() {
                                selectedPracticeEnd = date;
                              });
                            }),
                          ),
                        ),
                        readOnly: true,
                      ),

                      TextFormField(
                        controller: managerNameController,
                        decoration: InputDecoration(
                          labelText: 'Nombre del manager *',
                          hintText: 'Ingrese el nombre del manager',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Este campo es obligatorio';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 16),

                      // Dropdown para Jornada - ACTUALIZADO
                      DropdownButtonFormField<String>(
                        value: selectedShift,
                        decoration: InputDecoration(
                          labelText: 'Jornada *',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        ),
                        hint: Text('Seleccione la jornada'),
                        items: [
                          DropdownMenuItem(
                            value: 'Diurna',
                            child: Text('Diurna'),
                          ),
                          DropdownMenuItem(
                            value: 'Mixta',
                            child: Text('Mixta'),
                          ),
                          DropdownMenuItem(
                            value: 'Nocturna',
                            child: Text('Nocturna'),
                          ),
                        ],
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedShift = newValue;
                            shiftController.text = newValue ?? '';
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

                      // Dropdown para Modalidad - ACTUALIZADO
                      DropdownButtonFormField<String>(
                        value: selectedModality,
                        decoration: InputDecoration(
                          labelText: 'Modalidad *',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        ),
                        hint: Text('Seleccione la modalidad'),
                        items: [
                          DropdownMenuItem(
                            value: 'Presencial',
                            child: Text('Presencial'),
                          ),
                          DropdownMenuItem(
                            value: 'Virtual',
                            child: Text('Virtual'),
                          ),
                        ],
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedModality = newValue;
                            modalityController.text = newValue ?? '';
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

                      // Dropdown para Programa de Formación
                      DropdownButtonFormField<String>(
                        value: selectedTrainingProgramId,
                        decoration: InputDecoration(
                          labelText: 'Programa de Formación *',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        ),
                        hint: Text('Seleccione un programa de formación'),
                        items: myReactController.getListTrainingPrograms.map<DropdownMenuItem<String>>((program) {
                          return DropdownMenuItem<String>(
                            value: program['id'].toString(),
                            child: Text(program['name'] ?? 'Sin nombre'),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedTrainingProgramId = newValue;
                            trainingProgramIdController.text = newValue ?? '';
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
        }
      );
    }
  );
}