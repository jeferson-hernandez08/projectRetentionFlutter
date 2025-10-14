import 'package:app_projectretention_711_v1/api/apiRetention.dart';
import 'package:app_projectretention_711_v1/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controladores de texto
final TextEditingController causeController = TextEditingController();
final TextEditingController variableController = TextEditingController();
final TextEditingController fkIdCategoriesController = TextEditingController();

modalEditNewCause(context, option, dynamic listItem) {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectedCategoryId;

  showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) {
      if (option == "new") {
        causeController.clear();
        variableController.clear();
        fkIdCategoriesController.clear();
        selectedCategoryId = null;
      } else {
        causeController.text = listItem['cause'] ?? '';
        variableController.text = listItem['variable'] ?? '';
        String categoryValue = listItem['fkIdCategories']?.toString() ?? '';
        selectedCategoryId = categoryValue.isNotEmpty ? categoryValue : null;
        fkIdCategoriesController.text = selectedCategoryId ?? '';
      }

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          if (myReactController.getListCategories.isEmpty) {
            fetchAPICategories().then((_) => setState(() {}));
          }

          // 🎨 Íconos con colores personalizados
          InputDecoration customInputDecoration(String label, {IconData? icon}) {
            Color iconColor;
            switch (icon) {
              case Icons.warning_amber_rounded:
                iconColor = Colors.redAccent;
                break;
              case Icons.category_outlined:
                iconColor = Colors.deepPurple;
                break;
              case Icons.layers:
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

          // Función para mostrar nombre seleccionado con "..."
          String getSelectedCategoryName() {
            if (selectedCategoryId == null) return 'Seleccione una categoría';
            final category = myReactController.getListCategories.firstWhere(
              (cat) => cat['id'].toString() == selectedCategoryId,
              orElse: () => {'name': ''},
            );
            String name = category['name'] ?? '';
            return name.length > 34 ? '${name.substring(0, 34)}...' : name;
          }

          return Scaffold(
            backgroundColor: const Color(0xFFF5F5F5),
            appBar: AppBar(
              title: Text(
                (option == "new") ? 'Nueva Causa' : 'Editar Causa',
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
                  resp = await newCauseApi(
                    causeController.text,
                    variableController.text,
                    selectedCategoryId ?? '',
                  );
                  Get.back();
                  Get.snackbar(
                    'Mensaje',
                    resp
                        ? 'Se ha añadido correctamente una nueva causa'
                        : 'Error al agregar la nueva causa',
                    colorText: Colors.white,
                    backgroundColor:
                        resp ? Colors.green : Colors.red, // ✅🟥
                  );
                } else {
                  resp = await editCauseApi(
                    listItem['id'],
                    causeController.text,
                    variableController.text,
                    selectedCategoryId ?? '',
                  );
                  Get.back();
                  Get.snackbar(
                    'Mensaje',
                    resp
                        ? 'Se ha editado correctamente la causa'
                        : 'Error al editar la causa',
                    colorText: Colors.white,
                    backgroundColor:
                        resp ? Colors.green : Colors.red, // ✅🟥
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
                              controller: causeController,
                              decoration: customInputDecoration(
                                  'Causa *', icon: Icons.warning_amber_rounded),
                              validator: (v) => (v == null || v.isEmpty)
                                  ? 'Campo obligatorio'
                                  : null,
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: variableController,
                              decoration: customInputDecoration(
                                  'Variable *', icon: Icons.category_outlined),
                              validator: (v) => (v == null || v.isEmpty)
                                  ? 'Campo obligatorio'
                                  : null,
                            ),
                            const SizedBox(height: 10),

                            // Dropdown actualizado
                            DropdownButtonFormField<String>(
                              value: selectedCategoryId,
                              decoration: customInputDecoration(
                                  'Categoría *', icon: Icons.layers),
                              hint: const Text('Seleccione una categoría'),
                              selectedItemBuilder: (BuildContext context) {
                                return myReactController.getListCategories
                                    .map<Widget>((cat) {
                                  String name = cat['name'] ?? 'Sin nombre';
                                  String displayName = name.length > 34
                                      ? '${name.substring(0, 34)}...'
                                      : name;
                                  return Text(
                                    displayName,
                                    overflow: TextOverflow.ellipsis,
                                  );
                                }).toList();
                              },
                              items: myReactController.getListCategories
                                  .map<DropdownMenuItem<String>>((cat) {
                                String name = cat['name'] ?? 'Sin nombre';
                                return DropdownMenuItem<String>(
                                  value: cat['id'].toString(),
                                  child: Tooltip(
                                    message: name,
                                    child: Text(
                                      name,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedCategoryId = newValue;
                                  fkIdCategoriesController.text =
                                      newValue ?? '';
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Campo obligatorio';
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
