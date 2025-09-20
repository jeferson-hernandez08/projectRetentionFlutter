import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'inicio.dart';

class Principal extends StatelessWidget {
  const Principal({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Proyecto Retencion SENA',
      debugShowCheckedModeBanner: false,
      home: Inicio(),


    );
  }
}