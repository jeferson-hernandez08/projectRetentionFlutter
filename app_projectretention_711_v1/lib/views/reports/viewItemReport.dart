import 'package:flutter/material.dart';
import 'package:app_projectretention_711_v1/main.dart';
import 'package:app_projectretention_711_v1/api/apiRetention.dart';

viewItemReport(context, itemList) async {
  // Cargar listas si no están disponibles
  if (myReactController.getListApprentices.isEmpty) {
    await fetchAPIApprentices();
  }
  if (myReactController.getListUsers.isEmpty) {
    await fetchAPIUsers();
  }
  if (myReactController.getListCategories.isEmpty) {
    await fetchAPICategories();
  }

  // Función para obtener el nombre completo del aprendiz
  String getApprenticeName(int? fkIdApprentices) {
    if (fkIdApprentices == null) return 'No disponible';
    final apprentice = myReactController.getListApprentices.firstWhere(
      (apprentice) => apprentice['id'] == fkIdApprentices,
      orElse: () => {'firtsName': 'Aprendiz', 'lastName': 'no encontrado'},
    );
    return '${apprentice['firtsName'] ?? ''} ${apprentice['lastName'] ?? ''}'.trim();
  }

  // Función para obtener el nombre completo del usuario
  String getUserName(int? fkIdUsers) {
    if (fkIdUsers == null) return 'No disponible';
    final user = myReactController.getListUsers.firstWhere(
      (user) => user['id'] == fkIdUsers,
      orElse: () => {'firstName': 'Usuario', 'lastName': 'no encontrado'},
    );
    return '${user['firstName'] ?? ''} ${user['lastName'] ?? ''}'.trim();
  }

  // Función para obtener nombre de categoría
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
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 7, 25, 83),
              Color.fromARGB(255, 23, 214, 214),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: const Text(
              'Detalle del Reporte',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
          ),
          body: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            child: FutureBuilder<List<dynamic>>(
              future: fetchCausesByReport(itemList['id']),
              builder: (context, snapshot) {
                List<dynamic> reportCauses = [];
                bool isLoadingCauses = snapshot.connectionState == ConnectionState.waiting;

                if (snapshot.hasData) {
                  reportCauses = snapshot.data!
                      .map((causeReport) => causeReport['cause'])
                      .where((cause) => cause != null)
                      .toList();
                }

                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView(
                    children: [
                      const SizedBox(height: 10),
                      
                      // Información básica del reporte
                      _buildDetailCard(
                        icon: Icons.key,
                        title: 'ID del Reporte',
                        value: '#${itemList['id'].toString()}',
                        color: Colors.blueAccent,
                      ),
                      
                      _buildDetailCard(
                        icon: Icons.calendar_today,
                        title: 'Fecha de Creación',
                        value: itemList['creationDate'] ?? 'No disponible',
                        color: Colors.deepOrange,
                      ),
                      
                      _buildDetailCard(
                        icon: Icons.description,
                        title: 'Descripción',
                        value: itemList['description'] ?? 'No disponible',
                        color: Colors.purple,
                        showFullText: true,
                      ),
                      
                      _buildDetailCard(
                        icon: Icons.account_tree,
                        title: 'Direccionamiento',
                        value: itemList['addressing'] ?? 'No disponible',
                        color: Colors.teal,
                      ),
                      
                      _buildDetailCard(
                        icon: _getStateIcon(itemList['state']),
                        title: 'Estado',
                        value: itemList['state'] ?? 'No disponible',
                        color: _getStateColor(itemList['state']),
                      ),

                      const SizedBox(height: 20),

                      // Información del Aprendiz (agrupada en una sola tarjeta)
                      Row(
  children: const [
    Icon(Icons.school, color: Colors.blue), // 🎓 Ícono de gorrito
    SizedBox(width: 8),
    Text(
      'Información del Aprendiz',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    ),
  ],
),
                      _buildGroupedCard(
                        backgroundColor: Colors.blue[50]!,
                        items: [
                          _GroupedCardItem(
                            icon: Icons.person,
                            title: 'Nombre',
                            value: getApprenticeName(itemList['fkIdApprentices']),
                            color: Colors.deepPurple,
                          ),
                          _GroupedCardItem(
                            icon: Icons.credit_card,
                            title: 'Documento',
                            value: itemList['apprentice']?['document'] ?? 'No disponible',
                            color: Colors.indigo,
                          ),
                          _GroupedCardItem(
                            icon: Icons.email,
                            title: 'Email',
                            value: itemList['apprentice']?['email'] ?? 'No disponible',
                            color: Colors.redAccent,
                          ),
                          _GroupedCardItem(
                            icon: Icons.phone,
                            title: 'Teléfono',
                            value: itemList['apprentice']?['phone'] ?? 'No disponible',
                            color: Colors.green,
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Información del Usuario (agrupada en una sola tarjeta)
                                           Row(
  children: const [
    Icon(Icons.person, color: Colors.green), // 🎓 Ícono de gorrito
    SizedBox(width: 8),
    Text(
      'Información del Usuario',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.green,
      ),
    ),
  ],
),
                      _buildGroupedCard(
                        backgroundColor: Colors.green[50]!,
                        items: [
                          _GroupedCardItem(
                            icon: Icons.person,
                            title: 'Nombre',
                            value: getUserName(itemList['fkIdUsers']),
                            color: Colors.deepPurple,
                          ),
                          _GroupedCardItem(
                            icon: Icons.credit_card,
                            title: 'Documento',
                            value: itemList['user']?['document'] ?? 'No disponible',
                            color: Colors.indigo,
                          ),
                          _GroupedCardItem(
                            icon: Icons.email,
                            title: 'Email',
                            value: itemList['user']?['email'] ?? 'No disponible',
                            color: Colors.redAccent,
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Causas del Reporte
                      _buildSectionTitle('Causas del Reporte del Aprendiz'),
                      
                      if (isLoadingCauses)
                        _buildLoadingCauses()
                      else if (reportCauses.isEmpty)
                        _buildNoCauses()
                      else
                        ..._buildCausesList(reportCauses),

                      const SizedBox(height: 30),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );
    },
  );
}

// 🔹 Clase para items de la tarjeta agrupada
class _GroupedCardItem {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  _GroupedCardItem({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });
}

// 🔹 Widget para tarjeta agrupada con múltiples items
Widget _buildGroupedCard({
  required Color backgroundColor,
  required List<_GroupedCardItem> items,
}) {
  return Card(
    elevation: 2,
    margin: const EdgeInsets.symmetric(vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    color: backgroundColor,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: item.color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                      item.icon,
                      color: item.color,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: item.color,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.value,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Agregar divider entre items excepto después del último
              if (index < items.length - 1) ...[
                const SizedBox(height: 12),
                Divider(
                  color: Colors.grey[300],
                  thickness: 1,
                ),
                const SizedBox(height: 12),
              ],
            ],
          );
        }).toList(),
      ),
    ),
  );
}

