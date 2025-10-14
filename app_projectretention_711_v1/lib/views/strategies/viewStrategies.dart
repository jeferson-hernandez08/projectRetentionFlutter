import 'package:app_projectretention_711_v1/api/apiRetention.dart';
import 'package:app_projectretention_711_v1/main.dart';
import 'package:app_projectretention_711_v1/views/strategies/editNewStrategy.dart';
import 'package:app_projectretention_711_v1/views/strategies/viewDeleteStrategy.dart';
import 'package:app_projectretention_711_v1/views/strategies/viewItemStrategy.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewStrategiesCPIC extends StatefulWidget {
  const ViewStrategiesCPIC({super.key});

  @override
  State<ViewStrategiesCPIC> createState() => _ViewStrategiesCPICState();
}

class _ViewStrategiesCPICState extends State<ViewStrategiesCPIC> {
  @override
  void initState() {
    super.initState();
    fetchAPIStrategies(); // Cargar estrategias desde la API
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Aquí puedes abrir el modal de nueva estrategia
          // modalEditNewStrategy(context, "new", {});
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Obx(
        () => myReactController.getListStrategies.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lightbulb_outline,
                        size: 90, color: Colors.grey[400]),
                    const SizedBox(height: 18),
                    Text(
                      'No hay estrategias registradas',
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
                itemCount: myReactController.getListStrategies.length,
                itemBuilder: (BuildContext context, int index) {
                  final itemList = myReactController.getListStrategies[index];
                  final strategy = itemList['strategy'] ?? 'Sin estrategia';
                  final categoryName = itemList['category'] != null
                      ? (itemList['category']['name'] ?? 'Sin categoría')
                      : 'Sin categoría';

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
                          // Icono e ID
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
                                      const Icon(Icons.lightbulb,
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
                                Tooltip(
                                  message: strategy,
                                  child: Text(
                                    strategy,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Icon(Icons.category,
                                        size: 18, color: Colors.grey[600]),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Tooltip(
                                        message: categoryName,
                                        child: Text(
                                          categoryName,
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey[700],
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
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
                                tooltip: 'Ver estrategia',
                                onPressed: () {
                                  viewItemStrategy(context, itemList);
                                },
                                icon: const Icon(Icons.visibility,
                                    color: Colors.blue, size: 26),
                              ),
                              IconButton(
                                tooltip: 'Editar estrategia',
                                onPressed: () async {
                                  await modalEditNewStrategy(
                                      context, "edit", itemList);
                                },
                                icon: const Icon(Icons.edit,
                                    color: Colors.orange, size: 26),
                              ),
                              IconButton(
                                tooltip: 'Eliminar estrategia',
                                onPressed: () {
                                  viewDeleteStrategy(context, itemList);
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
