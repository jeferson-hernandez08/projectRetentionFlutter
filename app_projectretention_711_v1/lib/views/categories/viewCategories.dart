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
    // Aquí puedes inicializar cualquier cosa que necesites antes de que se construya el widget
    fetchAPICategories();         // Metodo que trae las categorías 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Boton flotante para crear
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Llamamos la función para crear la categoría
          modalEditNewCategory(context, "new", null);
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue, // Personaliza el color
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: myReactController.getListCategories.length,
          itemBuilder: (BuildContext context, int index) {
            final itemList = myReactController.getListCategories[index];
            return Card(
              child: ListTile(
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.category), 
                    Text(itemList['id'].toString()),
                  ],
                ),
                title: Text(itemList['name'] ?? 'Sin nombre'),
                subtitle: Text('${itemList['description']} - ${itemList['addressing']}' ?? 'Sin información'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(onPressed: (){
                      viewItemCategory(context, itemList);
                    }, icon: Icon( Icons.visibility)),
                    IconButton(onPressed: () async {
                      await modalEditNewCategory(context, "edit", itemList);
                    }, icon: Icon(Icons.edit)),
                    IconButton(onPressed: (){
                      viewDeleteCategory(context, itemList);
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