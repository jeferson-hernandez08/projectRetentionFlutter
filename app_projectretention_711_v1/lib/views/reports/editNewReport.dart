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

  // 🔍 CONTROLADORES DE BÚSQUEDA
  final TextEditingController apprenticeSearchController = TextEditingController();
  final TextEditingController categorySearchController = TextEditingController();
  final TextEditingController causeSearchController = TextEditingController();
  
  // 🔍 LISTAS FILTRADAS
  List<dynamic> filteredApprentices = [];
  List<dynamic> filteredCategories = [];
  List<dynamic> filteredCauses = [];

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.transparent,
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
        selectedState = 'Registrado'; // PRE-SELECCIONADO
        stateController.text = 'Registrado'; // PRE-SELECCIONADO
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
          try {
            final user = myReactController.getListUsers.firstWhere(
              (u) => u['id'].toString() == selectedUserId,
              orElse: () => {},
            );
            if (user.isNotEmpty) {
              userNameDisplayController.text = "${user['firstName']} ${user['lastName']}";
            } else {
              userNameDisplayController.text = selectedUserId!;
            }
          } catch (e) {
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
        
        // 🔍 FUNCIÓN: Filtrar aprendices
        void filterApprentices(String query) {
          setState(() {
            if (query.isEmpty) {
              filteredApprentices = myReactController.getListApprentices;
            } else {
              filteredApprentices = myReactController.getListApprentices.where((apprentice) {
                final name = "${apprentice['firtsName']} ${apprentice['lastName']}".toLowerCase();
                final document = apprentice['document'].toString().toLowerCase();
                final searchLower = query.toLowerCase();
                return name.contains(searchLower) || document.contains(searchLower);
              }).toList();
            }
          });
        }

        // 🔍 FUNCIÓN: Filtrar categorías
        void filterCategories(String query) {
          setState(() {
            if (query.isEmpty) {
              filteredCategories = myReactController.getListCategories;
            } else {
              filteredCategories = myReactController.getListCategories.where((category) {
                final name = category['name'].toString().toLowerCase();
                final searchLower = query.toLowerCase();
                return name.contains(searchLower);
              }).toList();
            }
          });
        }

        // 🔍 FUNCIÓN: Filtrar causas
        void filterCauses(String query) {
          setState(() {
            if (query.isEmpty) {
              filteredCauses = causesByCategory;
            } else {
              filteredCauses = causesByCategory.where((cause) {
                final causeName = cause['cause'].toString().toLowerCase();
                final variable = cause['variable']?.toString().toLowerCase() ?? '';
                final searchLower = query.toLowerCase();
                return causeName.contains(searchLower) || variable.contains(searchLower);
              }).toList();
            }
          });
        }

        // Inicializar listas filtradas
        if (filteredApprentices.isEmpty && myReactController.getListApprentices.isNotEmpty) {
          filteredApprentices = myReactController.getListApprentices;
        }
        if (filteredCategories.isEmpty && myReactController.getListCategories.isNotEmpty) {
          filteredCategories = myReactController.getListCategories;
        }
        
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
            filteredCauses = [];
            selectedCauseId = null;
            causeSearchController.clear();
          });

          try {
            print('🟡 Cargando causas para categoría ID: $categoryId');
            final causes = await fetchCausesByCategory(int.parse(categoryId));
            
            setState(() {
              causesByCategory = causes;
              filteredCauses = causes;
              isLoadingCauses = false;
            });
            
            print('✅ Causas cargadas: ${causes.length} para categoría $categoryId');
            
            if (causes.isEmpty) {
              Get.snackbar(
                'Información',
                'No hay causas disponibles para esta categoría',
                colorText: Colors.white,
                backgroundColor: Color.fromARGB(255, 23, 214, 214),
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
              orElse: () => {},
            );
            return category.isNotEmpty ? (category['name'] ?? '') : '';
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
              backgroundColor: Color.fromARGB(255, 23, 214, 214),
            );
            return;
          }

          final cause = causesByCategory.firstWhere(
            (c) => c['id'].toString() == selectedCauseId,
            orElse: () => {},
          );
          
          if (cause != null && cause.isNotEmpty) {
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
                backgroundColor: Color.fromARGB(255, 7, 25, 83),
                duration: Duration(seconds: 1),
              );
            } else {
              Get.snackbar(
                '⚠️ Causa duplicada',
                'Esta causa ya fue agregada',
                colorText: Colors.white,
                backgroundColor: Color.fromARGB(255, 23, 214, 214),
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
                orElse: () => {},
              );
              return category.isNotEmpty ? (category['name'] ?? 'N/A') : 'N/A';
            }
            
            return 'N/A';
          } catch (e) {
            return 'N/A';
          }
        }

        // 📏 FUNCIÓN: Truncar texto largo (solo para el valor seleccionado)
        String truncateText(String text, int maxLength) {
          if (text.length <= maxLength) {
            return text;
          }
          return '${text.substring(0, maxLength)}...';
        }

        // Función principal para guardar el reporte y las causas
        Future<void> saveReportAndCauses() async {
          if (!_formKey.currentState!.validate()) {
            Get.snackbar(
              'Campos incompletos',
              'Por favor, complete todos los campos obligatorios',
              colorText: Colors.white,
              backgroundColor: Color.fromARGB(255, 23, 214, 214),
            );
            return;
          }

          if (selectedCauses.isEmpty) {
            Get.snackbar(
              'Causas requeridas',
              'Por favor agregue al menos una causa',
              colorText: Colors.white,
              backgroundColor: Color.fromARGB(255, 23, 214, 214),
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
                'Mensaje',
                option == "new" 
                    ? "Se ha creado correctamente un nuevo reporte con $savedCount causa(s)"
                    : "Se ha editado correctamente el reporte con $savedCount causa(s)",
                colorText: Colors.white,
                backgroundColor: Colors.green,
                duration: Duration(seconds: 3),
              );
            } else {
              Get.snackbar(
                'Mensaje',
                'Reporte guardado pero $savedCount de ${selectedCauses.length} causa(s) se asociaron correctamente',
                colorText: Colors.white,
                backgroundColor: Colors.orange,
                duration: Duration(seconds: 3),
              );
            }
          } else {
            Get.back();
            Get.snackbar(
              'Mensaje',
              option == "new" 
                  ? "Error al crear el nuevo reporte"
                  : "Error al editar el reporte",
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

        // Estilo del campo de texto con color de icono personalizado
        InputDecoration customInputDecoration(String label, {IconData? icon, Color? iconColor}) {
          return InputDecoration(
            labelText: label,
            prefixIcon: icon != null
                ? Icon(icon, color: iconColor ?? const Color.fromARGB(255, 7, 25, 83))
                : null,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          );
        }

        // Estilo del dropdown con color de icono personalizado
        InputDecoration customDropdownDecoration(String label, {IconData? icon, Color? iconColor}) {
          return InputDecoration(
            labelText: label,
            prefixIcon: icon != null
                ? Icon(icon, color: iconColor ?? const Color.fromARGB(255, 7, 25, 83))
                : null,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          appBar: AppBar(
            title: Text(
              (option == "new") ? 'Nuevo Reporte' : 'Editar Reporte',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color.fromARGB(255, 7, 25, 83),
            foregroundColor: Colors.white,
            centerTitle: true,
          ),

          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: option == "new" ? Colors.blue : Colors.orange,
            foregroundColor: Colors.white,
            icon: Icon(option == "new" ? Icons.add : Icons.edit),
            label: Text(option == "new" ? 'Crear' : 'Guardar'),
            onPressed: saveReportAndCauses,
          ),

          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  // SECCIÓN PRINCIPAL DEL REPORTE
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          // Fecha de creación
                          TextFormField(
                            controller: creationDateController,
                            readOnly: true,
                            decoration: customInputDecoration(
                              'Fecha y Hora de Creación *', 
                              icon: Icons.lock_clock,
                              iconColor: Colors.blue,
                            ),
                            validator: (v) => 
                                (v == null || v.isEmpty) ? 'Campo obligatorio' : null,
                          ),
                          const SizedBox(height: 10),

                          // Descripción
                          TextFormField(
                            controller: descriptionController,
                            maxLines: 3,
                            decoration: customInputDecoration(
                              'Descripción *', 
                              icon: Icons.description,
                              iconColor: Colors.purple,
                            ),
                            validator: (v) => 
                                (v == null || v.isEmpty) ? 'Campo obligatorio' : null,
                          ),
                          const SizedBox(height: 10),

                          // Dropdown para Direccionamiento
                          DropdownButtonFormField<String>(
                            value: selectedAddressing,
                            decoration: customDropdownDecoration(
                              'Direccionamiento *',
                              icon: Icons.directions,
                              iconColor: Colors.teal,
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
                            validator: (value) =>
                                (value == null || value.isEmpty) ? 'Campo obligatorio' : null,
                          ),
                          const SizedBox(height: 10),

                          // Dropdown para Estado - BLOQUEADO en modo "new"
                          DropdownButtonFormField<String>(
                            value: selectedState,
                            decoration: customDropdownDecoration(
                              'Estado *',
                              icon: Icons.stacked_line_chart,
                              iconColor: Colors.deepOrange,
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
                            onChanged: option == "new" ? null : (String? newValue) {
                              setState(() {
                                selectedState = newValue;
                                stateController.text = newValue ?? '';
                              });
                            },
                            validator: (value) =>
                                (value == null || value.isEmpty) ? 'Campo obligatorio' : null,
                          ),
                          const SizedBox(height: 10),

                          // 🔍 BUSCADOR DE APRENDICES (solo en modo "new")
                          if (option == "new") ...[
                            TextField(
                              controller: apprenticeSearchController,
                              decoration: InputDecoration(
                                labelText: 'Buscar aprendiz',
                                prefixIcon: Icon(Icons.search, color: Colors.indigo),
                                suffixIcon: apprenticeSearchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: Icon(Icons.clear, size: 20),
                                        onPressed: () {
                                          setState(() {
                                            apprenticeSearchController.clear();
                                            filterApprentices('');
                                          });
                                        },
                                      )
                                    : null,
                                filled: true,
                                fillColor: Colors.blue[50],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              ),
                              onChanged: filterApprentices,
                            ),
                            const SizedBox(height: 8),
                          ],

                          // 🎯 Dropdown para Aprendiz - TEXTO COMPLETO EN MENÚ, TRUNCADO CUANDO ESTÁ SELECCIONADO
                          DropdownButtonFormField<String>(
                            value: selectedApprenticeId,
                            decoration: customDropdownDecoration(
                              'Aprendiz *',
                              icon: Icons.school,
                              iconColor: Colors.indigo,
                            ),
                            hint: Text('Seleccione un aprendiz'),
                            isExpanded: true,
                            selectedItemBuilder: (BuildContext context) {
                              // TEXTO TRUNCADO para el valor seleccionado en el formulario
                              return (option == "new" ? filteredApprentices : myReactController.getListApprentices)
                                  .map<Widget>((apprentice) {
                                final fullText = "${apprentice['firtsName']} ${apprentice['lastName']} - ${apprentice['document']}";
                                return Text(
                                  truncateText(fullText, 35),
                                  overflow: TextOverflow.ellipsis,
                                );
                              }).toList();
                            },
                            items: (option == "new" ? filteredApprentices : myReactController.getListApprentices)
                                .map<DropdownMenuItem<String>>((apprentice) {
                              // TEXTO COMPLETO en el menú desplegable
                              final fullText = "${apprentice['firtsName']} ${apprentice['lastName']} - ${apprentice['document']}";
                              return DropdownMenuItem<String>(
                                value: apprentice['id'].toString(),
                                child: Text(fullText), // Sin truncar
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedApprenticeId = newValue;
                                apprenticeIdController.text = newValue ?? '';
                              });
                            },
                            validator: (value) =>
                                (value == null || value.isEmpty) ? 'Campo obligatorio' : null,
                          ),
                          const SizedBox(height: 10),

                          // Campo Usuario - Solo lectura
                          TextFormField(
                            controller: userNameDisplayController,
                            readOnly: true,
                            decoration: customInputDecoration(
                              'Usuario *', 
                              icon: Icons.person,
                              iconColor: Colors.green,
                            ),
                            validator: (v) => 
                                (v == null || v.isEmpty) ? 'Campo obligatorio' : null,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // SECCIÓN DE CAUSAS
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Causas del Reporte *',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 7, 25, 83),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // 🔍 BUSCADOR DE CATEGORÍAS
                          TextField(
                            controller: categorySearchController,
                            decoration: InputDecoration(
                              labelText: 'Buscar categoría',
                              prefixIcon: Icon(Icons.search, color: Colors.pink),
                              suffixIcon: categorySearchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: Icon(Icons.clear, size: 20),
                                      onPressed: () {
                                        setState(() {
                                          categorySearchController.clear();
                                          filterCategories('');
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
                            onChanged: filterCategories,
                          ),
                          const SizedBox(height: 8),

                          // 🎯 Dropdown para Categorías - TEXTO COMPLETO EN MENÚ, TRUNCADO CUANDO ESTÁ SELECCIONADO
                          DropdownButtonFormField<String>(
                            value: selectedCategoryId,
                            decoration: customDropdownDecoration(
                              'Seleccione una categoría *',
                              icon: Icons.category,
                              iconColor: Colors.pink,
                            ),
                            hint: Text('Seleccione una categoría para filtrar causas'),
                            isExpanded: true,
                            selectedItemBuilder: (BuildContext context) {
                              // TEXTO TRUNCADO para el valor seleccionado en el formulario
                              return filteredCategories.map<Widget>((category) {
                                return Text(
                                  truncateText(category['name'], 40),overflow: TextOverflow.ellipsis,
                                );
                              }).toList();
                            },
                            items: filteredCategories
                                .map<DropdownMenuItem<String>>((category) {
                              // TEXTO COMPLETO en el menú desplegable
                              return DropdownMenuItem<String>(
                                value: category['id'].toString(),
                                child: Text(category['name']), // Sin truncar
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedCategoryId = newValue;
                                selectedCauseId = null;
                                causesByCategory = [];
                                filteredCauses = [];
                                causeSearchController.clear();
                              });
                              if (newValue != null && newValue.isNotEmpty) {
                                loadCausesByCategory(newValue);
                              }
                            },
                          ),
                          const SizedBox(height: 10),

                          // 🔍 BUSCADOR DE CAUSAS
                          if (selectedCategoryId != null && causesByCategory.isNotEmpty) ...[
                            TextField(
                              controller: causeSearchController,
                              decoration: InputDecoration(
                                labelText: 'Buscar causa',
                                prefixIcon: Icon(Icons.search, color: Colors.red),
                                suffixIcon: causeSearchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: Icon(Icons.clear, size: 20),
                                        onPressed: () {
                                          setState(() {
                                            causeSearchController.clear();
                                            filterCauses('');
                                          });
                                        },
                                      )
                                    : null,
                                filled: true,
                                fillColor: Colors.red[50],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              ),
                              onChanged: filterCauses,
                            ),
                            const SizedBox(height: 8),
                          ],

                          // 🎯 Dropdown para Causas - TEXTO COMPLETO EN MENÚ, TRUNCADO CUANDO ESTÁ SELECCIONADO
                          if (selectedCategoryId != null) ...[
                            DropdownButtonFormField<String>(
                              value: selectedCauseId,
                              decoration: customDropdownDecoration(
                                'Seleccione una causa *',
                                icon: Icons.flag,
                                iconColor: Colors.red,
                              ),
                              hint: isLoadingCauses 
                                  ? Text('Cargando causas...')
                                  : filteredCauses.isEmpty
                                      ? Text('No hay causas disponibles')
                                      : Text('Seleccione una causa'),
                              isExpanded: true,
                              selectedItemBuilder: (BuildContext context) {
                                // TEXTO TRUNCADO para el valor seleccionado en el formulario
                                return isLoadingCauses
                                    ? [Text('Cargando...')]
                                    : filteredCauses.map<Widget>((cause) {
                                        return Text(
                                          truncateText(cause['cause'] ?? 'Sin descripción', 35),
                                          overflow: TextOverflow.ellipsis,
                                        );
                                      }).toList();
                              },
                              items: isLoadingCauses
                                  ? [DropdownMenuItem(value: null, child: Text('Cargando...'))]
                                  : filteredCauses.map<DropdownMenuItem<String>>((cause) {
                                      // TEXTO COMPLETO en el menú desplegable
                                      return DropdownMenuItem<String>(
                                        value: cause['id'].toString(),
                                        child: Text(cause['cause'] ?? 'Sin descripción'), // Sin truncar
                                      );
                                    }).toList(),
                              onChanged: isLoadingCauses ? null : (String? newValue) {
                                setState(() {
                                  selectedCauseId = newValue;
                                });
                              },
                            ),
                            const SizedBox(height: 10),
                          ],

                          // Botón para agregar causa
                          if (selectedCategoryId != null && filteredCauses.isNotEmpty && selectedCauseId != null) ...[
                            ElevatedButton(
                              onPressed: addCause,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 7, 25, 83),
                                foregroundColor: Colors.white,
                                minimumSize: Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_circle_outline, size: 20),
                                  SizedBox(width: 8),
                                  Text('Agregar Causa a la Lista'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          // LISTA DE CAUSAS AGREGADAS
                          Text(
                            'Causas Agregadas:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),

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
                                                    truncateText(cause['cause'] ?? 'Sin descripción', 50),
                                                    style: TextStyle(fontSize: 13),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  subtitle: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'Categoría: ${truncateText(categoryName, 30)}',
                                                        style: TextStyle(fontSize: 11),
                                                      ),
                                                      if (cause['variable'] != null)
                                                        Text(
                                                          'Variable: ${truncateText(cause['variable'], 25)}',
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
                        ],
                      ),
                    ),
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