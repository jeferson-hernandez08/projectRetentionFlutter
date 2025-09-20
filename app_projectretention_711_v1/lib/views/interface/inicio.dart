import 'package:app_projectretention_711_v1/api/apiRetention.dart';
import 'package:app_projectretention_711_v1/views/login/viewLogin.dart';
import 'package:app_projectretention_711_v1/views/rols/editNewRol.dart';
import 'package:app_projectretention_711_v1/views/users/editNewUser.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import '../../main.dart';
import 'homePrincipal.dart';

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  @override
  Widget build(BuildContext context) {
    // Verificamos si el usuario está autenticado - DEBE ESTAR FUERA de Obx
    if (myReactController.getToken.isEmpty) {
      return ViewLoginCPIC();
    }
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Center(child: Text(myReactController.getTituloAppBar)),
          backgroundColor: Colors.amber,
          foregroundColor: Colors.white,
          actions: [
            // Mostrar información del usuario logueado
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Row(
                children: [
                  const Icon(Icons.person, size: 20),
                  const SizedBox(width: 5),
                  Text(
                    myReactController.getUser['userName'] ?? 'Usuario',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: menuPages[myReactController.getPagina],
        floatingActionButton: Visibility(       // Aquí comentar para probar la otra opcion realizada de viewCreateAmbient.dart
          visible: (myReactController.getPagina == 1 || myReactController.getPagina == 2 || myReactController.getPagina == 3 || myReactController.getPagina == 4 ) ? true : false,
          child: FloatingActionButton(    
            backgroundColor: Colors.amber,
            foregroundColor: Colors.white,
            child: Icon(Icons.add),
            onPressed: () {
              var page = myReactController.getPagina;
              if (page == 1) {  // Crear editar rols
                modalEditNewRol(context, "new", null);
              } else if(page == 2) {  // Crear editar users
                modalEditNewUser(context, "new", null);
              } else if (page == 3) {   // Crear editar category
                // modalEditNewCategory(context, "new", null);
              } else if (page == 4) {    // Crear editar events
                // modalEditNewEvent(context, "new", null);
              }
            }),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              // Encabezado del drawer con información del usuario
              UserAccountsDrawerHeader(
                accountName: Text(
                  myReactController.getUser['userName'] ?? 'Usuario',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                accountEmail: Text(
                  myReactController.getUser['email'] ?? 'email@ejemplo.com',
                  style: const TextStyle(fontSize: 14),
                ),
                currentAccountPicture: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Colors.amber),
                ),
                decoration: const BoxDecoration(
                  color: Colors.amber,
                ),
              ),

              ListTile(
                title: Text('Info SENA Contigo'),
                leading: Icon(Icons.person),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: (){
                  myReactController.setTituloAppBar('Sena Contigo');
                  myReactController.setPagina(0); // Página de Picsum
                  Get.back();
                },
              ),
              Divider(),

              ListTile(
                title: Text('Roles'),
                leading: Icon(Icons.security),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: (){
                  myReactController.setTituloAppBar('Listado Roles CPIC');
                  myReactController.setPagina(1);   // Aqui se trae en main el array List menuPages = [
                  Get.back();
                },
              ),
              Divider(),

              ListTile(
                title: Text('Usuarios'),
                leading: Icon(Icons.people),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: (){
                  myReactController.setTituloAppBar('Listado Usuarios CPIC');
                  myReactController.setPagina(2);   // Aqui se trae en main el array List menuPages = [
                  Get.back();
                },
              ),
              Divider(),

              // ListTile(
              //   title: Text('Listado de Categorias de Eventos CPIC'),
              //   leading: Icon(Icons.category),
              //   trailing: Icon(Icons.arrow_forward_ios),
              //   onTap: (){
              //     myReactController.setTituloAppBar('Listado Categorias CPIC');
              //     myReactController.setPagina(3);   // Aqui se trae en main el array List menuPages = [
              //     Get.back();
              //   },
              // ),
              // Divider(),

              // ListTile(
              //   title: Text('Listado de Eventos CPIC'),
              //   leading: Icon(Icons.event),
              //   trailing: Icon(Icons.arrow_forward_ios),
              //   onTap: (){
              //     myReactController.setTituloAppBar('Listado Eventos CPIC');
              //     myReactController.setPagina(4);   // Aqui se trae en main el array List menuPages = [
              //     Get.back();
              //   },
              // ),
              // Divider(),

              // Opción para cerrar sesión
              ListTile(
                title: const Text('Cerrar Sesión'),
                leading: const Icon(Icons.logout),
                onTap: () {
                  // Limpiar token y datos de usuario
                  myReactController.setToken('');
                  myReactController.setUser({});
                  // Redirigir al login
                  Get.offAll(() => const Inicio());
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}