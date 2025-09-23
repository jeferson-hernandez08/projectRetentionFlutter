import 'package:app_projectretention_711_v1/api/apiRetention.dart';
import 'package:app_projectretention_711_v1/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controladores para los campos del aprendiz
final TextEditingController documentTypeController = TextEditingController();
final TextEditingController documentController = TextEditingController();
final TextEditingController firtsNameController = TextEditingController();
final TextEditingController lastNameController = TextEditingController();
final TextEditingController phoneController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController statusController = TextEditingController();
final TextEditingController quarterController = TextEditingController();
final TextEditingController fkIdGroupsController = TextEditingController();

// Función para normalizar valores del dropdown de estado
String _normalizeStatusValue(String status) {
  if (status.isEmpty) return status;
  
  // Mapeo de valores posibles a los valores exactos del dropdown
  final Map<String, String> statusMap = {
    'desertado': 'Desertado',
    'en formación': 'En Formación',
    'en formacion': 'En Formación',
    'en práctica': 'En Práctica',
    'en practica': 'En Práctica',
    'certificado': 'Certificado',
    'Desertado': 'Desertado',
    'En Formación': 'En Formación',
    'En Formacion': 'En Formación',
    'En Práctica': 'En Práctica',
    'En Practica': 'En Práctica',
    'Certificado': 'Certificado'
  };
  
  return statusMap[status.toLowerCase()] ?? status;
}