// 🔹 Widget para cada tarjeta de detalle con color personalizado
Widget _buildDetailCard({
  required IconData icon,
  required String title,
  required String value,
  required Color color,
  bool showFullText = false, // 👈 nuevo parámetro opcional
}) {
  return Card(
    elevation: 2,
    margin: const EdgeInsets.symmetric(vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        crossAxisAlignment:
            showFullText ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(10),
            child: Icon(
              icon,
              color: color,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                  softWrap: true, // 👈 permite saltos de línea
                  overflow:
                      showFullText ? TextOverflow.visible : TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

// 🔹 Widget para títulos de sección
Widget _buildSectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color.fromARGB(255, 7, 25, 83),
      ),
    ),
  );
}

// 🔹 Widget para carga de causas
Widget _buildLoadingCauses() {
  return Card(
    elevation: 2,
    margin: const EdgeInsets.symmetric(vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    child: const Padding(
      padding: EdgeInsets.all(20),
      child: Center(
        child: Column(
          children: [
            CircularProgressIndicator(
              color: Color.fromARGB(255, 7, 25, 83),
            ),
            SizedBox(height: 10),
            Text(
              'Cargando causas...',
              style: TextStyle(
                color: Color.fromARGB(255, 7, 25, 83),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// 🔹 Widget para cuando no hay causas
Widget _buildNoCauses() {
  return Card(
    elevation: 2,
    margin: const EdgeInsets.symmetric(vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    child: const Padding(
      padding: EdgeInsets.all(20),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.info_outline,
              color: Colors.grey,
              size: 48,
            ),
            SizedBox(height: 8),
            Text(
              'No hay causas asociadas a este reporte',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// 🔹 Widget para lista de causas
List<Widget> _buildCausesList(List<dynamic> reportCauses) {
  return [
    Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total de causas asociadas: ${reportCauses.length}',
              style: TextStyle(
                color: const Color.fromARGB(255, 0, 0, 0),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...reportCauses.asMap().entries.map((entry) {
              final index = entry.key;
              final cause = entry.value;
              final categoryName = getCategoryName(cause);
              
              return _buildCauseItem(
                index: index + 1,
                cause: cause['cause'] ?? 'Causa no disponible',
                category: categoryName,
                variable: cause['variable'],
              );
            }).toList(),
          ],
        ),
      ),
    ),
  ];
}

// 🔹 Widget para cada ítem de causa
Widget _buildCauseItem({
  required int index,
  required String cause,
  required String category,
  required String? variable,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.blue[50],
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey[300]!),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Número de causa
        Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 7, 25, 83),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$index',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                cause,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Categoría
        _buildCauseDetailRow(
          icon: Icons.category,
          label: 'Categoría',
          value: category,
          color: const Color.fromARGB(255, 7, 25, 83),
        ),
        
        // Variable (si existe)
        if (variable != null && variable.isNotEmpty) ...[
          const SizedBox(height: 8),
          _buildCauseDetailRow(
            icon: Icons.track_changes,
            label: 'Variable',
            value: variable,
            color: Colors.teal,
          ),
        ],
      ],
    ),
  );
}

// 🔹 Widget para fila de detalle de causa
Widget _buildCauseDetailRow({
  required IconData icon,
  required String label,
  required String value,
  required Color color,
}) {
  return Row(
    children: [
      Icon(
        icon,
        size: 16,
        color: color,
      ),
      const SizedBox(width: 6),
      Text(
        '$label: ',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
      Expanded(
        child: Text(
          value,
          style: TextStyle(
            fontSize: 12,
            color: color,
          ),
          softWrap: true,
        ),
      ),
    ],
  );
}

// 🔹 Funciones auxiliares para estado
IconData _getStateIcon(String? state) {
  switch (state?.toLowerCase()) {
    case 'registrado':
      return Icons.assignment;
    case 'en proceso':
      return Icons.hourglass_bottom;
    case 'retenido':
      return Icons.thumb_up;
    case 'desertado':
      return Icons.thumb_down;
    default:
      return Icons.help_outline;
  }
}

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

// 🔹 Función para obtener nombre de categoría (necesaria para las causas)
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