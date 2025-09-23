import 'package:app_projectretention_711_v1/api/apiRetention.dart';
import 'package:app_projectretention_711_v1/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//**********Controladores para los campos de Aprendices**********//
final TextEditingController documentTypeController = TextEditingController();
final TextEditingController documentController = TextEditingController();
final TextEditingController firstNameController = TextEditingController();
final TextEditingController lastNameController = TextEditingController();
final TextEditingController phoneController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController statusController = TextEditingController();
final TextEditingController quarterController = TextEditingController();
final TextEditingController groupIdController = TextEditingController();

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
      if (option == "new") {
        // Limpiar campos para nuevo aprendiz
        documentTypeController.clear();
        documentController.clear();
        firstNameController.clear();
        lastNameController.clear();
        phoneController.clear();
        emailController.clear();
        statusController.clear();
        quarterController.clear();
        groupIdController.clear();

        // Inicializar valores por defecto
        selectedDocumentType = null;
        selectedStatus = null;
        selectedQuarter = null;
        selectedGroupId = null;
      } else {
        // Cargar datos existentes para editar
        documentTypeController.text = listItem['documentType'] ?? '';
        documentController.text = listItem['document'] ?? '';
        firstNameController.text = listItem['firtsName'] ?? '';
        lastNameController.text = listItem['lastName'] ?? '';
        phoneController.text = listItem['phone'] ?? '';
        emailController.text = listItem['email'] ?? '';
        statusController.text = listItem['status'] ?? '';
        quarterController.text = listItem['quarter'] ?? '';
        groupIdController.text = listItem['fkIdGroups']?.toString() ?? '';

        // Validar y asignar valores para los dropdowns
        List<String> validDocTypes = ['CC', 'TI'];
        List<String> validStatus = ['En formación', 'En práctica', 'Certificado', 'Desertado'];
        List<String> validQuarters = List.generate(9, (i) => (i + 1).toString());

        selectedDocumentType =
            validDocTypes.contains(listItem['documentType']) ? listItem['documentType'] : null;
        selectedStatus = validStatus.contains(listItem['status']) ? listItem['status'] : null;
        selectedQuarter = validQuarters.contains(listItem['quarter']?.toString())
            ? listItem['quarter']?.toString()
            : null;
        selectedGroupId = listItem['fkIdGroups']?.toString();
      }

      return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
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
                  Get.snackbar('Campos incompletos', 'Por favor, complete todos los campos obligatorios',
                      colorText: Colors.white, backgroundColor: Colors.orange);
                  return;
                }

                if (option == "new") {
                  // Crear nuevo aprendiz
                  bool resp = await newApprenticeApi(
                    selectedDocumentType ?? 'CC',
                    documentController.text,
                    firstNameController.text,
                    lastNameController.text,
                    phoneController.text,
                    emailController.text,
                    selectedStatus ?? 'En formación',
                    selectedQuarter ?? '1',
                    selectedGroupId ?? '',
                  );
                  Get.back();
                  if (resp) {
                    Get.snackbar('Mensaje', "Se ha añadido correctamente un nuevo aprendiz",
                        colorText: Colors.white, backgroundColor: Colors.green);
                  } else {
                    Get.snackbar('Mensaje', "Error al agregar el nuevo aprendiz",
                        colorText: Colors.white, backgroundColor: Colors.red);
                  }
                } else {
                  // Editar aprendiz existente
                  bool resp = await editApprenticeApi(
                    listItem['id'],
                    selectedDocumentType ?? 'CC',
                    documentController.text,
                    firstNameController.text,
                    lastNameController.text,
                    phoneController.text,
                    emailController.text,
                    selectedStatus ?? 'En formación',
                    selectedQuarter ?? '1',
                    selectedGroupId ?? '',
                  );
                  Get.back();
                  if (resp) {
                    Get.snackbar('Mensaje', "Se ha editado correctamente el aprendiz",
                        colorText: Colors.green, backgroundColor: Colors.greenAccent);
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
                      DropdownMenuItem(value: 'CC', child: Text('Cédula de ciudadanía')),
                      DropdownMenuItem(value: 'TI', child: Text('Tarjeta de identidad')),
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedDocumentType = newValue;
                        documentTypeController.text = newValue ?? 'CC';
                      });
                    },
                    validator: (value) => value == null ? 'Este campo es obligatorio' : null,
                  ),

                  SizedBox(height: 16),

                  TextFormField(
                    controller: documentController,
                    decoration: InputDecoration(
                      labelText: 'Documento *',
                      hintText: 'Ingrese número de documento',
                    ),
                    validator: (value) =>
                        (value == null || value.isEmpty) ? 'Este campo es obligatorio' : null,
                  ),

                  TextFormField(
                    controller: firstNameController,
                    decoration: InputDecoration(
                      labelText: 'Nombre *',
                      hintText: 'Ingrese el nombre del aprendiz',
                    ),
                    validator: (value) =>
                        (value == null || value.isEmpty) ? 'Este campo es obligatorio' : null,
                  ),

                  TextFormField(
                    controller: lastNameController,
                    decoration: InputDecoration(
                      labelText: 'Apellido *',
                      hintText: 'Ingrese el apellido del aprendiz',
                    ),
                    validator: (value) =>
                        (value == null || value.isEmpty) ? 'Este campo es obligatorio' : null,
                  ),

                  TextFormField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      labelText: 'Teléfono',
                      hintText: 'Ingrese el teléfono',
                    ),
                  ),

                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email *',
                      hintText: 'Ingrese el email',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Este campo es obligatorio';
                      if (!value.contains('@')) return 'Ingrese un email válido';
                      return null;
                    },
                  ),

                  SizedBox(height: 16),

                  // Dropdown para Estado del aprendiz
                  DropdownButtonFormField<String>(
                    value: selectedStatus,
                    decoration: InputDecoration(
                      labelText: 'Estado *',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    ),
                    hint: Text('Seleccione el estado'),
                    items: [
                      DropdownMenuItem(value: 'En formación', child: Text('En formación')),
                      DropdownMenuItem(value: 'En práctica', child: Text('En práctica')),
                      DropdownMenuItem(value: 'Certificado', child: Text('Certificado')),
                      DropdownMenuItem(value: 'Desertado', child: Text('Desertado')),
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedStatus = newValue;
                        statusController.text = newValue ?? '';
                      });
                    },
                    validator: (value) => value == null ? 'Este campo es obligatorio' : null,
                  ),

                  SizedBox(height: 16),

                  // Dropdown para Trimestre
                  DropdownButtonFormField<String>(
                    value: selectedQuarter,
                    decoration: InputDecoration(
                      labelText: 'Trimestre *',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    ),
                    hint: Text('Seleccione el trimestre'),
                    items: List.generate(9, (index) {
                      int trimestre = index + 1;
                      return DropdownMenuItem(
                        value: trimestre.toString(),
                        child: Text('Trimestre $trimestre'),
                      );
                    }),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedQuarter = newValue;
                        quarterController.text = newValue ?? '1';
                      });
                    },
                    validator: (value) => value == null ? 'Este campo es obligatorio' : null,
                  ),

                  SizedBox(height: 16),

                  // Dropdown para Grupo
                  DropdownButtonFormField<String>(
                    value: selectedGroupId != null &&
                            myReactController.getListGroups
                                .any((g) => g['id'].toString() == selectedGroupId)
                        ? selectedGroupId
                        : null,
                    decoration: InputDecoration(
                      labelText: 'Grupo *',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    ),
                    hint: Text('Seleccione un grupo'),
                    items:
                        myReactController.getListGroups.map<DropdownMenuItem<String>>((group) {
                      return DropdownMenuItem<String>(
                        value: group['id'].toString(),
                        child: Text('${group['file']} - ${group['managerName']}'),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedGroupId = newValue;
                        groupIdController.text = newValue ?? '';
                      });
                    },
                    validator: (value) => value == null ? 'Este campo es obligatorio' : null,
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
