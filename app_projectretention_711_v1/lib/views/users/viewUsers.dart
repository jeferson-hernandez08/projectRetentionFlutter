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
    fetchAPIUsers(); // Método del ambiente que trae los usuarios
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // viewCreateUser(context);
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Obx(
        () => myReactController.getListUsers.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.people, size: 90, color: Colors.grey[400]),
                    const SizedBox(height: 18),
                    Text(
                      'No hay usuarios registrados',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Presiona el botón + para agregar uno nuevo',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                itemCount: myReactController.getListUsers.length,
                itemBuilder: (BuildContext context, int index) {
                  final itemList = myReactController.getListUsers[index];
                  final id = itemList['id'] ?? '0';
                  final firstName = itemList['firstName'] ?? 'Sin nombre';
                  final lastName = itemList['lastName'] ?? '';
                  final email = itemList['email'] ?? 'Sin email';
                  final rol = itemList['rolName'] ?? 'Sin rol';

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Columna izquierda con ícono e ID
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
                                      const Icon(Icons.person,
                                          color: Colors.blue, size: 26),
                                      const SizedBox(height: 4),
                                      Text(
                                        'ID: $id',
                                        style: const TextStyle(
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

                          const SizedBox(width: 20),

                          // Contenido principal
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Nombre completo
                                Text(
                                  '$firstName $lastName',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 12),

                                // Correo electrónico
                                Row(
                                  children: [
                                    Icon(Icons.email,
                                        size: 18, color: Colors.grey[600]),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        email,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[700],
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                // Rol del usuario
                                Row(
                                  children: [
                                    Icon(Icons.security,
                                        size: 18, color: Colors.grey[600]),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        'Rol: $rol',
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

                          const SizedBox(width: 14),

                          // Acciones
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                tooltip: 'Ver usuario',
                                onPressed: () {
                                  viewItemUser(context, itemList);
                                },
                                icon: const Icon(Icons.visibility,
                                    color: Colors.blue, size: 26),
                              ),
                              IconButton(
                                tooltip: 'Editar usuario',
                                onPressed: () async {
                                  await modalEditNewUser(
                                      context, "edit", itemList);
                                },
                                icon: const Icon(Icons.edit,
                                    color: Colors.orange, size: 26),
                              ),
                              IconButton(
                                tooltip: 'Eliminar usuario',
                                onPressed: () {
                                  viewDeleteUser(context, itemList);
                                },
                                icon: const Icon(Icons.delete,
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
    );
  }
}
