import 'package:app_projectretention_711_v1/api/apiRetention.dart';
import 'package:app_projectretention_711_v1/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//**********Controladores para los campos de Categorías**********//
final TextEditingController nameCategoryController = TextEditingController();
final TextEditingController descriptionCategoryController = TextEditingController();

// Variable para guardar la opción seleccionada en el campo Addressing
String? selectedAddressing;

modalEditNewCategory(context, option, dynamic listItem) {
  // Clave global para el formulario
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      if (option == "new") {
        // Limpiar campos para nueva categoría
        nameCategoryController.clear();
        descriptionCategoryController.clear();
        selectedAddressing = null;
      } else {
        // Cargar datos existentes para editar
        nameCategoryController.text = listItem['name'] ?? '';
        descriptionCategoryController.text = listItem['description'] ?? '';
        selectedAddressing = listItem['addressing'];
      }

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          // 🎨 Colores personalizados para los íconos
          InputDecoration customInputDecoration(String label, {IconData? icon}) {
            Color iconColor;
            switch (icon) {
              case Icons.category:
                iconColor = Colors.deepPurple;
                break;
              case Icons.description:
                iconColor = Colors.blueAccent;
                break;
              case Icons.supervisor_account:
                iconColor = Colors.teal;
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

          return Scaffold(
            backgroundColor: const Color(0xFFF5F5F5),
            appBar: AppBar(
              title: Text(
                (option == "new") ? 'Nueva Categoría' : 'Editar Categoría',
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
                        const Color.fromARGB(255, 23, 214, 214),
                  );
                  return;
                }

                bool resp;
                if (option == "new") {
                  // Crear nueva categoría
                  resp = await newCategoryApi(
                    nameCategoryController.text,
                    descriptionCategoryController.text,
                    selectedAddressing,
                  );
                  Get.back();
                  Get.snackbar(
                    'Mensaje',
                    resp
                        ? 'Se ha añadido correctamente una nueva categoría'
                        : 'Error al agregar la nueva categoría',
                    colorText: Colors.white,
                    backgroundColor:
                        resp ? Colors.green : Colors.red, // ✅🟥 colores de mensaje
                  );
                } else {
                  // Editar categoría existente
                  resp = await editCategoryApi(
                    listItem['id'],
                    nameCategoryController.text,
                    descriptionCategoryController.text,
                    selectedAddressing,
                  );
                  Get.back();
                  Get.snackbar(
                    'Mensaje',
                    resp
                        ? 'Se ha editado correctamente la categoría'
                        : 'Error al editar la categoría',
                    colorText: Colors.white,
                    backgroundColor:
                        resp ? Colors.green : Colors.red, // ✅🟥 colores de mensaje
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
                            // Campo Nombre
                            TextFormField(
                              controller: nameCategoryController,
                              decoration: customInputDecoration(
                                'Nombre *',
                                icon: Icons.category,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Campo obligatorio';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),

                            // Campo Descripción
                            TextFormField(
                              controller: descriptionCategoryController,
                              decoration: customInputDecoration(
                                'Descripción *',
                                icon: Icons.description,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Campo obligatorio';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),

                            // Campo Responsable de Atención
                            DropdownButtonFormField<String>(
                              value: selectedAddressing,
                              decoration: customInputDecoration(
                                'Responsable de Atención *',
                                icon: Icons.supervisor_account,
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'Coordinador Académico',
                                  child: Text('Coordinador Académico'),
                                ),
                                DropdownMenuItem(
                                  value: 'Coordinador de Formación',
                                  child: Text('Coordinador de Formación'),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  selectedAddressing = value;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Debe seleccionar una opción';
                                }
                                return null;
                              },
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
