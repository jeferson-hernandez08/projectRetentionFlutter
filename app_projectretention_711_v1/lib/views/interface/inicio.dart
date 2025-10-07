import 'package:app_projectretention_711_v1/api/apiRetention.dart';
import 'package:app_projectretention_711_v1/views/apprentices/editNewApprentice.dart';
import 'package:app_projectretention_711_v1/views/categories/editNewCategory.dart';
import 'package:app_projectretention_711_v1/views/causes/editNewCause.dart';
import 'package:app_projectretention_711_v1/views/groups/editNewGroup.dart';
import 'package:app_projectretention_711_v1/views/interventions/editNewIntervention.dart';
import 'package:app_projectretention_711_v1/views/login/viewLogin.dart';
import 'package:app_projectretention_711_v1/views/reports/editNewReport.dart';
import 'package:app_projectretention_711_v1/views/rols/editNewRol.dart';
import 'package:app_projectretention_711_v1/views/strategies/editNewStrategy.dart';
import 'package:app_projectretention_711_v1/views/trainingPrograms/editNewTrainingProgram.dart';
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
  
  // Método para obtener las opciones del menú según el rol
  List<Widget> _getMenuOptionsByRole() {
    final userRole = myReactController.userRole;
    final List<Widget> menuOptions = [];
    
    // Opción común para todos los roles
    menuOptions.addAll([
      ListTile(
        title: Text('Info SENA Contigo'),
        leading: Icon(Icons.person, color: Colors.blueGrey),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: (){
          myReactController.setTituloAppBar('Sena Contigo');
          myReactController.setPagina(0); // Página de Bienvenida
          Get.back();
        },
      ),
      Divider(),
    ]);

    // Administrador: Roles y Usuarios
    if (userRole == 'Administrador') {
      menuOptions.addAll([
        ListTile(
          title: Text('Roles'),
          leading: Icon(Icons.security, color: Colors.teal),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: (){
            myReactController.setTituloAppBar('Listado Roles CPIC');
            myReactController.setPagina(1);
            Get.back();
          },
        ),
        Divider(),
        ListTile(
          title: Text('Usuarios'),
          leading: Icon(Icons.people, color: Colors.green),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: (){
            myReactController.setTituloAppBar('Listado Usuarios CPIC');
            myReactController.setPagina(2);
            Get.back();
          },
        ),
        Divider(),
      ]);
    }

    // Instructor: Aprendices y Reportes
    if (userRole == 'Instructor') {
      menuOptions.addAll([
        ListTile(
          title: Text('Aprendices'),
          leading: Icon(Icons.person, color: Colors.orange),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: (){
            myReactController.setTituloAppBar('Listado Aprendices CPIC');
            myReactController.setPagina(5);
            Get.back();
          },
        ),
        Divider(),
        ListTile(
          title: Text('Reportes'),
          leading: Icon(Icons.description, color: Colors.brown),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: (){
            myReactController.setTituloAppBar('Listado Reportes CPIC');
            myReactController.setPagina(9);
            Get.back();
          },
        ),
        Divider(),
      ]);
    }

    // Coordinador: Programas, Grupos, Aprendices, Categorías, Causas, Estrategias, Reportes, Intervenciones y Usuarios
    if (userRole == 'Coordinador') {
      menuOptions.addAll([
        ListTile(
          title: Text('Programas'),
          leading: Icon(Icons.school, color: Colors.deepPurple),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: (){
            myReactController.setTituloAppBar('Listado Programas de Formacion CPIC');
            myReactController.setPagina(3);
            Get.back();
          },
        ),
        Divider(),
        ListTile(
          title: Text('Grupos'),
          leading: Icon(Icons.groups, color: Colors.cyan),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: (){
            myReactController.setTituloAppBar('Listado Grupos CPIC');
            myReactController.setPagina(4);
            Get.back();
          },
        ),
        Divider(),
        ListTile(
          title: Text('Aprendices'),
          leading: Icon(Icons.person, color: Colors.orange),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: (){
            myReactController.setTituloAppBar('Listado Aprendices CPIC');
            myReactController.setPagina(5);
            Get.back();
          },
        ),
        Divider(),
        ListTile(
          title: Text('Categorias'),
          leading: Icon(Icons.category, color: Colors.purple),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: (){
            myReactController.setTituloAppBar('Listado Categorias CPIC');
            myReactController.setPagina(6);
            Get.back();
          },
        ),
        Divider(),
        ListTile(
          title: Text('Causas'),
          leading: Icon(Icons.warning_amber, color: Colors.redAccent),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: (){
            myReactController.setTituloAppBar('Listado Causas CPIC');
            myReactController.setPagina(7);
            Get.back();
          },
        ),
        Divider(),
        ListTile(
          title: Text('Estrategias'),
          leading: Icon(Icons.flag, color: Colors.teal),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: (){
            myReactController.setTituloAppBar('Listado Estrategias CPIC');
            myReactController.setPagina(8);
            Get.back();
          },
        ),
        Divider(),
        ListTile(
          title: Text('Reportes'),
          leading: Icon(Icons.description, color: Colors.brown),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: (){
            myReactController.setTituloAppBar('Listado Reportes CPIC');
            myReactController.setPagina(9);
            Get.back();
          },
        ),
        Divider(),
        ListTile(
          title: Text('Intervenciones'),
          leading: Icon(Icons.handshake, color: Colors.indigo),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: (){
            myReactController.setTituloAppBar('Listado Intervenciones CPIC');
            myReactController.setPagina(10);
            Get.back();
          },
        ),
        Divider(),
        ListTile(
          title: Text('Usuarios'),
          leading: Icon(Icons.people, color: Colors.green),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: (){
            myReactController.setTituloAppBar('Listado Usuarios CPIC');
            myReactController.setPagina(2);
            Get.back();
          },
        ),
        Divider(),
      ]);
    }

    // Profesional de Bienestar: Programas, Grupos, Aprendices, Categorías, Causas, Estrategias, Reportes, Intervenciones y Usuarios
    if (userRole == 'Profesional de Bienestar') {
      menuOptions.addAll([
        ListTile(
          title: Text('Programas'),
          leading: Icon(Icons.school, color: Colors.deepPurple),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: (){
            myReactController.setTituloAppBar('Listado Programas de Formacion CPIC');
            myReactController.setPagina(3);
            Get.back();
          },
        ),
        Divider(),
        ListTile(
          title: Text('Grupos'),
          leading: Icon(Icons.groups, color: Colors.cyan),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: (){
            myReactController.setTituloAppBar('Listado Grupos CPIC');
            myReactController.setPagina(4);
            Get.back();
          },
        ),
        Divider(),
        ListTile(
          title: Text('Aprendices'),
          leading: Icon(Icons.person, color: Colors.orange),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: (){
            myReactController.setTituloAppBar('Listado Aprendices CPIC');
            myReactController.setPagina(5);
            Get.back();
          },
        ),
        Divider(),
        ListTile(
          title: Text('Categorias'),
          leading: Icon(Icons.category, color: Colors.purple),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: (){
            myReactController.setTituloAppBar('Listado Categorias CPIC');
            myReactController.setPagina(6);
            Get.back();
          },
        ),
        Divider(),
        ListTile(
          title: Text('Causas'),
          leading: Icon(Icons.warning_amber, color: Colors.redAccent),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: (){
            myReactController.setTituloAppBar('Listado Causas CPIC');
            myReactController.setPagina(7);
            Get.back();
          },
        ),
        Divider(),
        ListTile(
          title: Text('Estrategias'),
          leading: Icon(Icons.flag, color: Colors.teal),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: (){
            myReactController.setTituloAppBar('Listado Estrategias CPIC');
            myReactController.setPagina(8);
            Get.back();
          },
        ),
        Divider(),
        ListTile(
          title: Text('Reportes'),
          leading: Icon(Icons.description, color: Colors.brown),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: (){
            myReactController.setTituloAppBar('Listado Reportes CPIC');
            myReactController.setPagina(9);
            Get.back();
          },
        ),
        Divider(),
        ListTile(
          title: Text('Intervenciones'),
          leading: Icon(Icons.handshake, color: Colors.indigo),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: (){
            myReactController.setTituloAppBar('Listado Intervenciones CPIC');
            myReactController.setPagina(10);
            Get.back();
          },
        ),
        Divider(),
        ListTile(
          title: Text('Usuarios'),
          leading: Icon(Icons.people, color: Colors.green),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: (){
            myReactController.setTituloAppBar('Listado Usuarios CPIC');
            myReactController.setPagina(2);
            Get.back();
          },
        ),
        Divider(),
      ]);
    }

    // Aprendiz Vocero: Aprendices y Reportes
    if (userRole == 'Aprendiz Vocero') {
      menuOptions.addAll([
        ListTile(
          title: Text('Aprendices'),
          leading: Icon(Icons.person, color: Colors.orange),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: (){
            myReactController.setTituloAppBar('Listado Aprendices CPIC');
            myReactController.setPagina(5);
            Get.back();
          },
        ),
        Divider(),
        ListTile(
          title: Text('Reportes'),
          leading: Icon(Icons.description, color: Colors.brown),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: (){
            myReactController.setTituloAppBar('Listado Reportes CPIC');
            myReactController.setPagina(9);
            Get.back();
          },
        ),
        Divider(),
      ]);
    }

    return menuOptions;
  }

  // Método para verificar si el FAB debe ser visible según el rol y la página
  bool _shouldShowFAB() {
    final userRole = myReactController.userRole;
    final currentPage = myReactController.getPagina;
    
    // Páginas permitidas para cada rol
    final Map<String, List<int>> allowedPagesByRole = {
      'Administrador': [1, 2], // Roles y Usuarios
      'Instructor': [5, 9], // Aprendices y Reportes
      'Coordinador': [2, 3, 4, 5, 6, 7, 8, 9, 10], // Usuarios, Programas, Grupos, Aprendices, Categorías, Causas, Estrategias, Reportes, Intervenciones
      'Profesional de Bienestar': [2, 3, 4, 5, 6, 7, 8, 9, 10], // Mismo que Coordinador
      'Aprendiz Vocero': [5, 9], // Aprendices y Reportes
    };

    final allowedPages = allowedPagesByRole[userRole] ?? [];
    return allowedPages.contains(currentPage);
  }

  @override
  Widget build(BuildContext context) {
    // Verificamos si el usuario está autenticado - DEBE ESTAR FUERA de Obx
    if (myReactController.getToken.isEmpty) {
      return ViewLoginCPIC();
    }
    
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Center(
            child: Column(
              children: [
                Text(myReactController.getTituloAppBar),
                Text(
                  'Rol: ${myReactController.userRole}',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        myReactController.fullName,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        myReactController.userRole,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        body: menuPages[myReactController.getPagina],
        floatingActionButton: Visibility(
          visible: _shouldShowFAB(),
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
              } else if (page == 3) {   // Crear editar training_programs
                modalEditNewTrainingProgram(context, "new", null);
              } else if (page == 4) {    // Crear editar groups
                modalEditNewGroup(context, "new", null);
              } else if (page == 5) {    // Crear editar apprentices
                modalEditNewApprentice(context, "new", null);
              } else if (page == 6) {    // Crear editar categories
                modalEditNewCategory(context, "new", null);
              } else if (page == 7) {    // Crear editar causas
                modalEditNewCause(context, "new", null);
              } else if (page == 8) {    // Crear editar estrategias
                modalEditNewStrategy(context, "new", null);
              } else if (page == 9) {    // Crear editar reportes
                modalEditNewReport(context, "new", null);
              } else if (page == 10) {    // Crear editar intervenciones
                modalEditNewIntervention(context, "new", null);
              }
            },
          ),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              // Encabezado del drawer con información del usuario
              UserAccountsDrawerHeader(
                accountName: Text(
                  myReactController.fullName,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                accountEmail: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      myReactController.userEmail,
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      'Rol: ${myReactController.userRole}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                currentAccountPicture: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Colors.amber),
                ),
                decoration: const BoxDecoration(
                  color: Colors.amber,
                ),
              ),

              // Opciones del menú según el rol
              ..._getMenuOptionsByRole(),

              // Opción para cerrar sesión (siempre visible)
              ListTile(
                title: const Text('Cerrar Sesión'),
                leading: const Icon(Icons.logout),
                onTap: () {
                  // Limpiar token y datos de usuario
                  myReactController.logout();
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