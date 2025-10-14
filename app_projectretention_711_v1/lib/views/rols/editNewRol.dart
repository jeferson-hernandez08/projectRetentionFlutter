import 'package:app_projectretention_711_v1/api/apiRetention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final TextEditingController nameController = TextEditingController();

modalEditNewRol(context, option, dynamic listItem) {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      if (option == "new") {
        nameController.clear();
      } else {
        nameController.text = listItem['name'] ?? '';
      }

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          // 🎨 Estilo del campo de texto con colores de íconos personalizados
          InputDecoration customInputDecoration(String label, {IconData? icon}) {
            Color iconColor;
            switch (icon) {
              case Icons.admin_panel_settings:
                iconColor = Colors.blueAccent;
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

          return Scaffold(
            backgroundColor: const Color(0xFFF5F5F5),
            appBar: AppBar(
              title: Text(
                (option == "new") ? 'Nuevo Rol' : 'Editar Rol',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: const Color.fromARGB(255, 7, 25, 83),
              foregroundColor: Colors.white,
              centerTitle: true,
            ),

            // 💙 Celeste para crear / 🟧 Naranja para editar
            floatingActionButton: FloatingActionButton.extended(
              backgroundColor: option == "new"
                  ? const Color(0xFF00BFFF) // Celeste (Crear)
                  : Colors.orange, // Naranja (Editar)
              foregroundColor: Colors.white,
              icon: Icon(option == "new" ? Icons.add : Icons.edit),
              label: Text(option == "new" ? 'Crear' : 'Guardar'),
              onPressed: () async {
                if (!_formKey.currentState!.validate()) {
                  Get.snackbar(
                    'Campos incompletos',
                    'Por favor complete todos los campos obligatorios',
                    colorText: Colors.white,
                    backgroundColor:
                        const Color.fromARGB(255, 23, 214, 214), // 💠 Celeste
                  );
                  return;
                }

                bool resp;
                if (option == "new") {
                  resp = await newRolApi(
                    nameController.text,
                  );
                  Get.back();
                  Get.snackbar(
                    'Mensaje',
                    resp
                        ? 'Se ha añadido correctamente un nuevo rol'
                        : 'Error al agregar el nuevo rol',
                    colorText: Colors.white,
                    backgroundColor:
                        resp ? Colors.green : Colors.red, // 🟢 / 🔴
                  );
                } else {
                  resp = await editRolApi(
                    listItem['id'],
                    nameController.text,
                  );
                  Get.back();
                  Get.snackbar(
                    'Mensaje',
                    resp
                        ? 'Se ha editado correctamente el rol'
                        : 'Error al editar el rol',
                    colorText: Colors.white,
                    backgroundColor:
                        resp ? Colors.green : Colors.red, // 🟢 / 🔴
                  );
                }
              },
            ),

            // 📋 Formulario
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
                              controller: nameController,
                              decoration: customInputDecoration('Nombre *',
                                  icon: Icons.admin_panel_settings),
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
