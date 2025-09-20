import 'package:app_projectretention_711_v1/api/apiRetention.dart';
import 'package:app_projectretention_711_v1/main.dart';
import 'package:app_projectretention_711_v1/views/users/editNewUser.dart';
import 'package:app_projectretention_711_v1/views/users/viewDeleteUser.dart';
import 'package:app_projectretention_711_v1/views/users/viewItemUser.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewUsersCPIC extends StatefulWidget {
  const ViewUsersCPIC({super.key});

  @override
  State<ViewUsersCPIC> createState() => _ViewUsersCPICState();
}

class _ViewUsersCPICState extends State<ViewUsersCPIC> {
  @override
  void initState() {
    super.initState();
    // Aquí puedes inicializar cualquier cosa que necesites antes de que se construya el widget
    fetchAPIUsers();         // Metodo del ambiente que trae los roles 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Boton flotante para crear
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Llamamos la  función para crear el ambiente
          //viewCreateUser(context);
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue, // Personaliza el color
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: myReactController.getListUsers.length,
          itemBuilder: (BuildContext context, int index) {
            final itemList = myReactController.getListUsers[index];
            return Card(
              child: ListTile(
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.people), 
                    Text(itemList['id'].toString()),
                  ],
                ),
                title: Text(itemList['firstName'] ?? 'Sin nombre'),
                subtitle: Text(itemList['email'] ?? 'Sin email'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(onPressed: (){
                      viewItemUser(context, itemList);
                    }, icon: Icon( Icons.visibility)),
                    IconButton(onPressed: () async {
                      await modalEditNewUser(context, "edit", itemList);
                    }, icon: Icon(Icons.edit)),
                    IconButton(onPressed: (){
                      viewDeleteUser(context, itemList);
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




