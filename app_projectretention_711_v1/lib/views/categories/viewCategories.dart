import 'package:app_projectretention_711_v1/api/apiRetention.dart';
import 'package:app_projectretention_711_v1/main.dart';
import 'package:app_projectretention_711_v1/views/categories/editNewCategory.dart';
import 'package:app_projectretention_711_v1/views/categories/viewDeleteCategory.dart';
import 'package:app_projectretention_711_v1/views/categories/viewItemCategory.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewCategoriesCPIC extends StatefulWidget {
  const ViewCategoriesCPIC({super.key});

  @override
  State<ViewCategoriesCPIC> createState() => _ViewCategoriesCPICState();
}

class _ViewCategoriesCPICState extends State<ViewCategoriesCPIC> {
  @override
  void initState() {
    super.initState();
    fetchAPICategories(); // Método que trae las categorías
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          modalEditNewCategory(context, "new", null);
        },
        backgroundColor: const Color.fromARGB(255, 7, 25, 83),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Obx(
        () => myReactController.getListCategories.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.category, size: 90, color: Colors.grey[400]),
                    const SizedBox(height: 18),
                    Text(
                      'No hay categorías registradas',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                itemCount: myReactController.getListCategories.length,
                itemBuilder: (BuildContext context, int index) {
                  final itemList = myReactController.getListCategories[index];
                  final id = itemList['id'].toString();
                  final name = itemList['name'] ?? 'Sin nombre';
                  final description =
                      itemList['description'] ?? 'Sin descripción';
                  final addressing =
                      itemList['addressing'] ?? 'Sin orientación';

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
                          // Ícono e ID
                          Column(
                            children: [
                              Container(
                                width: 65,
                                height: 65,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 230, 240, 255),
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
                                      const Icon(Icons.category,
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
                                // Nombre con ellipsis
                                Text(
                                  'Nombre: $name',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                    color: Colors.black87,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                const SizedBox(height: 12),

                                Row(
                                  children: [
                                    const Icon(Icons.description,
                                        size: 18, color: Colors.grey),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        'Descripción: $description',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[700],
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                Row(
                                  children: [
                                    const Icon(Icons.map,
                                        size: 18, color: Colors.grey),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        'Orientación: $addressing',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[700],
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
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
                                tooltip: 'Ver categoría',
                                onPressed: () {
                                  viewItemCategory(context, itemList);
                                },
                                icon: const Icon(Icons.visibility,
                                    color: Colors.blue,
                                    size: 26),
                              ),
                              IconButton(
                                tooltip: 'Editar categoría',
                                onPressed: () async {
                                  await modalEditNewCategory(
                                      context, "edit", itemList);
                                },
                                icon: const Icon(Icons.edit,
                                    color: Colors.orange, size: 26),
                              ),
                              IconButton(
                                tooltip: 'Eliminar categoría',
                                onPressed: () {
                                  viewDeleteCategory(context, itemList);
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
