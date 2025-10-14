import 'package:app_projectretention_711_v1/api/apiRetention.dart';
import 'package:app_projectretention_711_v1/main.dart';
import 'package:app_projectretention_711_v1/views/causes/editNewCause.dart';
import 'package:app_projectretention_711_v1/views/causes/viewDeleteCause.dart';
import 'package:app_projectretention_711_v1/views/causes/viewItemCause.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewCausesCPIC extends StatefulWidget {
  const ViewCausesCPIC({super.key});

  @override
  State<ViewCausesCPIC> createState() => _ViewCausesCPICState();
}

class _ViewCausesCPICState extends State<ViewCausesCPIC> {
  @override
  void initState() {
    super.initState();
    fetchAPICauses(); // Cargar causas al iniciar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // viewCreateCause(context);
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Obx(
        () => myReactController.getListCauses.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.warning_amber_rounded, size: 90, color: Colors.grey[400]),
                    SizedBox(height: 18),
                    Text(
                      'No hay causas registradas',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Presiona el botón + para agregar una nueva',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                itemCount: myReactController.getListCauses.length,
                itemBuilder: (BuildContext context, int index) {
                  final itemList = myReactController.getListCauses[index];
                  final cause = itemList['cause'] ?? 'Sin causa';
                  final variable = itemList['variable'] ?? 'Sin variable';
                  final category = itemList['category']?['name'] ?? 'Sin categoría';

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
                                    children: [
                                      Icon(Icons.warning_amber_rounded,
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
                            ],
                          ),

                          SizedBox(width: 20),

                          // Contenido principal
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cause,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 12),
                                Row(
                                  children: [
                                    Icon(Icons.scatter_plot_outlined,
                                        size: 18, color: Colors.grey[600]),
                                    SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        'Variable: $variable',
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
                                    Icon(Icons.category_outlined,
                                        size: 18, color: Colors.grey[600]),
                                    SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        'Categoría: $category',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[700],
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          SizedBox(width: 14),

                          // Acciones
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                tooltip: 'Ver causa',
                                onPressed: () {
                                  viewItemCause(context, itemList);
                                },
                                icon: Icon(Icons.visibility,
                                    color: Colors.blue, size: 26),
                              ),
                              IconButton(
                                tooltip: 'Editar causa',
                                onPressed: () async {
                                  await modalEditNewCause(
                                      context, "edit", itemList);
                                },
                                icon: Icon(Icons.edit,
                                    color: Colors.orange, size: 26),
                              ),
                              IconButton(
                                tooltip: 'Eliminar causa',
                                onPressed: () {
                                  viewDeleteCause(context, itemList);
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
