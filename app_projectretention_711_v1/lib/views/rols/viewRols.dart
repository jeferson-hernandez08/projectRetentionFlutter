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
    // Aquí puedes inicializar cualquier cosa que necesites antes de que se construya el widget
    fetchAPIRols();         // Metodo del ambiente que trae los roles 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Boton flotante para crear
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Llamamos la  función para crear el ambiente
          //viewCreateRol(context);
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue, // Personaliza el color
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: myReactController.getListRols.length,
          itemBuilder: (BuildContext context, int index) {
            final itemList = myReactController.getListRols[index];
            return Card(
              child: ListTile(
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.security), 
                    Text(itemList['id'].toString()),
                  ],
                ),
                title: Text(itemList['name']),
                subtitle: Text(itemList['name']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(onPressed: (){
                      viewItemRol(context, itemList);
                    }, icon: Icon( Icons.visibility)),
                    IconButton(onPressed: () async {
                      await modalEditNewRol(context, "edit", itemList);
                    }, icon: Icon(Icons.edit)),
                    IconButton(onPressed: (){
                      viewDeleteRol(context, itemList);
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




