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
    // Aquí puedes inicializar cualquier cosa que necesites antes de que se construya el widget
    fetchAPICauses();         // Método del ambiente que trae las causas
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Botón flotante para crear
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Llamamos la función para crear una nueva causa
          //viewCreateCause(context);
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue, // Personaliza el color
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: myReactController.getListCauses.length,
          itemBuilder: (BuildContext context, int index) {
            final itemList = myReactController.getListCauses[index];
            return Card(
              child: ListTile(
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.warning_amber_outlined), // Icono representativo de "causa"
                    Text(itemList['id'].toString()),
                  ],
                ),
                title: Text(itemList['cause'] ?? 'Sin causa'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(itemList['variable'] ?? 'Sin variable'),
                    Text(itemList['category']?['name'] ?? 'Sin categoría'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(onPressed: (){
                      viewItemCause(context, itemList);
                    }, icon: const Icon(Icons.visibility)),
                    IconButton(onPressed: () async {
                      await modalEditNewCause(context, "edit", itemList);
                    }, icon: const Icon(Icons.edit)),
                    IconButton(onPressed: (){
                      viewDeleteCause(context, itemList);
                    }, icon: const Icon(Icons.delete)),
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
