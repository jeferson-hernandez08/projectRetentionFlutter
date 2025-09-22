import 'package:app_projectretention_711_v1/api/apiRetention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

viewDeleteTrainingProgram(context, itemList) {
  showModalBottomSheet(
  context: context,
  isScrollControlled: true,  
    builder: (context) {
      return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text('Confirmar Eliminación del Programa de Formación'),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          centerTitle: true,     // Propiedad para centrar el titulo
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Creación de tarjeta de confirmación junto con los botones de confirmación
              Card(
                elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        // Icono de advertencia
                        const Icon(
                          Icons.warning_amber_rounded,
                          size: 60,
                          color: Colors.orange,
                        ),
                        const SizedBox(height: 20),
                        
                        // Título
                        const Text(
                          '¿Eliminar este programa de formación?',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15),
                        
                        // Nombre del programa de formación
                        Text(
                          '${itemList['name']}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        
                        // Nivel del programa
                        Text(
                          'Nivel: ${itemList['level']}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 5),
                        
                        // Versión del programa
                        Text(
                          'Versión: ${itemList['version']}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 5),
                        
                        // ID del programa
                        Text(
                          'ID: ${itemList['id']}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 25),
                        
                        // Botones de acción
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Botón Cancelar
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(context),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  side: const BorderSide(color: Colors.blue),
                                ),
                                child: const Text(
                                  'Cancelar',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            
                            // Botón Eliminar
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  try {
                                    // Lógica para eliminar el programa de formación | Llamamos la función API apiRetention.dart
                                    await deleteTrainingProgramApi(itemList['id']);  
                                    
                                    // Cerrar el modal
                                    Navigator.pop(context);
                                    
                                    // Mostramos mensaje de éxito
                                    Get.snackbar(
                                      'Éxito',
                                      'Programa de formación eliminado correctamente',
                                      backgroundColor: Colors.green,
                                      colorText: Colors.white,
                                      duration: const Duration(seconds: 2),
                                    );
                                    
                                    // Actualizamos la lista de programas de formación
                                    fetchAPITrainingPrograms();
                                    
                                  } catch (e) {
                                    Get.snackbar(
                                      'Error',
                                      'Error al eliminar programa de formación: ${e.toString()}',
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                ),
                                child: const Text(
                                  'Eliminar',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                ),

                // Información adicional
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    'Después de eliminar, esta acción no se puede deshacer.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),

            ],
          ),
        ),
      );
    }
  );

}