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
    // Aquí puedes inicializar cualquier cosa que necesites antes de que se construya el widget
    fetchAPIApprentices();         // Metodo que trae los aprendices 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Boton flotante para crear
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Llamamos la función para crear el aprendiz
          //viewCreateApprentice(context);
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue, // Personaliza el color
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: myReactController.getListApprentices.length,
          itemBuilder: (BuildContext context, int index) {
            final itemList = myReactController.getListApprentices[index];
            return Card(
              child: ListTile(
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.school), 
                    Text(itemList['id'].toString()),
                  ],
                ),
                title: Text('${itemList['firtsName']} ${itemList['lastName']}' ?? 'Sin nombre'),
                subtitle: Text('${itemList['document']} - ${itemList['status']}' ?? 'Sin información'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(onPressed: (){
                      viewItemApprentice(context, itemList);
                    }, icon: Icon( Icons.visibility)),
                    IconButton(onPressed: () async {
                      await modalEditNewApprentice(context, "edit", itemList);
                    }, icon: Icon(Icons.edit)),
                    IconButton(onPressed: (){
                      viewDeleteApprentice(context, itemList);
                    }, icon: Icon(Icons.delete)),

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