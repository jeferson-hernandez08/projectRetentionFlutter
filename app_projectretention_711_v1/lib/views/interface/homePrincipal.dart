import 'package:flutter/material.dart';

class HomePrincipal extends StatefulWidget {
  const HomePrincipal({super.key});

  @override
  State<HomePrincipal> createState() => _HomePrincipalState();
}

class _HomePrincipalState extends State<HomePrincipal> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text('En la App Retención SENA podrás acceder a estrategias, reportes e intervenciones diseñadas para prevenir la deserción estudiantil, fortalecer el acompañamiento a los aprendices y mejorar la permanencia en la Regional Caldas.'),
        ),
      ),
    );
  }
}