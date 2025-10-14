import 'package:app_projectretention_711_v1/api/apiRetention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controladores para los campos
final TextEditingController nameController = TextEditingController();
final TextEditingController levelController = TextEditingController();
final TextEditingController versionController = TextEditingController();

modalEditNewTrainingProgram(context, option, dynamic listItem) {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      if (option == "new") {
        nameController.clear();
        levelController.clear();
        versionController.clear();
      } else {
        nameController.text = listItem['name'] ?? '';
        levelController.text = listItem['level'] ?? '';
        versionController.text = listItem['version'] ?? '';
      }

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          // 🎨 Estilo de los campos con colores personalizados
          InputDecoration customInputDecoration(String label, {IconData? icon}) {
            Color iconColor;

            switch (icon) {
              case Icons.book:
                iconColor = Colors.blueAccent;
                break;
              case Icons.stacked_line_chart:
                iconColor = Colors.deepPurple;
                break;
              case Icons.verified:
                iconColor = Colors.teal;
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
                (option == "new")
                    ? 'Nuevo Programa de Formación'
                    : 'Editar Programa de Formación',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: const Color.fromARGB(255, 7, 25, 83),
              foregroundColor: Colors.white,
              centerTitle: true,
            ),
            floatingActionButton: FloatingActionButton.extended(
              backgroundColor: option == "new"
                  ? const Color(0xFF00BFFF) // 💙 Celeste para crear
                  : Colors.orange,          // 🟧 Naranja para editar
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
                  // Crear nuevo programa
                  resp = await newTrainingProgramApi(
                    nameController.text,
                    levelController.text,
                    versionController.text,
                  );
                  Get.back();
                  Get.snackbar(
                    'Mensaje',
                    resp
                        ? '✅ Se ha añadido correctamente un nuevo programa de formación'
                        : '❌ Error al agregar el nuevo programa de formación',
                    colorText: Colors.white,
                    backgroundColor:
                        resp ? Colors.green : Colors.red, // 💙 Celeste al crear
                  );
                } else {
                  // Editar programa existente
                  resp = await editTrainingProgramApi(
                    listItem['id'],
                    nameController.text,
                    levelController.text,
                    versionController.text,
                  );
                  Get.back();
                  Get.snackbar(
                    'Mensaje',
                    resp
                        ? '✏️ Se ha editado correctamente el programa de formación'
                        : '❌ Error al editar el programa de formación',
                    colorText: Colors.white,
                    backgroundColor:
                        resp ? Colors.green : Colors.red, // 🟧 Naranja al editar
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
                              controller: nameController,
                              decoration: customInputDecoration(
                                  'Nombre *', icon: Icons.book),
                              validator: (v) => (v == null || v.isEmpty)
                                  ? 'Campo obligatorio'
                                  : null,
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: levelController,
                              decoration: customInputDecoration('Nivel *',
                                  icon: Icons.stacked_line_chart),
                              validator: (v) => (v == null || v.isEmpty)
                                  ? 'Campo obligatorio'
                                  : null,
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: versionController,
                              decoration: customInputDecoration('Versión *',
                                  icon: Icons.verified),
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
