import 'package:app_projectretention_711_v1/api/apiRetention.dart';
import 'package:app_projectretention_711_v1/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Para formatear fechas

final TextEditingController firstNameController = TextEditingController();
final TextEditingController lastNameController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController phoneController = TextEditingController();
final TextEditingController documentController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController coordinadorTypeController = TextEditingController();
final TextEditingController rolIdController = TextEditingController();

modalEditNewUser(context, option, dynamic listItem) {
  // Creamos una clave global para el formulario
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Variables para los valores seleccionados en los dropdowns
  String? selectedManager;
  String? selectedCoordinadorType;
  String? selectedRolId; // Nueva variable para el rol
  DateTime? selectedPasswordResetExpires;

  showModalBottomSheet(
    isScrollControlled: true,
    context: context, 
    builder: (context) {
      if(option == "new") { 
        // Limpiar campos para nuevo usuario
        firstNameController.clear();
        lastNameController.clear();
        emailController.clear();
        phoneController.clear();
        documentController.clear();
        passwordController.clear();
        coordinadorTypeController.clear();
        rolIdController.clear();
        
        // Inicializar valores por defecto
        selectedManager = null;
        selectedCoordinadorType = 'none'; // Valor por defecto
        selectedRolId = null;
        selectedPasswordResetExpires = null;
      } else {
        // Cargar datos existentes para editar
        firstNameController.text = listItem['firstName'] ?? '';
        lastNameController.text = listItem['lastName'] ?? '';
        emailController.text = listItem['email'] ?? '';
        phoneController.text = listItem['phone'] ?? '';
        documentController.text = listItem['document'] ?? '';
        passwordController.text = listItem['password'] ?? '';
        
        // Establecer valores para los dropdowns con validación
        String managerValue = listItem['manager']?.toString() ?? 'false';
        selectedManager = (['true', 'false'].contains(managerValue)) ? managerValue : 'false';
        
        String coordinadorValue = listItem['coordinadorType'] ?? 'none';
        selectedCoordinadorType = (['none', 'academico', 'formacion'].contains(coordinadorValue)) 
            ? coordinadorValue 
            : 'none';
        coordinadorTypeController.text = selectedCoordinadorType!;
        
        String rolValue = listItem['fkIdRols']?.toString() ?? '';
        selectedRolId = rolValue.isNotEmpty ? rolValue : null;
        rolIdController.text = selectedRolId ?? '';
        
        // Procesar fecha de expiración si existe
        if (listItem['passwordResetExpires'] != null) {
          try {
            selectedPasswordResetExpires = DateTime.parse(listItem['passwordResetExpires']);
          } catch (e) {
            selectedPasswordResetExpires = null;
          }
        }
      }

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          // Capturar los roles solo si no están en memoria
          if (myReactController.getListRols.isEmpty) {
            fetchAPIRols().then((_) {
              setState(() {}); // Refresca cuando termine la API
            });
          }

          return Scaffold(
            appBar: AppBar(
              title: (option == "new") ? Text('Crear Nuevo Usuario') : Text('Editar Usuario'),
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
                  // Crear nuevo usuario
                  bool resp = await newUserApi(
                    firstNameController.text, 
                    lastNameController.text,
                    emailController.text,
                    phoneController.text,
                    documentController.text,
                    passwordController.text,
                    selectedCoordinadorType ?? 'none',
                    selectedManager ?? 'false',
                    selectedRolId ?? '',
                  );
                  Get.back();
                  if(resp) {
                    Get.snackbar(
                      'Mensaje', "Se ha añadido correctamente un nuevo usuario", 
                      colorText: Colors.white,
                      backgroundColor: Colors.green
                    );
                  } else {
                    Get.snackbar(
                      'Mensaje', "Error al agregar el nuevo usuario", 
                      colorText: Colors.white,
                      backgroundColor: Colors.red
                    );
                  }
                } else {   
                  // Editar usuario existente
                  bool resp = await editUserApi(
                    listItem['id'],
                    firstNameController.text, 
                    lastNameController.text,
                    emailController.text,
                    phoneController.text,
                    documentController.text,
                    passwordController.text,
                    selectedCoordinadorType ?? 'none',
                    selectedManager ?? 'false',
                    selectedRolId ?? '',
                  );
                  Get.back();
                  if(resp) {
                    Get.snackbar(
                      'Mensaje', "Se ha editado correctamente el usuario", 
                      colorText: Colors.green,
                      backgroundColor: Colors.greenAccent
                    );
                  } else {
                    Get.snackbar('Mensaje', "Error al editar el usuario", colorText: Colors.red);
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
                        controller: firstNameController,
                        decoration: InputDecoration(
                          labelText: 'Nombre *',
                          hintText: 'Ingrese el nombre',
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
                          labelText: 'Apellido *',
                          hintText: 'Ingrese el apellido',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Este campo es obligatorio';
                          }
                          return null;
                        },
                      ),

                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email *',
                          hintText: 'Ingrese el email',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Este campo es obligatorio';
                          }
                          if (!value.contains('@')) {
                            return 'Ingrese un email válido';
                          }
                          return null;
                        },
                      ),

                      TextFormField(
                        controller: phoneController, 
                        decoration: InputDecoration(
                          labelText: 'Teléfono',
                          hintText: 'Ingrese el teléfono',
                        ),
                      ),

                      TextFormField(
                        controller: documentController, 
                        decoration: InputDecoration(
                          labelText: 'Documento *',
                          hintText: 'Ingrese número de documento',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Este campo es obligatorio';
                          }
                          return null;
                        },
                      ),

                      TextFormField(
                        controller: passwordController, 
                        decoration: InputDecoration(
                          labelText: 'Password *',
                          hintText: 'Ingrese la contraseña',
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Este campo es obligatorio';
                          }
                          if (value.length < 6) {
                            return 'La contraseña debe tener al menos 6 caracteres';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 16),

                      // Dropdown para Tipo de Coordinador - REVISAR
                      DropdownButtonFormField<String>(
                        value: selectedCoordinadorType,
                        decoration: InputDecoration(
                          labelText: 'Tipo de Coordinador',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        ),
                        hint: Text('Seleccione el tipo de coordinador'),
                        items: [
                          DropdownMenuItem(
                            value: 'none',
                            child: Text('No es coordinador'),
                          ),
                          DropdownMenuItem(
                            value: 'academico',
                            child: Text('Coordinador académico'),
                          ),
                          DropdownMenuItem(
                            value: 'formacion',
                            child: Text('Coordinador de formación'),
                          ),
                        ],
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedCoordinadorType = newValue;
                            coordinadorTypeController.text = newValue ?? 'none';
                          });
                        },
                      ),

                      SizedBox(height: 16),
                    
                      // Dropdown para Manager - REVISAR
                      DropdownButtonFormField<String>(
                        value: selectedManager,
                        decoration: InputDecoration(
                          labelText: 'Es Manager *',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        ),
                        hint: Text('Seleccione opción'),
                        items: [
                          DropdownMenuItem(
                            value: 'true',
                            child: Text('Sí'),
                          ),
                          DropdownMenuItem(
                            value: 'false',
                            child: Text('No'),
                          ),
                        ],
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedManager = newValue;
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

                      // Dropdown para Rol
                      DropdownButtonFormField<String>(
                        value: selectedRolId,
                        decoration: InputDecoration(
                          labelText: 'Rol *',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        ),
                        hint: Text('Seleccione un rol'),
                        items: myReactController.getListRols.map<DropdownMenuItem<String>>((rol) {
                          return DropdownMenuItem<String>(
                            value: rol['id'].toString(),
                            child: Text(rol['name']),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedRolId = newValue;
                            rolIdController.text = newValue ?? '';
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