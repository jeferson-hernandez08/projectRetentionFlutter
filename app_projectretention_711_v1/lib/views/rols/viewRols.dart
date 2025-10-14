import 'package:app_projectretention_711_v1/api/apiRetention.dart';
import 'package:app_projectretention_711_v1/main.dart';
import 'package:app_projectretention_711_v1/views/rols/editNewRol.dart';
import 'package:app_projectretention_711_v1/views/rols/viewDeleteRol.dart';
import 'package:app_projectretention_711_v1/views/rols/viewItemRol.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewRolsCPIC extends StatefulWidget {
  const ViewRolsCPIC({super.key});

  @override
  State<ViewRolsCPIC> createState() => _ViewRolsCPICState();
}

class _ViewRolsCPICState extends State<ViewRolsCPIC> {
  @override
  void initState() {
    super.initState();
    fetchAPIRols(); // Método del ambiente que trae los roles 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // viewCreateRol(context);
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Obx(
        () => myReactController.getListRols.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.security, size: 90, color: Colors.grey[400]),
                    const SizedBox(height: 18),
                    Text(
                      'No hay roles registrados',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                itemCount: myReactController.getListRols.length,
                itemBuilder: (BuildContext context, int index) {
                  final itemList = myReactController.getListRols[index];
                  final name = itemList['name'] ?? 'Sin nombre';

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Columna izquierda con ícono e ID
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
                                      const Icon(Icons.security,
                                          color: Colors.blue, size: 26),
                                      const SizedBox(height: 4),
                                      Text(
                                        'ID: ${itemList['id']}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(width: 20),

                          // Contenido principal
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 14),

                          // Acciones
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                tooltip: 'Ver rol',
                                onPressed: () {
                                  viewItemRol(context, itemList);
                                },
                                icon: const Icon(Icons.visibility,
                                    color: Colors.blue, size: 26),
                              ),
                              IconButton(
                                tooltip: 'Editar rol',
                                onPressed: () async {
                                  await modalEditNewRol(
                                      context, "edit", itemList);
                                },
                                icon: const Icon(Icons.edit,
                                    color: Colors.orange, size: 26),
                              ),
                              IconButton(
                                tooltip: 'Eliminar rol',
                                onPressed: () {
                                  viewDeleteRol(context, itemList);
                                },
                                icon: const Icon(Icons.delete,
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
