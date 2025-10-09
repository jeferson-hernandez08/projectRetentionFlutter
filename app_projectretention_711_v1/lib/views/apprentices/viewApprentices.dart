import 'package:app_projectretention_711_v1/api/apiRetention.dart';
import 'package:app_projectretention_711_v1/main.dart';
import 'package:app_projectretention_711_v1/views/apprentices/editNewApprentice.dart';
import 'package:app_projectretention_711_v1/views/apprentices/viewDeleteApprentice.dart';
import 'package:app_projectretention_711_v1/views/apprentices/viewItemApprentice.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewApprenticesCPIC extends StatefulWidget {
  const ViewApprenticesCPIC({super.key});

  @override
  State<ViewApprenticesCPIC> createState() => _ViewApprenticesCPICState();
}

class _ViewApprenticesCPICState extends State<ViewApprenticesCPIC> {
  @override
  void initState() {
    super.initState();
    fetchAPIApprentices(); // Método que trae los aprendices
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Activo':
        return Colors.green;
      case 'Inactivo':
        return Colors.red;
      case 'Suspendido':
        return Colors.orange;
      default:
        return Colors.blueGrey;
    }
  }

  IconData? _getStatusIcon(String status) {
    switch (status) {
      case 'Activo':
        return Icons.check_circle;
      case 'Inactivo':
        return Icons.cancel;
      case 'Suspendido':
        return Icons.pause_circle;
      default:
        return null; // 🔹 sin ícono de interrogación
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // viewCreateApprentice(context);
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Obx(
        () => myReactController.getListApprentices.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.school, size: 90, color: Colors.grey[400]),
                    SizedBox(height: 18),
                    Text(
                      'No hay aprendices registrados',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Presiona el botón + para agregar uno nuevo',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                itemCount: myReactController.getListApprentices.length,
                itemBuilder: (BuildContext context, int index) {
                  final itemList = myReactController.getListApprentices[index];
                  final fullName =
                      '${itemList['firtsName'] ?? ''} ${itemList['lastName'] ?? ''}';
                  final document = itemList['document'] ?? 'Sin documento';
                  final status = itemList['status'] ?? 'Desconocido';

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Columna izquierda
                          Column(
                            children: [
                              Container(
                                width: 65,
                                height: 65,
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: Colors.blue,
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.school,
                                          color: Colors.blue, size: 26),
                                      SizedBox(height: 4),
                                      Text(
                                        'ID: ${itemList['id']}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 12),

                              // Estado
                              if (_getStatusIcon(status) != null)
                                Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(status)
                                        .withOpacity(0.1),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: _getStatusColor(status),
                                      width: 2,
                                    ),
                                  ),
                                  child: Icon(
                                    _getStatusIcon(status),
                                    color: _getStatusColor(status),
                                    size: 20,
                                  ),
                                ),
                            ],
                          ),

                          SizedBox(width: 20),

                          // Contenido principal
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  fullName.isNotEmpty
                                      ? fullName
                                      : 'Sin nombre asignado',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 12),
                                Row(
                                  children: [
                                    Icon(Icons.badge,
                                        size: 18, color: Colors.grey[600]),
                                    SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        'Documento: $document',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[700],
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                Row(
                                  children: [
                                    Icon(Icons.info_outline,
                                        size: 18, color: Colors.grey[600]),
                                    SizedBox(width: 6),
                                    Text(
                                      'Estado: ',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      status,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: _getStatusColor(status),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          SizedBox(width: 14),

                          // Acciones rápidas
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                tooltip: 'Ver aprendiz',
                                onPressed: () {
                                  viewItemApprentice(context, itemList);
                                },
                                icon: Icon(Icons.visibility,
                                    color: Colors.blue, size: 26),
                              ),
                              IconButton(
                                tooltip: 'Editar aprendiz',
                                onPressed: () async {
                                  await modalEditNewApprentice(
                                      context, "edit", itemList);
                                },
                                icon: Icon(Icons.edit,
                                    color: Colors.orange, size: 26),
                              ),
                              IconButton(
                                tooltip: 'Eliminar aprendiz',
                                onPressed: () {
                                  viewDeleteApprentice(context, itemList);
                                },
                                icon: Icon(Icons.delete,
                                    color: Colors.red, size: 26),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
