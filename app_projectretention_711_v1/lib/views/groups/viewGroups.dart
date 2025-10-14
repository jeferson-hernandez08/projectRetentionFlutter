import 'package:app_projectretention_711_v1/api/apiRetention.dart';
import 'package:app_projectretention_711_v1/main.dart';
import 'package:app_projectretention_711_v1/views/groups/editNewGroup.dart';
import 'package:app_projectretention_711_v1/views/groups/viewDeleteGroup.dart';
import 'package:app_projectretention_711_v1/views/groups/viewItemGroup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewGroupsCPIC extends StatefulWidget {
  const ViewGroupsCPIC({super.key});

  @override
  State<ViewGroupsCPIC> createState() => _ViewGroupsCPICState();
}

class _ViewGroupsCPICState extends State<ViewGroupsCPIC> {
  @override
  void initState() {
    super.initState();
    fetchAPIGroups(); // Método que trae los grupos
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // viewCreateGroup(context);
        },
        backgroundColor: const Color.fromARGB(255, 7, 25, 83),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Obx(
        () => myReactController.getListGroups.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.group, size: 90, color: Colors.grey[400]),
                    const SizedBox(height: 18),
                    Text(
                      'No hay grupos registrados',
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
                itemCount: myReactController.getListGroups.length,
                itemBuilder: (BuildContext context, int index) {
                  final itemList = myReactController.getListGroups[index];
                  final file = itemList['file'] ?? 'Sin ficha';
                  final managerName = itemList['managerName'] ?? 'Sin instructor';
                  final shift = itemList['shift'] ?? 'Sin jornada';
                  final id = itemList['id'].toString();

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
                          // Ícono del grupo e ID
                          Column(
                            children: [
                              Container(
                                width: 65,
                                height: 65,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 230, 240, 255),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: Colors.blue,
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.groups,
                                          color: Colors.blue,
                                          size: 26),
                                      const SizedBox(height: 4),
                                      Text(
                                        'ID: $id',
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

                          // Información principal
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ficha: $file',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                    color: Colors.black87,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    const Icon(Icons.person,
                                        size: 18, color: Colors.grey),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        'Instructor: $managerName',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[700],
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    const Icon(Icons.access_time,
                                        size: 18, color: Colors.grey),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Jornada: $shift',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
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
                                tooltip: 'Ver grupo',
                                onPressed: () {
                                  viewItemGroup(context, itemList);
                                },
                                icon: const Icon(Icons.visibility,
                                    color: Colors.blue,
                                    size: 26),
                              ),
                              IconButton(
                                tooltip: 'Editar grupo',
                                onPressed: () async {
                                  await modalEditNewGroup(
                                      context, "edit", itemList);
                                },
                                icon: const Icon(Icons.edit,
                                    color: Colors.orange, size: 26),
                              ),
                              IconButton(
                                tooltip: 'Eliminar grupo',
                                onPressed: () {
                                  viewDeleteGroup(context, itemList);
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
