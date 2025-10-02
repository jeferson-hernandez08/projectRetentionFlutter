import 'package:flutter/material.dart';
import 'package:app_projectretention_711_v1/main.dart';
import 'package:app_projectretention_711_v1/api/apiRetention.dart'; // Importa tu API

viewItemReport(context, itemList) async {
  // Cargar listas si no están disponibles (si es necesario, por ejemplo aprendices o usuarios)
  if (myReactController.getListApprentices.isEmpty) {
    await fetchAPIApprentices();
  }
  if (myReactController.getListUsers.isEmpty) {
    await fetchAPIUsers();
  }
  if (myReactController.getListCategories.isEmpty) {
    await fetchAPICategories();
  }

  // Función para obtener el nombre completo del aprendiz basado en fkIdApprentices
  String getApprenticeName(int? fkIdApprentices) {
    if (fkIdApprentices == null) return 'No disponible';

    final apprentice = myReactController.getListApprentices.firstWhere(
      (apprentice) => apprentice['id'] == fkIdApprentices,
      orElse: () => {'firtsName': 'Aprendiz', 'lastName': 'no encontrado'},
    );

    return '${apprentice['firtsName'] ?? ''} ${apprentice['lastName'] ?? ''}'.trim();
  }

  // Función para obtener el nombre completo del usuario basado en fkIdUsers
  String getUserName(int? fkIdUsers) {
    if (fkIdUsers == null) return 'No disponible';

    final user = myReactController.getListUsers.firstWhere(
      (user) => user['id'] == fkIdUsers,
      orElse: () => {'firstName': 'Usuario', 'lastName': 'no encontrado'},
    );

    return '${user['firstName'] ?? ''} ${user['lastName'] ?? ''}'.trim();
  }

  // 🔥 NUEVA FUNCIÓN: Obtener nombre de categoría
  String getCategoryName(dynamic cause) {
    try {
      if (cause['category'] != null && cause['category']['name'] != null) {
        return cause['category']['name'];
      }
      
      if (cause['fkIdCategories'] != null) {
        final categoryId = cause['fkIdCategories'];
        final category = myReactController.getListCategories.firstWhere(
          (cat) => cat['id'] == categoryId,
          orElse: () => null,
        );
        return category?['name'] ?? 'N/A';
      }
      
      return 'N/A';
    } catch (e) {
      print('❌ Error al obtener categoría: $e');
      return 'N/A';
    }
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Detalle del Reporte'),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        body: FutureBuilder<List<dynamic>>(
          future: fetchCausesByReport(itemList['id']), // 🔥 Cargar causas del reporte
          builder: (context, snapshot) {
            List<dynamic> reportCauses = [];
            bool isLoadingCauses = snapshot.connectionState == ConnectionState.waiting;
            
            if (snapshot.hasData) {
              // Extraer solo las causas de las relaciones
              reportCauses = snapshot.data!.map((causeReport) {
                return causeReport['cause'];
              }).where((cause) => cause != null).toList();
            }

            return ListView(
              children: [
                // ID del Reporte
                ListTile(
                  leading: Icon(Icons.key, color: Colors.deepPurple),
                  title: Text(
                    'ID del Reporte',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '#${itemList['id'].toString()}',
                    style: TextStyle(fontSize: 16, color: Colors.deepPurple),
                  ),
                ),
                Divider(),

                // Fecha de creación
                ListTile(
                  leading: Icon(Icons.calendar_today, color: Colors.blue),
                  title: Text(
                    'Fecha de Creación',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    itemList['creationDate'] ?? 'No disponible',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                Divider(),

                // Descripción
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.description, color: Colors.orange),
                            SizedBox(width: 8),
                            Text(
                              'Descripción',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          itemList['description'] ?? 'No disponible',
                          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                ),

                // Direccionamiento (Coordinador Académico o Coordinador de Formación)
                ListTile(
                  leading: Icon(Icons.account_tree, color: Colors.green),
                  title: Text(
                    'Direccionamiento',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    itemList['addressing'] ?? 'No disponible',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                Divider(),

                // Estado (Registrado, En proceso, Retenido, Desertado)
                ListTile(
                  leading: _getStateIcon(itemList['state']),
                  title: Text(
                    'Estado',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    itemList['state'] ?? 'No disponible',
                    style: TextStyle(
                      fontSize: 14,
                      color: _getStateColor(itemList['state']),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Divider(),

                // Aprendiz relacionado
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Colors.blue[50],
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.school, color: Colors.blue),
                            SizedBox(width: 8),
                            Text(
                              'Información del Aprendiz',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.blue[700],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        _buildInfoRow('Nombre', getApprenticeName(itemList['fkIdApprentices'])),
                        _buildInfoRow('Documento', itemList['apprentice']?['document'] ?? 'No disponible'),
                        _buildInfoRow('Email', itemList['apprentice']?['email'] ?? 'No disponible'),
                        _buildInfoRow('Teléfono', itemList['apprentice']?['phone'] ?? 'No disponible'),
                      ],
                    ),
                  ),
                ),

                // Usuario que creó el reporte
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Colors.green[50],
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.person, color: Colors.green),
                            SizedBox(width: 8),
                            Text(
                              'Información del Usuario',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.green[700],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        _buildInfoRow('Nombre', getUserName(itemList['fkIdUsers'])),
                        _buildInfoRow('Documento', itemList['user']?['document'] ?? 'No disponible'),
                        _buildInfoRow('Email', itemList['user']?['email'] ?? 'No disponible'),
                      ],
                    ),
                  ),
                ),

                // 🔥 SECCIÓN DE CAUSAS - CORREGIDA PARA EVITAR DESBORDAMIENTO
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  elevation: 3,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.flag, color: Colors.deepOrange),
                            SizedBox(width: 8),
                            Text(
                              'Causas del Reporte del Aprendiz',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.deepOrange,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Total de causas asociadas: ${reportCauses.length}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 16),

                        if (isLoadingCauses)
                          Container(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 8),
                                Text(
                                  'Cargando causas...',
                                  style: TextStyle(color: Colors.blue[700]),
                                ),
                              ],
                            ),
                          )
                        else if (reportCauses.isEmpty)
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                Icon(Icons.info_outline, color: Colors.grey, size: 48),
                                SizedBox(height: 8),
                                Text(
                                  'No hay causas asociadas a este reporte',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          )
                        else
                          Column(
                            children: [
                              ...reportCauses.asMap().entries.map((entry) {
                                final index = entry.key;
                                final cause = entry.value;
                                final categoryName = getCategoryName(cause);
                                
                                return Card(
                                  margin: EdgeInsets.only(bottom: 12),
                                  elevation: 2,
                                  color: Colors.blue[50],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                      color: Colors.blue[100]!,
                                      width: 1,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Número de causa
                                        Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${index + 1}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        // Contenido de la causa - MEJORADO PARA EVITAR DESBORDAMIENTO
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              // Texto de la causa con ajuste automático
                                              Text(
                                                cause['cause'] ?? 'Causa no disponible',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                  color: Colors.grey[800],
                                                ),
                                                softWrap: true, // 🔥 PERMITE AJUSTE DE TEXTO
                                                overflow: TextOverflow.visible, // 🔥 EVITA CORTE DE TEXTO
                                              ),
                                              SizedBox(height: 12),
                                              
                                              // Información de categoría
                                              Container(
                                                width: double.infinity,
                                                padding: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(8),
                                                  border: Border.all(color: Colors.blue[200]!),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.category,
                                                          size: 16,
                                                          color: Colors.blue[700],
                                                        ),
                                                        SizedBox(width: 6),
                                                        Text(
                                                          'Categoría:',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.blue[700],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 4),
                                                    Padding(
                                                      padding: EdgeInsets.only(left: 22),
                                                      child: Text(
                                                        categoryName,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.grey[700],
                                                        ),
                                                        softWrap: true,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              
                                              if (cause['variable'] != null) ...[
                                                SizedBox(height: 8),
                                                Container(
                                                  width: double.infinity,
                                                  padding: EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(8),
                                                    border: Border.all(color: Colors.green[200]!),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.track_changes,
                                                            size: 16,
                                                            color: Colors.green[700],
                                                          ),
                                                          SizedBox(width: 6),
                                                          Text(
                                                            'Variable:',
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.green[700],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 4),
                                                      Padding(
                                                        padding: EdgeInsets.only(left: 22),
                                                        child: Text(
                                                          cause['variable'],
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.grey[700],
                                                            fontStyle: FontStyle.italic,
                                                          ),
                                                          softWrap: true,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 30),
              ],
            );
          },
        ),
      );
    },
  );
}

// 🔥 FUNCIÓN AUXILIAR: Construir fila de información
Widget _buildInfoRow(String label, String value) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
            ),
            softWrap: true, // 🔥 AGREGADO PARA AJUSTE DE TEXTO
          ),
        ),
      ],
    ),
  );
}

// 🔥 FUNCIÓN AUXILIAR: Obtener icono según estado
Icon _getStateIcon(String? state) {
  switch (state?.toLowerCase()) {
    case 'registrado':
      return Icon(Icons.assignment, color: Colors.blue);
    case 'en proceso':
      return Icon(Icons.hourglass_bottom, color: Colors.orange);
    case 'retenido':
      return Icon(Icons.thumb_up, color: Colors.green);
    case 'desertado':
      return Icon(Icons.thumb_down, color: Colors.red);
    default:
      return Icon(Icons.help_outline, color: Colors.grey);
  }
}

// 🔥 FUNCIÓN AUXILIAR: Obtener color según estado
Color _getStateColor(String? state) {
  switch (state?.toLowerCase()) {
    case 'registrado':
      return Colors.blue;
    case 'en proceso':
      return Colors.orange;
    case 'retenido':
      return Colors.green;
    case 'desertado':
      return Colors.red;
    default:
      return Colors.grey;
  }
}