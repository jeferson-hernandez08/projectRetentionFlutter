import 'package:app_projectretention_711_v1/api/apiRetention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final TextEditingController nameController = TextEditingController();

modalEditNewRol(context, option, dynamic listItem) {
  // Crear una clave global para el formulario | Para campo obligatorio
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  showModalBottomSheet(
    isScrollControlled: true,
    context: context, 
    builder: (context) {
      if(option == "new") { 
        nameController.clear();   // Limpiar campos
      } else {
        nameController.text = listItem['name'] ?? 'Sin nombre';
      }
      return Scaffold(
        appBar: AppBar(
          title: (option == "new") ? Text('Crear Nuevo Rol') : Text('Editar Rol'),
          backgroundColor: (option == "new") ? Colors.green : Colors.blue,
          foregroundColor: Colors.white,
          centerTitle: true,     // Propiedad para centrar el titulo
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: (option == "new") ? Colors.green : Colors.blue,
          foregroundColor: Colors.white,
          child: Icon(option == "new" ? Icons.add : Icons.edit),
          onPressed: () async {
            // Validar formulario antes de proceder para campo obligatorio
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
              // Lógica para crear un nuevo rol
              bool resp = await newRolApi(
                nameController.text
              );
              Get.back();  // Cerrar el modal
              if(resp) {
                Get.snackbar(
                  'Mensaje', "Se ha añadido correctamente un nuevo rol", 
                  colorText: Colors.white,
                  backgroundColor: Colors.green
                );
              } else {
                  Get.snackbar(
                    'Mensaje', "Error al agregar el nuevo rol", 
                    colorText: Colors.white,
                    backgroundColor: Colors.red
                  );
              }
              
            } else {   
              // En caso de editar el ambiente
              bool resp = await editRolApi(
                listItem['id'],
                nameController.text
              );
              Get.back();  // Cerrar el modal
              if(resp) {
                Get.snackbar(
                'Mensaje', "Se ha editado correctamente un nuevo rol", 
                colorText: Colors.green,
                backgroundColor: Colors.greenAccent
                );
              } else {
                  Get.snackbar('Mensaje', "Error al editar el nuevo rol", colorText: Colors.red);
              }
            }
           
          }),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(      // Form para campo obligatorio
              key: _formKey, // Asignar la clave al formulario para campo obligatorio
              child: ListView(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Nombre del Rol *',
                      hintText: 'Ingrese nombre del Rol',
                    ),
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