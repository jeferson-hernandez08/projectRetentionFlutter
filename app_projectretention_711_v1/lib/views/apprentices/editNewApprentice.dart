import 'package:app_projectretention_711_v1/api/apiRetention.dart';
import 'package:app_projectretention_711_v1/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//********** Controladores para los campos de Aprendices **********//
final TextEditingController documentTypeController = TextEditingController();
final TextEditingController documentController = TextEditingController();
final TextEditingController firstNameController = TextEditingController();
final TextEditingController lastNameController = TextEditingController();
final TextEditingController phoneController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController statusController = TextEditingController();
final TextEditingController quarterController = TextEditingController();
final TextEditingController groupIdController = TextEditingController();

modalEditNewApprentice(BuildContext context, String option, dynamic listItem) {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? selectedDocumentType;
  String? selectedStatus;
  String? selectedQuarter;
  String? selectedGroupId;

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      if (option == "new") {
        documentTypeController.clear();
        documentController.clear();
        firstNameController.clear();
        lastNameController.clear();
        phoneController.clear();
        emailController.clear();
        statusController.clear();
        quarterController.clear();
        groupIdController.clear();

        selectedDocumentType = null;
        selectedStatus = null;
        selectedQuarter = null;
        selectedGroupId = null;
      } else {
        documentTypeController.text = listItem['documentType'] ?? '';
        documentController.text = listItem['document'] ?? '';
        firstNameController.text = listItem['firtsName'] ?? '';
        lastNameController.text = listItem['lastName'] ?? '';
        phoneController.text = listItem['phone'] ?? '';
        emailController.text = listItem['email'] ?? '';
        statusController.text = listItem['status'] ?? '';
        quarterController.text = listItem['quarter'] ?? '';
        groupIdController.text = listItem['fkIdGroups']?.toString() ?? '';

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

      return StatefulBuilder(builder: (context, setState) {
        if (myReactController.getListGroups.isEmpty) {
          fetchAPIGroups().then((_) => setState(() {}));
        }

        InputDecoration customInputDecoration(String label, {IconData? icon}) {
          return InputDecoration(
            labelText: label,
            prefixIcon: icon != null
                ? Icon(icon, color: const Color.fromARGB(255, 7, 25, 83))
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

        return Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          appBar: AppBar(
            title: Text(
              (option == "new") ? 'Nuevo Aprendiz' : 'Editar Aprendiz',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color.fromARGB(255, 7, 25, 83),
            foregroundColor: Colors.white,
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: const Color.fromARGB(255, 7, 25, 83),
            foregroundColor: Colors.white,
            icon: Icon(option == "new" ? Icons.person_add : Icons.edit),
            label: Text(option == "new" ? 'Crear' : 'Guardar'),
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
                resp = await newApprenticeApi(
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
                Get.snackbar(
                  'Mensaje',
                  resp
                      ? 'Se ha añadido correctamente un nuevo aprendiz'
                      : 'Error al agregar el nuevo aprendiz',
                  colorText: Colors.white,
                  backgroundColor:
                      resp ? const Color.fromARGB(255, 7, 25, 83) : Colors.red,
                );
              } else {
                resp = await editApprenticeApi(
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
                Get.snackbar(
                  'Mensaje',
                  resp
                      ? 'Se ha editado correctamente el aprendiz'
                      : 'Error al editar el aprendiz',
                  colorText: Colors.white,
                  backgroundColor:
                      resp ? const Color.fromARGB(255, 7, 25, 83) : Colors.red,
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          DropdownButtonFormField<String>(
                            value: selectedDocumentType,
                            decoration:
                                customInputDecoration('Tipo de Documento *', icon: Icons.badge),
                            items: const [
                              DropdownMenuItem(value: 'CC', child: Text('Cédula de ciudadanía')),
                              DropdownMenuItem(value: 'TI', child: Text('Tarjeta de identidad')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                selectedDocumentType = value;
                                documentTypeController.text = value ?? 'CC';
                              });
                            },
                            validator: (value) =>
                                value == null ? 'Campo obligatorio' : null,
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: documentController,
                            decoration:
                                customInputDecoration('Documento *', icon: Icons.credit_card),
                            validator: (v) =>
                                (v == null || v.isEmpty) ? 'Campo obligatorio' : null,
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: firstNameController,
                            decoration: customInputDecoration('Nombre *', icon: Icons.person),
                            validator: (v) =>
                                (v == null || v.isEmpty) ? 'Campo obligatorio' : null,
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: lastNameController,
                            decoration:
                                customInputDecoration('Apellido *', icon: Icons.person_outline),
                            validator: (v) =>
                                (v == null || v.isEmpty) ? 'Campo obligatorio' : null,
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: phoneController,
                            decoration: customInputDecoration('Teléfono', icon: Icons.phone),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: emailController,
                            decoration: customInputDecoration('Email *', icon: Icons.email),
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Campo obligatorio';
                              if (!v.contains('@')) return 'Ingrese un email válido';
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          DropdownButtonFormField<String>(
                            value: selectedStatus,
                            decoration: customInputDecoration('Estado *', icon: Icons.school),
                            items: const [
                              DropdownMenuItem(value: 'En formación', child: Text('En formación')),
                              DropdownMenuItem(value: 'En práctica', child: Text('En práctica')),
                              DropdownMenuItem(value: 'Certificado', child: Text('Certificado')),
                              DropdownMenuItem(value: 'Desertado', child: Text('Desertado')),
                            ],
                            onChanged: (v) {
                              setState(() {
                                selectedStatus = v;
                                statusController.text = v ?? '';
                              });
                            },
                            validator: (v) => v == null ? 'Campo obligatorio' : null,
                          ),
                          const SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            value: selectedQuarter,
                            decoration: customInputDecoration('Trimestre *',
                                icon: Icons.format_list_numbered),
                            items: List.generate(
                              9,
                              (i) => DropdownMenuItem(
                                value: (i + 1).toString(),
                                child: Text('Trimestre ${i + 1}'),
                              ),
                            ),
                            onChanged: (v) {
                              setState(() {
                                selectedQuarter = v;
                                quarterController.text = v ?? '1';
                              });
                            },
                            validator: (v) => v == null ? 'Campo obligatorio' : null,
                          ),
                          const SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            value: selectedGroupId != null &&
                                    myReactController.getListGroups
                                        .any((g) => g['id'].toString() == selectedGroupId)
                                ? selectedGroupId
                                : null,
                            decoration: customInputDecoration('Grupo *', icon: Icons.group),
                            items: myReactController.getListGroups
                                .map<DropdownMenuItem<String>>((group) => DropdownMenuItem<String>(
                                      value: group['id'].toString(),
                                      child:
                                          Text('${group['file']} - ${group['managerName']}'),
                                    ))
                                .toList(),
                            onChanged: (v) {
                              setState(() {
                                selectedGroupId = v;
                                groupIdController.text = v ?? '';
                              });
                            },
                            validator: (v) => v == null ? 'Campo obligatorio' : null,
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