modalEditNewApprentice(context, option, dynamic listItem) {
  // Creamos una clave global para el formulario
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Variables para los valores seleccionados en los dropdowns
  String? selectedDocumentType;
  String? selectedStatus;
  String? selectedQuarter;
  String? selectedGroupId;

  showModalBottomSheet(
    isScrollControlled: true,
    context: context, 
    builder: (context) {
      if(option == "new") { 
        // Limpiar campos para nuevo aprendiz
        documentTypeController.clear();
        documentController.clear();
        firtsNameController.clear();
        lastNameController.clear();
        phoneController.clear();
        emailController.clear();
        statusController.clear();
        quarterController.clear();
        fkIdGroupsController.clear();
        
        // Inicializar valores por defecto
        selectedDocumentType = null;
        selectedStatus = null;
        selectedQuarter = null;
        selectedGroupId = null;
      } else {
        // Cargar datos existentes para editar
        documentTypeController.text = listItem['documentType'] ?? '';
        documentController.text = listItem['document'] ?? '';
        firtsNameController.text = listItem['firtsName'] ?? '';
        lastNameController.text = listItem['lastName'] ?? '';
        phoneController.text = listItem['phone'] ?? '';
        emailController.text = listItem['email'] ?? '';
        statusController.text = listItem['status'] ?? '';
        quarterController.text = listItem['quarter'] ?? '';
        fkIdGroupsController.text = listItem['fkIdGroups']?.toString() ?? '';
        
        // Establecer valores para los dropdowns con validación y normalización
        String documentTypeValue = listItem['documentType']?.toString() ?? '';
        selectedDocumentType = documentTypeValue.isNotEmpty ? documentTypeValue : null;
        documentTypeController.text = selectedDocumentType ?? '';
        
        String statusValue = listItem['status']?.toString() ?? '';
        // Normalizar el valor del estado
        String normalizedStatus = _normalizeStatusValue(statusValue);
        selectedStatus = statusValue.isNotEmpty ? normalizedStatus : null;
        statusController.text = selectedStatus ?? '';
        
        String quarterValue = listItem['quarter']?.toString() ?? '';
        selectedQuarter = quarterValue.isNotEmpty ? quarterValue : null;
        quarterController.text = selectedQuarter ?? '';
        
        String groupValue = listItem['fkIdGroups']?.toString() ?? '';
        selectedGroupId = groupValue.isNotEmpty ? groupValue : null;
        fkIdGroupsController.text = selectedGroupId ?? '';
      }

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          // Capturar los grupos solo si no están en memoria
          if (myReactController.getListGroups.isEmpty) {
            fetchAPIGroups().then((_) {
              setState(() {}); // Refresca cuando termine la API
            });
          }

          return Scaffold(
            appBar: AppBar(
              title: (option == "new") ? Text('Crear Nuevo Aprendiz') : Text('Editar Aprendiz'),
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
                  // Crear nuevo aprendiz
                  bool resp = await newApprenticeApi(
                    selectedDocumentType ?? '',
                    documentController.text,
                    firtsNameController.text,
                    lastNameController.text,
                    phoneController.text,
                    emailController.text,
                    selectedStatus ?? '',
                    selectedQuarter ?? '',
                    selectedGroupId ?? '',
                  );
                  Get.back();
                  if(resp) {
                    Get.snackbar(
                      'Mensaje', "Se ha añadido correctamente un nuevo aprendiz", 
                      colorText: Colors.white,
                      backgroundColor: Colors.green
                    );
                  } else {
                    Get.snackbar(
                      'Mensaje', "Error al agregar el nuevo aprendiz", 
                      colorText: Colors.white,
                      backgroundColor: Colors.red
                    );
                  }
                } else {   
                  // Editar aprendiz existente
                  bool resp = await editApprenticeApi(
                    listItem['id'],
                    selectedDocumentType ?? '',
                    documentController.text,
                    firtsNameController.text,
                    lastNameController.text,
                    phoneController.text,
                    emailController.text,
                    selectedStatus ?? '',
                    selectedQuarter ?? '',
                    selectedGroupId ?? '',
                  );
                  Get.back();
                  if(resp) {
                    Get.snackbar(
                      'Mensaje', "Se ha editado correctamente el aprendiz", 
                      colorText: Colors.green,
                      backgroundColor: Colors.greenAccent
                    );
                  } else {
                    Get.snackbar('Mensaje', "Error al editar el aprendiz", colorText: Colors.red);
                  }
                }
              }),

              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      // Dropdown para Tipo de Documento
                      DropdownButtonFormField<String>(
                        value: selectedDocumentType,
                        decoration: InputDecoration(
                          labelText: 'Tipo de Documento *',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        ),
                        hint: Text('Seleccione el tipo de documento'),
                        items: [
                          DropdownMenuItem(
                            value: 'CC',
                            child: Text('CC - Cédula de Ciudadanía'),
                          ),
                          DropdownMenuItem(
                            value: 'TI',
                            child: Text('TI - Tarjeta de Identidad'),
                          ),
                        ].toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedDocumentType = newValue;
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

                      TextFormField(
                        controller: documentController,
                        decoration: InputDecoration(
                          labelText: 'Número de Documento *',
                          hintText: 'Ingrese el número de documento',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Este campo es obligatorio';
                          }
                          return null;
                        },
                      ),

                      TextFormField(
                        controller: firtsNameController,
                        decoration: InputDecoration(
                          labelText: 'Primer Nombre *',
                          hintText: 'Ingrese el primer nombre',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Este campo es obligatorio';
                          }
                          return null;
                        },
                      ),

                      TextFormField(
                        controller: lastNameController,
                        decoration: InputDecoration(
                          labelText: 'Apellidos *',
                          hintText: 'Ingrese los apellidos',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Este campo es obligatorio';
                          }
                          return null;
                        },
                      ),

                      TextFormField(
                        controller: phoneController,
                        decoration: InputDecoration(
                          labelText: 'Teléfono',
                          hintText: 'Ingrese el número de teléfono',
                        ),
                        keyboardType: TextInputType.phone,
                      ),

                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'Ingrese el correo electrónico',
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            if (!value.contains('@') || !value.contains('.')) {
                              return 'Ingrese un email válido';
                            }
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 16),

                      // Dropdown para Estado - CORREGIDO
                      DropdownButtonFormField<String>(
                        value: selectedStatus,
                        decoration: InputDecoration(
                          labelText: 'Estado *',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        ),
                        hint: Text('Seleccione el estado'),
                        items: [
                          DropdownMenuItem(
                            value: 'Desertado',
                            child: Text('Desertado'),
                          ),
                          DropdownMenuItem(
                            value: 'En Formación',
                            child: Text('En Formación'),
                          ),
                          DropdownMenuItem(
                            value: 'En Práctica',
                            child: Text('En Práctica'),
                          ),
                          DropdownMenuItem(
                            value: 'Certificado',
                            child: Text('Certificado'),
                          ),
                        ].toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedStatus = newValue;
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

                      // Dropdown para Trimestre - CORREGIDO
                      DropdownButtonFormField<String>(
                        value: selectedQuarter,
                        decoration: InputDecoration(
                          labelText: 'Trimestre *',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        ),
                        hint: Text('Seleccione el trimestre'),
                        items: List.generate(9, (index) {
                          String quarter = (index + 1).toString();
                          return DropdownMenuItem<String>(
                            value: quarter,
                            child: Text('Trimestre $quarter'),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedQuarter = newValue;
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

                      // Dropdown para Grupo
                      DropdownButtonFormField<String>(
                        value: selectedGroupId,
                        decoration: InputDecoration(
                          labelText: 'Grupo *',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        ),
                        hint: Text('Seleccione un grupo'),
                        items: myReactController.getListGroups.map<DropdownMenuItem<String>>((group) {
                          return DropdownMenuItem<String>(
                            value: group['id'].toString(),
                            child: Text(group['file'] ?? 'Grupo ${group['id']}'),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedGroupId = newValue;
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