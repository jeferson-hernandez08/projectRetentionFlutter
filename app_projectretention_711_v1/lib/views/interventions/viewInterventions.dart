import 'package:app_projectretention_711_v1/api/apiRetention.dart';
import 'package:app_projectretention_711_v1/main.dart';
import 'package:app_projectretention_711_v1/views/interventions/editNewIntervention.dart';
import 'package:app_projectretention_711_v1/views/interventions/viewDeleteIntervention.dart';
import 'package:app_projectretention_711_v1/views/interventions/viewItemIntervention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ViewInterventionsCPIC extends StatefulWidget {
  const ViewInterventionsCPIC({super.key});

  @override
  State<ViewInterventionsCPIC> createState() => _ViewInterventionsCPICState();
}

class _ViewInterventionsCPICState extends State<ViewInterventionsCPIC> {
  // 🔍 Controlador para el campo de búsqueda
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchAPIInterventions(); // 🔹 Cargar lista de intervenciones al iniciar
    fetchAPIReports(); // 🔹 Cargar reportes para acceder a los aprendices
    fetchAPIApprentices(); // 🔹 Cargar lista de aprendices
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // 🔹 Formatear fecha y hora
  String formatDateTime(String? date) {
    if (date == null) return 'Sin fecha';
    try {
      final parsed = DateTime.parse(date);
      return DateFormat('dd/MM/yyyy HH:mm').format(parsed);
    } catch (e) {
      return 'Formato inválido';
    }
  }

  // 🔍 Obtener nombre del aprendiz asociado a una intervención
  String getApprenticeName(dynamic intervention) {
    try {
      final reportId = intervention['fkIdReports'];
      
      if (reportId != null) {
        final report = myReactController.getListReports.firstWhere(
          (r) => r['id'] == reportId,
          orElse: () => null,
        );
        
        if (report != null) {
          final apprenticeId = report['fkIdApprentices'];
          
          if (apprenticeId != null) {
            final apprentice = myReactController.getListApprentices.firstWhere(
              (a) => a['id'] == apprenticeId,
              orElse: () => null,
            );
            
            if (apprentice != null) {
              return "${apprentice['firtsName']} ${apprentice['lastName']}";
            }
          }
        }
      }
      
      return 'Sin aprendiz asignado';
    } catch (e) {
      return 'Sin aprendiz asignado';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          await modalEditNewIntervention(context, "new", {});
          fetchAPIInterventions(); // Recargar lista después de crear
        },
      ),
      body: Obx(() {
        // Obtener la lista filtrada SIN usar setState
        final displayInterventions = _searchController.text.isEmpty
            ? myReactController.getListInterventions
            : myReactController.getListInterventions.where((intervention) {
                // Obtener el reporte asociado a la intervención
                final reportId = intervention['fkIdReports'];
                
                if (reportId != null) {
                  // Buscar el reporte en la lista de reportes
                  final report = myReactController.getListReports.firstWhere(
                    (r) => r['id'] == reportId,
                    orElse: () => null,
                  );
                  
                  if (report != null) {
                    // Obtener el ID del aprendiz del reporte
                    final apprenticeId = report['fkIdApprentices'];
                    
                    if (apprenticeId != null) {
                      // Buscar el aprendiz en la lista de aprendices
                      final apprentice = myReactController.getListApprentices.firstWhere(
                        (a) => a['id'] == apprenticeId,
                        orElse: () => null,
                      );
                      
                      if (apprentice != null) {
                        // Concatenar nombre completo del aprendiz
                        final apprenticeName = "${apprentice['firtsName']} ${apprentice['lastName']}".toLowerCase();
                        final apprenticeDocument = apprentice['document'].toString().toLowerCase();
                        final searchLower = _searchController.text.toLowerCase();
                        
                        // Buscar por nombre o documento
                        return apprenticeName.contains(searchLower) || apprenticeDocument.contains(searchLower);
                      }
                    }
                  }
                }
                
                return false;
              }).toList();

        return Column(
          children: [
            // 🔍 BUSCADOR
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
                onChanged: (value) {
                  setState(() {}); // Actualizar UI cuando cambia el texto
                },
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
                      'Se encontraron ${displayInterventions.length} resultado(s)',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.blue[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

            // 🔹 LISTA DE INTERVENCIONES
            Expanded(
              child: myReactController.getListInterventions.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.flag_circle, size: 80, color: Colors.grey[400]),
                          SizedBox(height: 16),
                          Text(
                            'No hay intervenciones registradas',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Presiona el botón + para agregar una nueva',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                  : displayInterventions.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
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
                                'Intenta con otro nombre o documento',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          itemCount: displayInterventions.length,
                          itemBuilder: (BuildContext context, int index) {
                            final itemList = displayInterventions[index];
                            final id = itemList['id']?.toString() ?? '0';
                            final description = itemList['description'] ?? 'Sin descripción';
                            final creationDate = formatDateTime(itemList['creationDate']);
                            final strategy = itemList['strategy']?['strategy'] ?? 'Sin estrategia';
                            final apprenticeName = getApprenticeName(itemList);

                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(18),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // 🔹 Columna izquierda con ícono e ID
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
                                                Icon(Icons.flag,
                                                    color: Colors.blue, size: 26),
                                                SizedBox(height: 4),
                                                Text(
                                                  'ID: $id',
                                                  style: TextStyle(
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

                                    SizedBox(width: 20),

                                    // 🔹 Contenido principal
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            description,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                          SizedBox(height: 12),
                                          
                                          // 🎓 APRENDIZ
                                          Row(
                                            children: [
                                              Icon(Icons.school,
                                                  size: 18, color: Colors.indigo[600]),
                                              SizedBox(width: 6),
                                              Expanded(
                                                child: Text(
                                                  apprenticeName,
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.indigo[600],
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          
                                          // 📅 FECHA
                                          Row(
                                            children: [
                                              Icon(Icons.date_range,
                                                  size: 18, color: Colors.grey[600]),
                                              SizedBox(width: 6),
                                              Expanded(
                                                child: Text(
                                                  creationDate,
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.grey[700],
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          
                                          // 💡 ESTRATEGIA
                                          Row(
                                            children: [
                                              Icon(Icons.lightbulb,
                                                  size: 18, color: Colors.grey[600]),
                                              SizedBox(width: 6),
                                              Expanded(
                                                child: Text(
                                                  strategy,
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.grey[700],
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                    SizedBox(width: 14),

                                    // 🔹 Acciones
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        IconButton(
                                          tooltip: 'Ver intervención',
                                          onPressed: () {
                                            viewItemIntervention(context, itemList);
                                          },
                                          icon: Icon(Icons.visibility,
                                              color: Colors.blue),
                                        ),
                                        IconButton(
                                          tooltip: 'Editar intervención',
                                          onPressed: () async {
                                            await modalEditNewIntervention(
                                                context, "edit", itemList);
                                            fetchAPIInterventions(); // Recargar lista
                                          },
                                          icon: Icon(Icons.edit,
                                              color: Colors.orange, size: 26),
                                        ),
                                        IconButton(
                                          tooltip: 'Eliminar intervención',
                                          onPressed: () {
                                            viewDeleteIntervention(context, itemList);
                                          },
                                          icon: Icon(Icons.delete,
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
          ],
        );
      }),
    );
  }
} 