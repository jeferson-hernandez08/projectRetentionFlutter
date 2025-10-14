import 'package:app_projectretention_711_v1/api/apiRetention.dart';
import 'package:app_projectretention_711_v1/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controladores de texto para los campos de la estrategia
final TextEditingController strategyController = TextEditingController();
final TextEditingController categoryIdController = TextEditingController();

modalEditNewStrategy(context, option, dynamic listItem) {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectedCategoryId;

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      if (option == "new") {
        strategyController.clear();
        categoryIdController.clear();
        selectedCategoryId = null;
      } else {
        strategyController.text = listItem['strategy'] ?? '';
        String categoryValue = listItem['fkIdCategories']?.toString() ?? '';
        selectedCategoryId = categoryValue.isNotEmpty ? categoryValue : null;
        categoryIdController.text = selectedCategoryId ?? '';
      }

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          // Si no hay categorías, las traemos
          if (myReactController.getListCategories.isEmpty) {
            fetchAPICategories().then((_) {
              setState(() {});
            });
          }

          // 🎨 Colores personalizados para íconos (mismo estilo que Aprendiz)
          InputDecoration customInputDecoration(String label, {IconData? icon}) {
            Color iconColor;
            switch (icon) {
              case Icons.lightbulb:
                iconColor = Colors.amber; // 💡 Amarillo brillante
                break;
              case Icons.category:
                iconColor = Colors.deepPurple; // 💜 Categoría
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
                (option == "new") ? 'Nueva Estrategia' : 'Editar Estrategia',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: const Color.fromARGB(255, 7, 25, 83),
              foregroundColor: Colors.white,
              centerTitle: true,
            ),
            floatingActionButton: FloatingActionButton.extended(
              backgroundColor: option == "new"
                  ? const Color(0xFF00BFFF) // 💙 Celeste para crear
                  : Colors.orange, // 🟧 Naranja para editar
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
                  resp = await newStrategyApi(
                    strategyController.text,
                    selectedCategoryId ?? '',
                  );
                  Get.back();
                  Get.snackbar(
                    'Mensaje',
                    resp
                        ? 'Se ha añadido correctamente una nueva estrategia'
                        : 'Error al agregar la estrategia',
                    colorText: Colors.white,
                    backgroundColor: resp ? Colors.green : Colors.red, // ✅🟥
                  );
                } else {
                  resp = await editStrategyApi(
                    listItem['id'],
                    strategyController.text,
                    selectedCategoryId ?? '',
                  );
                  Get.back();
                  Get.snackbar(
                    'Mensaje',
                    resp
                        ? 'Se ha editado correctamente la estrategia'
                        : 'Error al editar la estrategia',
                    colorText: Colors.white,
                    backgroundColor: resp ? Colors.green : Colors.red, // ✅🟥
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
                            // Campo Estrategia
                            TextFormField(
                              controller: strategyController,
                              decoration: customInputDecoration(
                                'Estrategia *',
                                icon: Icons.lightbulb,
                              ),
                              validator: (v) => (v == null || v.isEmpty)
                                  ? 'Campo obligatorio'
                                  : null,
                            ),
                            const SizedBox(height: 10),

                            // Dropdown Categoría actualizado
                            DropdownButtonFormField<String>(
                              value: selectedCategoryId,
                              decoration: customInputDecoration(
                                  'Categoría *', icon: Icons.category),
                              hint: const Text('Seleccione una categoría'),
                              selectedItemBuilder: (BuildContext context) {
                                return myReactController.getListCategories
                                    .map<Widget>((cat) {
                                  String name = cat['name'] ?? 'Sin nombre';
                                  String displayName = name.length > 35
                                      ? '${name.substring(0, 35)}...'
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
                                  categoryIdController.text = newValue ?? '';
                                });
                              },
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
