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
  // 🔍 Controlador para el campo de búsqueda
  final TextEditingController _searchController = TextEditingController();
  
  // 🔍 Lista filtrada de reportes
  List<dynamic> _filteredReports = [];
  
  @override
  void initState() {
    super.initState();
    fetchAPIReports(); // Método del ambiente que trae los reportes
    
    // Inicializar la lista filtrada
    _filteredReports = myReactController.getListReports;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // 🔍 Función para filtrar reportes por nombre del aprendiz
  void _filterReports(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredReports = myReactController.getListReports;
      } else {
        _filteredReports = myReactController.getListReports.where((report) {
          final apprenticeFirstName = report['apprentice']?['firtsName']?.toString().toLowerCase() ?? '';
          final apprenticeLastName = report['apprentice']?['lastName']?.toString().toLowerCase() ?? '';
          final fullName = '$apprenticeFirstName $apprenticeLastName';
          final searchLower = query.toLowerCase();
          
          return fullName.contains(searchLower) || 
                 apprenticeFirstName.contains(searchLower) || 
                 apprenticeLastName.contains(searchLower);
        }).toList();
      }
    });
  }

  // Función para actualizar el estado de un reporte
  Future<void> _updateReportState(int reportId, String newState) async {
    try {
      // Buscar el reporte actual para obtener todos sus datos
      final currentReport = myReactController.getListReports.firstWhere(
        (report) => report['id'] == reportId,
      );

      // Llamar a la API para editar el reporte, manteniendo todos los datos excepto el estado
      final success = await editReportApi(
        reportId,
        currentReport['creationDate'],
        currentReport['description'],
        currentReport['addressing'],
        newState, // Nuevo estado
        currentReport['fkIdApprentices']?.toString(),
        currentReport['fkIdUsers']?.toString(),
      );

      if (success) {
        Get.snackbar(
          '✅ Éxito',
          'Estado actualizado a: $newState',
          colorText: Colors.white,
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          '❌ Error',
          'No se pudo actualizar el estado',
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
        // Revertir el cambio en la UI si falla
        setState(() {});
      }
    } catch (e) {
      Get.snackbar(
        '💥 Error',
        'Excepción al actualizar: $e',
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
      // Revertir el cambio en la UI si hay excepción
      setState(() {});
    }
  }

  // Función para obtener el color según el estado
  Color _getStateColor(String state) {
    switch (state) {
      case 'Registrado':
        return Colors.blue;
      case 'En proceso':
        return Colors.orange;
      case 'Retenido':
        return Colors.green;
      case 'Desertado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Función para obtener el ícono según el estado
  IconData _getStateIcon(String state) {
    switch (state) {
      case 'Registrado':
        return Icons.assignment;
      case 'En proceso':
        return Icons.autorenew;
      case 'Retenido':
        return Icons.thumb_up;
      case 'Desertado':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Botón flotante para crear
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          modalEditNewReport(context, "new", null);
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      body: Obx(() {
        // Obtener la lista filtrada SIN usar setState
        final displayReports = _searchController.text.isEmpty
            ? myReactController.getListReports
            : myReactController.getListReports.where((report) {
                final apprenticeFirstName = report['apprentice']?['firtsName']?.toString().toLowerCase() ?? '';
                final apprenticeLastName = report['apprentice']?['lastName']?.toString().toLowerCase() ?? '';
                final fullName = '$apprenticeFirstName $apprenticeLastName';
                final searchLower = _searchController.text.toLowerCase();
                
                return fullName.contains(searchLower) || 
                       apprenticeFirstName.contains(searchLower) || 
                       apprenticeLastName.contains(searchLower);
              }).toList();

        return Column(
          children: [
            // 🔍 BARRA DE BÚSQUEDA
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar por nombre del aprendiz...',
                  prefixIcon: Icon(Icons.search, color: Colors.blue),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, size: 20),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _filterReports('');
                            });
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                onChanged: _filterReports,
              ),
            ),

            // CONTADOR DE RESULTADOS
            if (_searchController.text.isNotEmpty)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.blue[50],
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 16, color: Colors.blue[700]),
                    SizedBox(width: 8),
                    Text(
                      'Se encontraron ${displayReports.length} resultado(s)',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.blue[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

            // LISTA DE REPORTES
            Expanded(
              child: myReactController.getListReports.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.assignment,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No hay reportes registrados',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Presiona el botón + para crear el primero',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                  : displayReports.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 80,
                                color: Colors.grey[400],
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No se encontraron resultados',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Intenta con otro nombre',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: displayReports.length,
                          itemBuilder: (BuildContext context, int index) {
                            final itemList = displayReports[index];
                            final currentState = itemList['state'] ?? 'Registrado';
                            final apprenticeName =
                                '${itemList['apprentice']?['firtsName'] ?? 'Sin aprendiz'} '
                                '${itemList['apprentice']?['lastName'] ?? ''}';
                            final description =
                                itemList['description'] ?? 'Sin descripción';

                            return Card(
                              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Columna izquierda: Logo del reporte con ID + Logo del estado
                                    Column(
                                      children: [
                                        // Logo del reporte con ID (como en el diseño original)
                                        Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            color: Colors.blue[50],
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: Colors.blue,
                                              width: 2,
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.assignment,
                                                color: Colors.blue,
                                                size: 24,
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                'ID: ${itemList['id']}',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        // Logo del estado (círculo de color)
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: _getStateColor(currentState)
                                                .withOpacity(0.1),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: _getStateColor(currentState),
                                              width: 2,
                                            ),
                                          ),
                                          child: Icon(
                                            _getStateIcon(currentState),
                                            color: _getStateColor(currentState),
                                            size: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 16),
                                    // Contenido principal
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Descripción del reporte
                                          Text(
                                            description,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 8),
                                          // Información del aprendiz
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.person,
                                                size: 14,
                                                color: Colors.grey[600],
                                              ),
                                              SizedBox(width: 4),
                                              Expanded(
                                                child: Text(
                                                  'Aprendiz: $apprenticeName',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[600],
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 12),
                                          // Dropdown para cambiar el estado
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[50],
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(
                                                color: Colors.grey[300]!,
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 12, vertical: 4),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.circle,
                                                    color: _getStateColor(currentState),
                                                    size: 12,
                                                  ),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    'Estado:',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  SizedBox(width: 8),
                                                  Expanded(
                                                    child: DropdownButtonHideUnderline(
                                                      child: DropdownButton<String>(
                                                        value: currentState,
                                                        isExpanded: true,
                                                        icon: Icon(
                                                          Icons.arrow_drop_down,
                                                          color:
                                                              _getStateColor(currentState),
                                                          size: 20,
                                                        ),
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.black87,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                        dropdownColor: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.circular(8),
                                                        onChanged: (String? newValue) {
                                                          if (newValue != null &&
                                                              newValue != currentState) {
                                                            // Actualizar inmediatamente en la UI para mejor experiencia
                                                            setState(() {
                                                              itemList['state'] =
                                                                  newValue;
                                                            });
                                                            // Llamar a la API para actualizar
                                                            _updateReportState(
                                                                itemList['id'], newValue);
                                                          }
                                                        },
                                                        items: <String>[
                                                          'Registrado',
                                                          'En proceso',
                                                          'Retenido',
                                                          'Desertado'
                                                        ].map<DropdownMenuItem<String>>(
                                                            (String value) {
                                                          return DropdownMenuItem<String>(
                                                            value: value,
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                  Icons.circle,
                                                                  color: _getStateColor(
                                                                      value),
                                                                  size: 10,
                                                                ),
                                                                SizedBox(width: 8),
                                                                Text(
                                                                  value,
                                                                  style: TextStyle(
                                                                    color: _getStateColor(
                                                                        value),
                                                                    fontWeight:
                                                                        FontWeight.w500,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        }).toList(),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    // Botones de acción
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            viewItemReport(context, itemList);
                                          },
                                          icon: Icon(
                                            Icons.visibility,
                                            color: Colors.blue,
                                            size: 22,
                                          ),
                                          tooltip: 'Ver detalles',
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            await modalEditNewReport(
                                                context, "edit", itemList);
                                          },
                                          icon: Icon(
                                            Icons.edit,
                                            color: Colors.orange,
                                            size: 22,
                                          ),
                                          tooltip: 'Editar reporte',
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            viewDeleteReport(context, itemList);
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                            size: 22,
                                          ),
                                          tooltip: 'Eliminar reporte',
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
          ],
        );
      }),
    );
  }
} 