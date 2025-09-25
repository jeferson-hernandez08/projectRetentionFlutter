import 'package:app_projectretention_711_v1/api/apiRetention.dart';
import 'package:app_projectretention_711_v1/main.dart';
import 'package:app_projectretention_711_v1/views/reports/editNewReport.dart';
import 'package:app_projectretention_711_v1/views/reports/viewItemReport.dart';
import 'package:app_projectretention_711_v1/views/reports/viewDeleteReport.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewReportsCPIC extends StatefulWidget {
  const ViewReportsCPIC({super.key});

  @override
  State<ViewReportsCPIC> createState() => _ViewReportsCPICState();
}

class _ViewReportsCPICState extends State<ViewReportsCPIC> {
  @override
  void initState() {
    super.initState();
    // Aquí puedes inicializar cualquier cosa que necesites antes de que se construya el widget
    fetchAPIReports(); // Método del ambiente que trae los reportes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Botón flotante para crear
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Llamamos la función para crear el reporte
          // viewCreateReport(context);
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue, // Personaliza el color
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: myReactController.getListReports.length,
          itemBuilder: (BuildContext context, int index) {
            final itemList = myReactController.getListReports[index];
            return Card(
              child: ListTile(
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.assignment), // Ícono representativo de reporte
                    Text(itemList['id'].toString()),
                  ],
                ),
                // Mostramos el campo descripción del reporte como título
                title: Text(itemList['description'] ?? 'Sin descripción'),
                // Mostramos aprendiz + estado como subtítulo
                subtitle: Text(
                  "Aprendiz: ${itemList['apprentice']?['firtsName'] ?? 'Sin aprendiz'} "
                  "${itemList['apprentice']?['lastName'] ?? ''}\n"
                  "Estado: ${itemList['state'] ?? 'Sin estado'}",
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        viewItemReport(context, itemList);
                      },
                      icon: Icon(Icons.visibility),
                    ),
                    IconButton(
                      onPressed: () async {
                        await modalEditNewReport(context, "edit", itemList);
                      },
                      icon: Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () {
                        viewDeleteReport(context, itemList);
                      },
                      icon: Icon(Icons.delete),
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
