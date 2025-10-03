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
final TextEditingController userNameDisplayController = TextEditingController();

modalEditNewReport(context, option, dynamic listItem) {
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
  bool _causesLoaded = false;

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) {
      if (option == "new") {
        // Fecha y hora actual automáticamente 
        selectedCreationDate = DateTime.now();
        creationDateController.text = 
            DateFormat('yyyy-MM-dd HH:mm:ss').format(selectedCreationDate!);

        // Limpiar campos para nuevo reporte
        descriptionController.clear();
        addressingController.clear();
        stateController.clear();
        apprenticeIdController.clear();
        userIdController.clear();
        userNameDisplayController.clear();
        selectedCauses.clear();

        // Inicializar valores por defecto
        selectedAddressing = null;
        selectedState = null;
        selectedApprenticeId = null;
        
        // OBTENER USUARIO LOGUEADO Y SELECCIONARLO AUTOMÁTICAMENTE
        final currentUser = myReactController.getUser;
        if (currentUser != null && currentUser['id'] != null) {
          selectedUserId = currentUser['id'].toString();
          userIdController.text = selectedUserId!;
          userNameDisplayController.text = "${currentUser['firstName']} ${currentUser['lastName']}";
        } else {
          selectedUserId = null;
          userIdController.clear();
          userNameDisplayController.clear();
        }
        
        selectedCategoryId = null;
        selectedCauseId = null;
        causesByCategory = [];
        _causesLoaded = false;
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
        
        // PARA EDICIÓN: BUSCAR Y MOSTRAR EL NOMBRE DEL USUARIO
        if (selectedUserId != null) {
          final user = myReactController.getListUsers.firstWhere(
            (u) => u['id'].toString() == selectedUserId,
            orElse: () => null,
          );
          if (user != null) {
            userNameDisplayController.text = "${user['firstName']} ${user['lastName']}";
          } else {
            userNameDisplayController.text = selectedUserId!;
          }
        } else {
          userNameDisplayController.clear();
        }

        // Inicializar selectedCauses como vacío temporalmente
        selectedCauses = [];
      }

      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        
        // FUNCIÓN: Cargar causas existentes del reporte
        Future<void> loadExistingCauses() async {
          if (option == "edit" && !_causesLoaded) {
            try {
              setState(() {
                isLoadingCauses = true;
              });

              final causesReports = await fetchCausesByReport(listItem['id']);
              
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
                _causesLoaded = true;
              });
              
            } catch (e) {
              print('❌ Error al cargar causas existentes: $e');
              setState(() {
                isLoadingCauses = false;
                _causesLoaded = true;
              });
            }
          }
        }

        // EJECUTAR LA CARGA SOLO UNA VEZ
        if (option == "edit" && !_causesLoaded) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            loadExistingCauses();
          });
        }

        // 🔥 FUNCIÓN CORREGIDA: Cargar causas por categoría (filtrado en frontend)
        Future<void> loadCausesByCategory(String categoryId) async {
          if (categoryId.isEmpty) return;
          
          setState(() {
            isLoadingCauses = true;
            causesByCategory = [];
            selectedCauseId = null;
          });

          try {
            print('🟡 Cargando causas para categoría ID: $categoryId');
            final causes = await fetchCausesByCategory(int.parse(categoryId));
            
            setState(() {
              causesByCategory = causes;
              isLoadingCauses = false;
            });
            
            print('✅ Causas cargadas: ${causes.length} para categoría $categoryId');
            
            if (causes.isEmpty) {
              Get.snackbar(
                'Información',
                'No hay causas disponibles para esta categoría',
                colorText: Colors.white,
                backgroundColor: Colors.blue,
                duration: Duration(seconds: 2),
              );
            }
          } catch (e) {
            print('❌ Error al cargar causas por categoría: $e');
            setState(() {
              isLoadingCauses = false;
            });
          }
        }

        // Función para obtener el nombre de la categoría seleccionada
        String getSelectedCategoryName() {
          if (selectedCategoryId == null) return '';
          try {
            final category = myReactController.getListCategories.firstWhere(
              (cat) => cat['id'].toString() == selectedCategoryId,
              orElse: () => null,
            );
            return category?['name'] ?? '';
          } catch (e) {
            return '';
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
                '✅ Causa agregada',
                'La causa ha sido agregada a la lista',
                colorText: Colors.white,
                backgroundColor: Colors.green,
                duration: Duration(seconds: 1),
              );
            } else {
              Get.snackbar(
                '⚠️ Causa duplicada',
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

        // Función para buscar nombre de categoría
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
            return 'N/A';
          }
        }

        // Función principal para guardar el reporte y las causas
        Future<void> saveReportAndCauses() async {
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

          if (option == "new") {
            // Crear nuevo reporte
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
            // EDITAR REPORTE EXISTENTE
            // 1. Primero eliminar las relaciones causes_reports existentes
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
            
            for (var cause in selectedCauses) {
              final causeSaved = await newCauseReportApi(
                reportId,
                cause['id'],
              );
              
              if (causeSaved) {
                savedCount++;
              } else {
                allCausesSaved = false;
              }
            }

            Get.back();
            
            if (allCausesSaved) {
              Get.snackbar(
                '✅ Éxito',
                option == "new" 
                    ? "Reporte creado con $savedCount causa(s)"
                    : "Reporte actualizado con $savedCount causa(s)",
                colorText: Colors.white,
                backgroundColor: Colors.green,
                duration: Duration(seconds: 3),
              );
            } else {
              Get.snackbar(
                '⚠️ Advertencia',
                'Reporte guardado pero $savedCount de ${selectedCauses.length} causa(s) se asociaron correctamente',
                colorText: Colors.white,
                backgroundColor: Colors.orange,
                duration: Duration(seconds: 3),
              );
            }
          } else {
            Get.back();
            Get.snackbar(
              '❌ Error',
              option == "new" 
                  ? "Error al crear el reporte"
                  : "Error al actualizar el reporte",
              colorText: Colors.white, 
              backgroundColor: Colors.red,
            );
          }
        }

        // Cargar datos si no están en memoria
        if (myReactController.getListApprentices.isEmpty) {
          fetchAPIApprentices();
        }
        if (myReactController.getListUsers.isEmpty) {
          fetchAPIUsers();
        }
        if (myReactController.getListCategories.isEmpty) {
          fetchAPICategories();
        }
        // 🔥 Asegurar que las causas estén cargadas
        if (myReactController.getListCauses.isEmpty) {
          fetchAPICauses();
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
              bottom: MediaQuery.of(context).viewInsets.bottom + 8,
            ),
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                children: [
                  // Fecha de creación
                  TextFormField(
                    controller: creationDateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Fecha y hora de creación *',
                      hintText: 'Fecha generada automáticamente',
                      suffixIcon: Icon(Icons.lock_clock, color: Colors.grey),
                    ),
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
                          "${apprentice['firtsName']} ${apprentice['lastName']} - ${apprentice['document']}",
                          overflow: TextOverflow.ellipsis,
                        ),
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

                  // Campo Usuario - Solo lectura
                  TextFormField(
                    controller: userNameDisplayController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Usuario *',
                      hintText: 'Usuario asignado al reporte',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.person, color: Colors.grey),
                    ),
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
                      labelText: 'Seleccione una categoría *',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      suffixIcon: Icon(Icons.category),
                    ),
                    hint: Text('Seleccione una categoría para filtrar causas'),
                    items: myReactController.getListCategories
                        .map<DropdownMenuItem<String>>((category) {
                      return DropdownMenuItem<String>(
                        value: category['id'].toString(),
                        child: Text(
                          category['name'],
                          overflow: TextOverflow.ellipsis,
                        ),
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

                  // 🔥 DROPDOWN PARA CAUSAS - AHORA FUNCIONA CORRECTAMENTE
                  if (selectedCategoryId != null) ...[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            child: Row(
                              children: [
                                Icon(Icons.filter_alt, size: 16, color: Colors.blue),
                                SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Causas de: ${getSelectedCategoryName()}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blue[700],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DropdownButtonFormField<String>(
                            value: selectedCauseId,
                            decoration: InputDecoration(
                              labelText: 'Seleccione una causa *',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                            ),
                            hint: isLoadingCauses 
                                ? Text('Cargando causas...')
                                : causesByCategory.isEmpty
                                    ? Text('No hay causas disponibles')
                                    : Text('Seleccione una causa'),
                            items: isLoadingCauses
                                ? [DropdownMenuItem(value: null, child: Text('Cargando...'))]
                                : causesByCategory.map<DropdownMenuItem<String>>((cause) {
                                    return DropdownMenuItem<String>(
                                      value: cause['id'].toString(),
                                      child: Container(
                                        constraints: BoxConstraints(maxWidth: 300),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              cause['cause'] ?? 'Sin descripción',
                                              style: TextStyle(fontSize: 14),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            if (cause['variable'] != null)
                                              Text(
                                                'Variable: ${cause['variable']}',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            onChanged: isLoadingCauses ? null : (String? newValue) {
                              setState(() {
                                selectedCauseId = newValue;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                  ],

                  // Botón para agregar causa
                  if (selectedCategoryId != null && causesByCategory.isNotEmpty && selectedCauseId != null) ...[
                    ElevatedButton(
                      onPressed: addCause,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_circle_outline, size: 20),
                          SizedBox(width: 8),
                          Text('Agregar Causa a la Lista'),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 50),
                      ),
                    ),
                    SizedBox(height: 16),
                  ],

                  // LISTA DE CAUSAS AGREGADAS
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
                              child: Column(
                                children: [
                                  Icon(Icons.info_outline, size: 40, color: Colors.grey[400]),
                                  SizedBox(height: 8),
                                  Text(
                                    option == "new" 
                                        ? 'No hay causas agregadas\nSeleccione una categoría y luego una causa para agregar'
                                        : 'No hay causas asociadas a este reporte\nAgregue causas usando los controles arriba',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            )
                          : Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.green[50],
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.green[200]!),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.check_circle, color: Colors.green, size: 16),
                                      SizedBox(width: 8),
                                      Text(
                                        'Total: ${selectedCauses.length} causa(s)',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.green[800],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 8),
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxHeight: 200,
                                  ),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: ClampingScrollPhysics(),
                                    itemCount: selectedCauses.length,
                                    itemBuilder: (context, index) {
                                      final cause = selectedCauses[index];
                                      final categoryName = getCategoryName(cause);
                                      
                                      return Card(
                                        margin: EdgeInsets.symmetric(vertical: 4),
                                        elevation: 1,
                                        child: ListTile(
                                          dense: true,
                                          leading: Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: option == "edit" ? Colors.orange[100] : Colors.blue[100],
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Text(
                                                '${index + 1}',
                                                style: TextStyle(
                                                  color: option == "edit" ? Colors.orange[800] : Colors.blue[800],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                            cause['cause'] ?? 'Sin descripción',
                                            style: TextStyle(fontSize: 13),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Categoría: $categoryName',
                                                style: TextStyle(fontSize: 11),
                                              ),
                                              if (cause['variable'] != null)
                                                Text(
                                                  'Variable: ${cause['variable']}',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                            ],
                                          ),
                                          trailing: IconButton(
                                            icon: Icon(Icons.delete, color: Colors.red, size: 18),
                                            onPressed: () => removeCause(index),
                                            tooltip: 'Eliminar causa',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),

                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      });
    },
  );
}