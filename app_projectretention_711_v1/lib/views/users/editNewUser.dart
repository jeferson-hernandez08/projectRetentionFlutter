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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? selectedManager;
  String? selectedCoordinadorType;
  String? selectedRolId;
  DateTime? selectedPasswordResetExpires;

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      if (option == "new") {
        firstNameController.clear();
        lastNameController.clear();
        emailController.clear();
        phoneController.clear();
        documentController.clear();
        passwordController.clear();
        coordinadorTypeController.clear();
        rolIdController.clear();

        selectedManager = null;
        selectedCoordinadorType = 'none';
        selectedRolId = null;
        selectedPasswordResetExpires = null;
      } else {
        firstNameController.text = listItem['firstName'] ?? '';
        lastNameController.text = listItem['lastName'] ?? '';
        emailController.text = listItem['email'] ?? '';
        phoneController.text = listItem['phone'] ?? '';
        documentController.text = listItem['document'] ?? '';
        passwordController.text = listItem['password'] ?? '';

        String managerValue = listItem['manager']?.toString() ?? 'false';
        selectedManager =
            (['true', 'false'].contains(managerValue)) ? managerValue : 'false';

        String coordinadorValue = listItem['coordinadorType'] ?? 'none';
        selectedCoordinadorType =
            (['none', 'academico', 'formacion'].contains(coordinadorValue))
                ? coordinadorValue
                : 'none';
        coordinadorTypeController.text = selectedCoordinadorType!;

        String rolValue = listItem['fkIdRols']?.toString() ?? '';
        selectedRolId = rolValue.isNotEmpty ? rolValue : null;
        rolIdController.text = selectedRolId ?? '';

        if (listItem['passwordResetExpires'] != null) {
          try {
            selectedPasswordResetExpires =
                DateTime.parse(listItem['passwordResetExpires']);
          } catch (e) {
            selectedPasswordResetExpires = null;
          }
        }
      }

      return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
        if (myReactController.getListRols.isEmpty) {
          fetchAPIRols().then((_) {
            setState(() {});
          });
        }

        // 🎨 Colores personalizados de íconos
        InputDecoration customInputDecoration(String label, {IconData? icon}) {
          Color iconColor;
          switch (icon) {
            case Icons.person:
              iconColor = Colors.deepPurple;
              break;
            case Icons.person_outline:
              iconColor = Colors.orangeAccent;
              break;
            case Icons.email:
              iconColor = Colors.redAccent;
              break;
            case Icons.phone:
              iconColor = Colors.green;
              break;
            case Icons.badge:
              iconColor = Colors.blueAccent;
              break;
            case Icons.lock:
              iconColor = Colors.teal;
              break;
            case Icons.supervisor_account:
              iconColor = Colors.cyan;
              break;
            case Icons.admin_panel_settings:
              iconColor = Colors.amber;
              break;
            case Icons.security:
              iconColor = Colors.pinkAccent;
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

        InputDecoration customDropdownDecoration(String label, {IconData? icon}) {
          Color iconColor;
          switch (icon) {
            case Icons.supervisor_account:
              iconColor = Colors.cyan;
              break;
            case Icons.admin_panel_settings:
              iconColor = Colors.amber;
              break;
            case Icons.security:
              iconColor = Colors.pinkAccent;
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
                const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          appBar: AppBar(
            title: Text(
              (option == "new") ? 'Nuevo Usuario' : 'Editar Usuario',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color.fromARGB(255, 7, 25, 83),
            foregroundColor: Colors.white,
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor:
                option == "new" ? const Color(0xFF00BFFF) : Colors.orange,
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
                resp = await newUserApi(
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
                Get.snackbar(
                  'Mensaje',
                  resp
                      ? 'Se ha añadido correctamente un nuevo usuario'
                      : 'Error al agregar el nuevo usuario',
                  colorText: Colors.white,
                  backgroundColor: resp ? Colors.green : Colors.red,
                );
              } else {
                resp = await editUserApi(
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
                Get.snackbar(
                  'Mensaje',
                  resp
                      ? 'Se ha editado correctamente el usuario'
                      : 'Error al editar el usuario',
                  colorText: Colors.white,
                  backgroundColor: resp ? Colors.green : Colors.red,
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
                            controller: firstNameController,
                            decoration: customInputDecoration('Nombre *',
                                icon: Icons.person),
                            validator: (v) =>
                                (v == null || v.isEmpty) ? 'Campo obligatorio' : null,
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: lastNameController,
                            decoration: customInputDecoration('Apellido *',
                                icon: Icons.person_outline),
                            validator: (v) =>
                                (v == null || v.isEmpty) ? 'Campo obligatorio' : null,
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: emailController,
                            decoration: customInputDecoration('Email *',
                                icon: Icons.email),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Campo obligatorio';
                              }
                              if (!v.contains('@')) {
                                return 'Ingrese un email válido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: phoneController,
                            decoration: customInputDecoration('Teléfono',
                                icon: Icons.phone),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: documentController,
                            decoration: customInputDecoration('Documento *',
                                icon: Icons.badge),
                            validator: (v) =>
                                (v == null || v.isEmpty) ? 'Campo obligatorio' : null,
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: customInputDecoration('Contraseña *',
                                icon: Icons.lock),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Campo obligatorio';
                              }
                              if (v.length < 6) {
                                return 'La contraseña debe tener al menos 6 caracteres';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            value: selectedCoordinadorType,
                            decoration: customDropdownDecoration(
                                'Tipo de Coordinador',
                                icon: Icons.supervisor_account),
                            hint:
                                const Text('Seleccione el tipo de coordinador'),
                            items: const [
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
                                coordinadorTypeController.text =
                                    newValue ?? 'none';
                              });
                            },
                          ),
                          const SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            value: selectedManager,
                            decoration: customDropdownDecoration('Es Manager *',
                                icon: Icons.admin_panel_settings),
                            hint: const Text('Seleccione opción'),
                            items: const [
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
                            validator: (value) => (value == null || value.isEmpty)
                                ? 'Campo obligatorio'
                                : null,
                          ),
                          const SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            value: selectedRolId,
                            decoration: customDropdownDecoration('Rol *',
                                icon: Icons.security),
                            hint: const Text('Seleccione un rol'),
                            items: myReactController.getListRols
                                .map<DropdownMenuItem<String>>((rol) {
                              return DropdownMenuItem<String>(
                                value: rol['id'].toString(),
                                child: Text(
                                  rol['name'],
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedRolId = newValue;
                                rolIdController.text = newValue ?? '';
                              });
                            },
                            validator: (value) => (value == null || value.isEmpty)
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
      });
    },
  );
}
