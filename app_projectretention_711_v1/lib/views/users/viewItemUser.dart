import 'package:app_projectretention_711_v1/main.dart';
import 'package:flutter/material.dart';
import 'package:app_projectretention_711_v1/api/apiRetention.dart';

viewItemUser(context, itemList) async {
  // 🔹 Cargar roles si no están disponibles
  if (myReactController.getListRols.isEmpty) {
    await fetchAPIRols();
  }

  // 🔹 Función para obtener el nombre del rol basado en el fkIdRols
  String getRolName(int? fkIdRols) {
    if (fkIdRols == null) return 'No disponible';
    final rol = myReactController.getListRols.firstWhere(
      (rol) => rol['id'] == fkIdRols,
      orElse: () => {'name': 'Rol no encontrado'},
    );
    return rol['name'] ?? 'Rol no encontrado';
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
              Color.fromARGB(255, 7, 25, 83), // Azul oscuro
              Color.fromARGB(255, 23, 214, 214), // Azul celeste
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
              'Detalle del Usuario',
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
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  const SizedBox(height: 10),

                  _buildDetailCard(
                    icon: Icons.key,
                    title: 'ID',
                    value: itemList['id'].toString(),
                    color: Colors.blueAccent,
                  ),
                  _buildDetailCard(
                    icon: Icons.person,
                    title: 'Nombre',
                    value: itemList['firstName'] ?? 'No disponible',
                    color: Colors.deepPurple,
                  ),
                  _buildDetailCard(
                    icon: Icons.person_outline,
                    title: 'Apellido',
                    value: itemList['lastName'] ?? 'No disponible',
                    color: Colors.orangeAccent,
                  ),
                  _buildDetailCard(
                    icon: Icons.email,
                    title: 'Email',
                    value: itemList['email'] ?? 'No disponible',
                    color: Colors.redAccent,
                  ),
                  _buildDetailCard(
                    icon: Icons.phone,
                    title: 'Teléfono',
                    value: itemList['phone'] ?? 'No disponible',
                    color: Colors.green,
                  ),
                  _buildDetailCard(
                    icon: Icons.badge,
                    title: 'Documento',
                    value: itemList['document'] ?? 'No disponible',
                    color: Colors.indigo,
                  ),
                  _buildDetailCard(
                    icon: Icons.work,
                    title: 'Tipo de Coordinador',
                    value: itemList['coordinadorType'] ?? 'No disponible',
                    color: Colors.cyan,
                  ),
                  _buildDetailCard(
                    icon: Icons.admin_panel_settings,
                    title: 'Es Manager',
                    value: itemList['manager']?.toString() == 'true'
                        ? 'Sí'
                        : itemList['manager']?.toString() == 'false'
                            ? 'No'
                            : 'No disponible',
                    color: Colors.amber,
                  ),
                  _buildDetailCard(
                    icon: Icons.security,
                    title: 'Rol',
                    value: getRolName(itemList['fkIdRols']),
                    color: Colors.pinkAccent,
                  ),
                  _buildDetailCard(
                    icon: Icons.lock_reset,
                    title: 'Password Reset Token',
                    value: itemList['passwordResetToken'] ?? 'No disponible',
                    color: Colors.teal,
                  ),
                  _buildDetailCard(
                    icon: Icons.timer_off,
                    title: 'Password Reset Expiration',
                    value: itemList['passwordResetExpires'] ?? 'No disponible',
                    color: Colors.lightGreen,
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

// 🔹 Widget reutilizable con color personalizado para cada ícono
Widget _buildDetailCard({
  required IconData icon,
  required String title,
  required String value,
  required Color color,
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
        crossAxisAlignment: CrossAxisAlignment.center,
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
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
