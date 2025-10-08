import 'package:app_projectretention_711_v1/views/apprentices/viewApprentices.dart';
import 'package:app_projectretention_711_v1/views/categories/viewCategories.dart';
import 'package:app_projectretention_711_v1/views/causes/viewCauses.dart';
import 'package:app_projectretention_711_v1/views/groups/viewGroups.dart';
import 'package:app_projectretention_711_v1/views/interface/homePrincipal.dart';
import 'package:app_projectretention_711_v1/views/interventions/viewInterventions.dart';
import 'package:app_projectretention_711_v1/views/login/viewLogin.dart';
import 'package:app_projectretention_711_v1/views/reports/viewReports.dart';
import 'package:app_projectretention_711_v1/views/rols/viewRols.dart';
import 'package:app_projectretention_711_v1/views/strategies/viewStrategies.dart';
import 'package:app_projectretention_711_v1/views/trainingPrograms/viewtrainingPrograms.dart';
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
List menuPages = [              // Array para diferentes paginaciones 
  HomePrincipal(),              // 0 Home Principal
  ViewRolsCPIC(),               // 1 View rols CPIC
  ViewUsersCPIC(),              // 2 View user CPIC
  ViewTrainingProgramsCPIC(),   // 3 View training_programs CPIC
  ViewGroupsCPIC(),             // 4 View groups CPIC
  ViewApprenticesCPIC(),        // 5 View apprentices CPIC
  ViewCategoriesCPIC(),         // 6 View categories CPIC
  ViewCausesCPIC(),             // 7 View causes CPIC
  ViewStrategiesCPIC(),         // 8 View strategies CPIC
  ViewReportsCPIC(),            // 9 View strategies CPIC
  ViewInterventionsCPIC()       // 10 View strategies CPIC
 
];

// testo github
// test jeferson 
// testeo 2