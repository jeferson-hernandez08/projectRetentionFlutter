import 'package:app_projectretention_711_v1/views/interface/homePrincipal.dart';
import 'package:app_projectretention_711_v1/views/login/viewLogin.dart';
import 'package:app_projectretention_711_v1/views/rols/viewRols.dart';
import 'package:app_projectretention_711_v1/views/users/viewUsers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/reactController.dart';
import 'views/interface/principal.dart';

void main(List<String> args) {
  // Se inyecta en memoria el controlador con las variables reactivas
  Get.put(ReactController()); 
  runApp(Principal());
}

// Se busca la instancia del controlador
ReactController myReactController = Get.find();

// Lista de páginas
List menuPages = [
  HomePrincipal(),       // 0 Home Principal
  ViewRolsCPIC(),        // 1 View rols CPIC
  ViewUsersCPIC(),       // 2 View user CPIC
  // ViewCategoriesCPIC(),  // 3 View categories CPIC
  // ViewEventsCPIC(),      // 4 View events CPIC
  //ViewLoginCPIC()        // 5 View login CPIC // Aqui nueva paginacion login
 
];