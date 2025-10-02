import 'package:app_projectretention_711_v1/api/apiRetention.dart';
import 'package:app_projectretention_711_v1/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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

  // Variables para causas
  List<dynamic> selectedCauses = [];
  String? selectedCategoryId;
  String? selectedCauseId;
  List<dynamic> causesByCategory = [];
  bool isLoadingCauses = false;
  bool _causesLoaded = false;   // Se deja Flag o bandera para controlar carga única para mensaje

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
        selectedCauses.clear();

        // Inicializar valores por defecto
        selectedAddressing = null;
        selectedState = null;
        selectedApprenticeId = null;
        selectedUserId = null;
        selectedCreationDate = null;
        selectedCategoryId = null;
        selectedCauseId = null;
        causesByCategory = [];
        _causesLoaded = false; // 🔥 Reset flag para nuevo reporte
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

        // Inicializar selectedCauses como vacío temporalmente, se cargarán en el StatefulBuilder
        selectedCauses = [];
      }

      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        
        // 🔥 NUEVA FUNCIÓN MEJORADA: Cargar causas existentes del reporte - SIN MENSAJE
        Future<void> loadExistingCauses() async {
          if (option == "edit" && !_causesLoaded) {
            try {
              print('🟡 Cargando causas existentes para reporte ID: ${listItem['id']}');
              
              setState(() {
                isLoadingCauses = true;
              });

              final causesReports = await fetchCausesByReport(listItem['id']);
              print('🟡 Relaciones causes_reports encontradas: ${causesReports.length}');
              
              // Extraer solo las causas de las relaciones
              List<dynamic> existingCauses = [];
              for (var causeReport in causesReports) {
                if (causeReport['cause'] != null) {
                  existingCauses.add(causeReport['cause']);
                }
              }
              
              setState(() {
                selectedCauses = existingCauses;
                isLoadingCauses = false;
                _causesLoaded = true; // 🔥 MARCADOR PARA EVITAR CARGA MÚLTIPLE
              });
              
              print('✅ Causas existentes cargadas: ${existingCauses.length}');
              
              // ELIMINADO: Mensaje de snackbar que causaba el bucle, se deja comentado
              // El usuario ya puede ver las causas cargadas en la interfaz

              // if (existingCauses.isNotEmpty) {
              //   Get.snackbar(
              //     'Causas cargadas',
              //     'Se cargaron ${existingCauses.length} causa(s) existentes',
              //     colorText: Colors.white,
              //     backgroundColor: Colors.green,
              //     duration: Duration(seconds: 2),
              //   );
              // }
              
            } catch (e) {
              print('❌ Error al cargar causas existentes: $e');
              setState(() {
                isLoadingCauses = false;
                _causesLoaded = true; // MARCADOR INCLUSO EN ERROR
              });
              // ELIMINAMOS EL MENSAJE DE ERROR | Se deja comentado
              // Get.snackbar(
              //   'Error',
              //   'No se pudieron cargar las causas',
              //   colorText: Colors.white,
              //   backgroundColor: Colors.red,
              // );
            }
          }
        }

        // EJECUTAR LA CARGA SOLO UNA VEZ - CON FLAG DE CONTROL
        if (option == "edit" && !_causesLoaded) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            loadExistingCauses();
          });
        }

        // Función para cargar causas por categoría
        Future<void> loadCausesByCategory(String categoryId) async {
          if (categoryId.isEmpty) return;
          
          setState(() {
            isLoadingCauses = true;
            causesByCategory = [];
            selectedCauseId = null;
          });

          try {
            final causes = await fetchCausesByCategory(int.parse(categoryId));
            setState(() {
              causesByCategory = causes;
              isLoadingCauses = false;
            });
          } catch (e) {
            setState(() {
              isLoadingCauses = false;
            });
            Get.snackbar(
              'Error',
              'No se pudieron cargar las causas',
              colorText: Colors.white,
              backgroundColor: Colors.red,
            );
          }
        }

        // Función para agregar causa a la lista
        void addCause() {
          if (selectedCauseId == null || selectedCauseId!.isEmpty) {
            Get.snackbar(
              'Selección requerida',
              'Por favor seleccione una causa',
              colorText: Colors.white,
              backgroundColor: Colors.orange,
            );
            return;
          }

          final cause = causesByCategory.firstWhere(
            (c) => c['id'].toString() == selectedCauseId,
            orElse: () => null,
          );
          
          if (cause != null) {
            // Verificar si ya existe
            final exists = selectedCauses.any((c) => c['id'] == cause['id']);
            if (!exists) {
              setState(() {
                selectedCauses.add(cause);
              });
              // Limpiar selección
              selectedCauseId = null;
              
              Get.snackbar(
                'Causa agregada',
                'La causa ha sido agregada a la lista',
                colorText: Colors.white,
                backgroundColor: Colors.green,
                duration: Duration(seconds: 1),
              );
            } else {
              Get.snackbar(
                'Causa duplicada',
                'Esta causa ya fue agregada',
                colorText: Colors.white,
                backgroundColor: Colors.orange,
              );
            }
          }
        }

        // Función para eliminar causa de la lista
        void removeCause(int index) {
          setState(() {
            selectedCauses.removeAt(index);
          });
        }

        // 🔥 FUNCIÓN MEJORADA: Buscar nombre de categoría
        String getCategoryName(dynamic cause) {
          try {
            if (cause['category'] != null && cause['category']['name'] != null) {
              return cause['category']['name'];
            }
            
            if (cause['fkIdCategories'] != null) {
              final categoryId = cause['fkIdCategories'];
              final category = myReactController.getListCategories.firstWhere(
                (cat) => cat['id'] == categoryId,
                orElse: () => null,
              );
              return category?['name'] ?? 'N/A';
            }
            
            return 'N/A';
          } catch (e) {
            print('❌ Error al obtener categoría: $e');
            return 'N/A';
          }
        }

        // 🔥 FUNCIÓN PRINCIPAL MEJORADA: Guardar el reporte y las causas
        Future<void> saveReportAndCauses() async {
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

          if (selectedCauses.isEmpty) {
            Get.snackbar(
              'Causas requeridas',
              'Por favor agregue al menos una causa',
              colorText: Colors.white,
              backgroundColor: Colors.orange,
            );
            return;
          }

          bool reportSaved = false;
          int? reportId;

          print('🟡 INICIANDO PROCESO DE GUARDADO...');

          if (option == "new") {
            // Crear nuevo reporte
            print('🟡 CREANDO NUEVO REPORTE...');
            final result = await newReportApi(
              creationDateController.text,
              descriptionController.text,
              selectedAddressing ?? '',
              selectedState ?? '',
              selectedApprenticeId ?? '',
              selectedUserId ?? '',
            );
            
            reportSaved = result?['success'] ?? false;
            reportId = result?['id'];

            print('🟡 Resultado después del fallback:');
            print('🟡 reportSaved: $reportSaved');
            print('🟡 reportId: $reportId');
            
            if (reportId == null) {
              Get.snackbar(
                'Error',
                'No se pudo obtener el ID del reporte creado',
                colorText: Colors.white,
                backgroundColor: Colors.red,
              );
              return;
            }
            
          } else {
            // 🔥 EDITAR REPORTE EXISTENTE - ELIMINAR RELACIONES ANTIGUAS PRIMERO
            print('🟡 EDITANDO REPORTE EXISTENTE ID: ${listItem['id']}');
            
            // 1. Primero eliminar las relaciones causes_reports existentes
            print('🟡 Eliminando relaciones causes_reports existentes...');
            final existingCausesReports = await fetchCausesByReport(listItem['id']);
            
            for (var causeReport in existingCausesReports) {
              await deleteCauseReportApi(causeReport['id']);
            }
            
            // 2. Luego actualizar el reporte
            reportSaved = await editReportApi(
              listItem['id'],
              creationDateController.text,
              descriptionController.text,
              selectedAddressing ?? '',
              selectedState ?? '',
              selectedApprenticeId ?? '',
              selectedUserId ?? '',
            );
            reportId = listItem['id'];
          }

          if (reportSaved && reportId != null) {
            // Guardar las NUEVAS relaciones causes_reports
            bool allCausesSaved = true;
            int savedCount = 0;
            
            print('🟡 GUARDANDO NUEVAS RELACIONES CAUSES_REPORTS...');
            print('🟡 Total de causas a guardar: ${selectedCauses.length}');
            print('🟡 reportId para relaciones: $reportId');
            
            for (var cause in selectedCauses) {
              print('🟡 Intentando guardar causa ID: ${cause['id']}');
              
              final causeSaved = await newCauseReportApi(
                reportId,
                cause['id'],
              );
              
              if (causeSaved) {
                savedCount++;
                print('✅ Causa ${cause['id']} guardada exitosamente');
              } else {
                allCausesSaved = false;
                print('❌ Error al guardar causa ID: ${cause['id']}');
              }
            }

            Get.back();
            
            if (allCausesSaved) {
              Get.snackbar(
                'Éxito',
                option == "new" 
                    ? "Reporte creado con $savedCount causa(s)"
                    : "Reporte actualizado con $savedCount causa(s)",
                colorText: Colors.white,
                backgroundColor: Colors.green,
                duration: Duration(seconds: 3),
              );
            } else {
              Get.snackbar(
                'Advertencia',
                'Reporte guardado pero $savedCount de ${selectedCauses.length} causa(s) se asociaron correctamente',
                colorText: Colors.white,
                backgroundColor: Colors.orange,
                duration: Duration(seconds: 3),
              );
            }
          } else {
            Get.back();
            Get.snackbar(
              'Error',
              option == "new" 
                  ? "Error al crear el reporte"
                  : "Error al actualizar el reporte",
              colorText: Colors.white, 
              backgroundColor: Colors.red,
            );
          }
        }

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
        if (myReactController.getListCategories.isEmpty) {
          fetchAPICategories().then((_) {
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
            child: option == "new" 
                ? Icon(Icons.add) 
                : Icon(Icons.edit),
            onPressed: saveReportAndCauses,
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
                            initialDate: selectedCreationDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );

                          if (pickedDate != null) {
                            // Seleccionar la hora
                            final TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(DateTime.now()),
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

                  SizedBox(height: 16),

                  // Descripción
                  TextFormField(
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Descripción *',
                      hintText: 'Ingrese la descripción del reporte',
                      border: OutlineInputBorder(),
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
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    ),
                    hint: Text('Seleccione un aprendiz'),
                    items: myReactController.getListApprentices
                        .map<DropdownMenuItem<String>>((apprentice) {
                      return DropdownMenuItem<String>(
                        value: apprentice['id'].toString(),
                        child: Text(
                            "${apprentice['firtsName']} ${apprentice['lastName']} - ${apprentice['document']}"),
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
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    ),
                    hint: Text('Seleccione un usuario'),
                    items: myReactController.getListUsers
                        .map<DropdownMenuItem<String>>((user) {
                      return DropdownMenuItem<String>(
                        value: user['id'].toString(),
                        child: Text("${user['firstName']} ${user['lastName']}"),
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

                  // SECCIÓN DE CAUSAS
                  SizedBox(height: 24),
                  Divider(thickness: 2),
                  Text(
                    'Causas del Reporte *',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Dropdown para Categorías
                  DropdownButtonFormField<String>(
                    value: selectedCategoryId,
                    decoration: InputDecoration(
                      labelText: 'Seleccione una categoría',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    ),
                    hint: Text('Seleccione una categoría'),
                    items: myReactController.getListCategories
                        .map<DropdownMenuItem<String>>((category) {
                      return DropdownMenuItem<String>(
                        value: category['id'].toString(),
                        child: Text(category['name']),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCategoryId = newValue;
                        selectedCauseId = null;
                        causesByCategory = [];
                      });
                      if (newValue != null && newValue.isNotEmpty) {
                        loadCausesByCategory(newValue);
                      }
                    },
                  ),

                  SizedBox(height: 16),

                  // Dropdown para Causas
                  DropdownButtonFormField<String>(
                    value: selectedCauseId,
                    decoration: InputDecoration(
                      labelText: 'Seleccione una causa',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    ),
                    hint: isLoadingCauses 
                        ? Text('Cargando causas...')
                        : Text(selectedCategoryId == null 
                            ? 'Primero seleccione una categoría'
                            : 'Seleccione una causa'),
                    items: isLoadingCauses
                        ? [DropdownMenuItem(value: null, child: Text('Cargando...'))]
                        : causesByCategory.map<DropdownMenuItem<String>>((cause) {
                            return DropdownMenuItem<String>(
                              value: cause['id'].toString(),
                              child: Text(cause['cause']),
                            );
                          }).toList(),
                    onChanged: isLoadingCauses ? null : (String? newValue) {
                      setState(() {
                        selectedCauseId = newValue;
                      });
                    },
                  ),

                  SizedBox(height: 16),

                  // Botón para agregar causa
                  ElevatedButton(
                    onPressed: addCause,
                    child: Text('Agregar Causa a la Lista'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),

                  SizedBox(height: 16),

                  // 🔥 LISTA DE CAUSAS AGREGADAS - MEJORADA
                  Text(
                    'Causas Agregadas:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),

                  isLoadingCauses && option == "edit"
                      ? Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 8),
                              Text(
                                'Cargando causas existentes...',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.blue[700]),
                              ),
                            ],
                          ),
                        )
                      : selectedCauses.isEmpty
                          ? Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                option == "new" 
                                    ? 'No hay causas agregadas. Seleccione una categoría y causa, luego presione "Agregar Causa a la Lista".'
                                    : 'No hay causas asociadas a este reporte. Agregue causas usando los controles arriba.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            )
                          : Column(
                              children: [
                                Text(
                                  'Total: ${selectedCauses.length} causa(s) ${option == "edit" ? "asociadas" : "agregada(s)"}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.green,
                                  ),
                                ),
                                SizedBox(height: 8),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: selectedCauses.length,
                                  itemBuilder: (context, index) {
                                    final cause = selectedCauses[index];
                                    final categoryName = getCategoryName(cause); // 🔥 USAR FUNCIÓN MEJORADA
                                    
                                    return Card(
                                      margin: EdgeInsets.symmetric(vertical: 4),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: option == "edit" ? Colors.orange : Colors.blue,
                                          child: Text(
                                            '${index + 1}',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        title: Text(
                                          cause['cause'],
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        subtitle: Text(
                                          'Categoría: $categoryName', // 🔥 USAR NOMBRE CORRECTO
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        trailing: IconButton(
                                          icon: Icon(Icons.delete, color: Colors.red),
                                          onPressed: () => removeCause(index),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),

                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        );
      });
    },
  );
}