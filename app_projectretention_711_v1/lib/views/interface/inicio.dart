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
  
  // Mapa para asociar cada página con su ícono y color
  final Map<int, Map<String, dynamic>> _pageIcons = {
    0: {'icon': Icons.home, 'color': Color.fromARGB(255, 23, 214, 214)},
    1: {'icon': Icons.security, 'color': Colors.teal},
    2: {'icon': Icons.people, 'color': Colors.green},
    3: {'icon': Icons.school, 'color': Colors.deepPurple},
    4: {'icon': Icons.groups, 'color': Colors.cyan},
    5: {'icon': Icons.person, 'color': Colors.orange},
    6: {'icon': Icons.category, 'color': Colors.purple},
    7: {'icon': Icons.warning_amber, 'color': Colors.redAccent},
    8: {'icon': Icons.flag, 'color': Colors.teal},
    9: {'icon': Icons.description, 'color': Colors.brown},
    10: {'icon': Icons.handshake, 'color': Colors.indigo},
  };

  IconData _getCurrentIcon() {
    return _pageIcons[myReactController.getPagina]?['icon'] ?? Icons.home;
  }

  List<Widget> _getMenuOptionsByRole() {
    final userRole = myReactController.userRole;
    final List<Widget> menuOptions = [];
    
    menuOptions.addAll([
      ListTile(
        title: const Text(
          'Inicio SENA Contigo',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        leading: const Icon(Icons.home, color: Color.fromARGB(255, 23, 214, 214), size: 28),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: (){
          myReactController.setTituloAppBar('Sena Contigo');
          myReactController.setPagina(0);
          Get.back();
        },
      ),
      const Divider(),
    ]);

    if (userRole == 'Administrador') {
      menuOptions.addAll([
        _menuItem('Roles', Icons.security, Colors.teal, 1, ' Roles CPIC'),
        _menuItem('Usuarios', Icons.people, Colors.green, 2, ' Usuarios CPIC'),
      ]);
    }

    if (userRole == 'Instructor') {
      menuOptions.addAll([
        _menuItem('Aprendices', Icons.school, Colors.orange, 5, ' Aprendices CPIC'),
        _menuItem('Reportes', Icons.description, Colors.brown, 9, ' Reportes CPIC'),
      ]);
    }

    if (userRole == 'Coordinador') {
      menuOptions.addAll([
        _menuItem('Programas', Icons.school, Colors.deepPurple, 3, ' Programas de Formacion CPIC'),
        _menuItem('Grupos', Icons.groups, Colors.cyan, 4, ' Grupos CPIC'),
        _menuItem('Aprendices', Icons.person, Colors.orange, 5, ' Aprendices CPIC'),
        _menuItem('Categorias', Icons.category, Colors.purple, 6, ' Categorias CPIC'),
        _menuItem('Causas', Icons.warning_amber, Colors.redAccent, 7, ' Causas CPIC'),
        _menuItem('Estrategias', Icons.flag, Colors.teal, 8, ' Estrategias CPIC'),
        _menuItem('Reportes', Icons.description, Colors.brown, 9, ' Reportes CPIC'),
        _menuItem('Intervenciones', Icons.handshake, Colors.indigo, 10, ' Intervenciones CPIC'),
        _menuItem('Usuarios', Icons.people, Colors.green, 2, ' Usuarios CPIC'),
      ]);
    }

    if (userRole == 'Profesional de Bienestar') {
      menuOptions.addAll([
        _menuItem('Programas', Icons.school, Colors.deepPurple, 3, ' Programas de Formacion CPIC'),
        _menuItem('Grupos', Icons.groups, Colors.cyan, 4, ' Grupos CPIC'),
        _menuItem('Aprendices', Icons.person, Colors.orange, 5, ' Aprendices CPIC'),
        _menuItem('Categorias', Icons.category, Colors.purple, 6, ' Categorias CPIC'),
        _menuItem('Causas', Icons.warning_amber, Colors.redAccent, 7, ' Causas CPIC'),
        _menuItem('Estrategias', Icons.flag, Colors.teal, 8, ' Estrategias CPIC'),
        _menuItem('Reportes', Icons.description, Colors.brown, 9, ' Reportes CPIC'),
        _menuItem('Intervenciones', Icons.handshake, Colors.indigo, 10, ' Intervenciones CPIC'),
        _menuItem('Usuarios', Icons.people, Colors.green, 2, ' Usuarios CPIC'),
      ]);
    }

    if (userRole == 'Aprendiz Vocero') {
      menuOptions.addAll([
        _menuItem('Aprendices', Icons.person, Colors.orange, 5, 'Listado Aprendices CPIC'),
        _menuItem('Reportes', Icons.description, Colors.brown, 9, 'Listado Reportes CPIC'),
      ]);
    }

    return menuOptions;
  }

  Widget _menuItem(String title, IconData icon, Color color, int page, String appBarTitle) {
    return Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          leading: Icon(icon, color: color, size: 28),
          trailing: const Icon(Icons.arrow_forward_ios, size: 18),
          onTap: () {
            myReactController.setTituloAppBar(appBarTitle);
            myReactController.setPagina(page);
            Get.back();
          },
        ),
        const Divider(),
      ],
    );
  }

  bool _shouldShowFAB() {
    final userRole = myReactController.userRole;
    final currentPage = myReactController.getPagina;
    
    final Map<String, List<int>> allowedPagesByRole = {
      'Administrador': [1, 2],
      'Instructor': [5, 9],
      'Coordinador': [2, 3, 4, 5, 6, 7, 8, 9, 10],
      'Profesional de Bienestar': [2, 3, 4, 5, 6, 7, 8, 9, 10],
      'Aprendiz Vocero': [5, 9],
    };

    final allowedPages = allowedPagesByRole[userRole] ?? [];
    return allowedPages.contains(currentPage);
  }

  @override
  Widget build(BuildContext context) {
    if (myReactController.getToken.isEmpty) {
      return const ViewLoginCPIC();
    }
    
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Icon(_getCurrentIcon(), size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  myReactController.getTituloAppBar,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          backgroundColor: const Color.fromARGB(255, 7, 25, 83),
          foregroundColor: Colors.white,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Row(
                children: [
                  const Icon(Icons.person, size: 22),
                  const SizedBox(width: 5),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        myReactController.fullName,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        myReactController.userRole,
                        style: const TextStyle(fontSize: 11),
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
            backgroundColor: const Color.fromARGB(255, 23, 214, 214),
            foregroundColor: Colors.white,
            child: const Icon(Icons.add, size: 30),
            onPressed: () {
              var page = myReactController.getPagina;
              if (page == 1) modalEditNewRol(context, "new", null);
              else if (page == 2) modalEditNewUser(context, "new", null);
              else if (page == 3) modalEditNewTrainingProgram(context, "new", null);
              else if (page == 4) modalEditNewGroup(context, "new", null);
              else if (page == 5) modalEditNewApprentice(context, "new", null);
              else if (page == 6) modalEditNewCategory(context, "new", null);
              else if (page == 7) modalEditNewCause(context, "new", null);
              else if (page == 8) modalEditNewStrategy(context, "new", null);
              else if (page == 9) modalEditNewReport(context, "new", null);
              else if (page == 10) modalEditNewIntervention(context, "new", null);
            },
          ),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              // 🔹 Logo Sena Contigo centrado
              Container(
                color: const Color.fromARGB(255, 7, 25, 83),
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  children: [
                    Image.asset(
                      '../assets/images/logoSenaContigo.png',
                      height: 80,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      myReactController.fullName,
                      style: const TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      myReactController.userEmail,
                      style: const TextStyle(fontSize: 13, color: Colors.white70),
                    ),
                    Text(
                      '${myReactController.userRole}',
                      style: const TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                  ],
                ),
              ),

              ..._getMenuOptionsByRole(),

              ListTile(
                title: const Text('Cerrar Sesión', style: TextStyle(fontWeight: FontWeight.bold)),
                leading: const Icon(Icons.logout, color: Colors.redAccent),
                onTap: () {
                  myReactController.logout();
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