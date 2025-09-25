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
    // Aquí puedes inicializar cualquier cosa que necesites antes de que se construya el widget
    fetchAPIStrategies();   // Método que trae las estrategias desde la API
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Botón flotante para crear
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Llamamos la función para crear una nueva estrategia
          //viewCreateStrategy(context);
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue, // Personaliza el color
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: myReactController.getListStrategies.length,
          itemBuilder: (BuildContext context, int index) {
            final itemList = myReactController.getListStrategies[index];
            return Card(
              child: ListTile(
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.lightbulb), 
                    Text(itemList['id'].toString()), // Mostramos el ID de la estrategia
                  ],
                ),
                title: Text(itemList['strategy'] ?? 'Sin estrategia'),
                subtitle: Text(
                  itemList['category'] != null 
                    ? itemList['category']['name'] ?? 'Sin categoría' 
                    : 'Sin categoría',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        viewItemStrategy(context, itemList);
                      }, 
                      icon: const Icon(Icons.visibility),
                    ),
                    IconButton(
                      onPressed: () async {
                        await modalEditNewStrategy(context, "edit", itemList);
                      }, 
                      icon: const Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () {
                        viewDeleteStrategy(context, itemList);
                      }, 
                      icon: const Icon(Icons.delete),
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
