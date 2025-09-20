import 'package:flutter/material.dart';

modalDetailUser(BuildContext context , dynamic user) {
  showModalBottomSheet(
    context: context, 
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context){
    return Scaffold(
      appBar: AppBar(       // AppBar
        title: Text(
          'Detalles del Usuario ${user['name']}',
          style: const TextStyle(     // Estilo para el texto Text
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 10,
        actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),   // onPressed: Accion al dar click . Navigator: Clase de futter. pop: Eliminar osea que que cierra el modal o la ruta.
            ),
          ],
      ),
      body: SingleChildScrollView(   // Cuerpo del modal
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,    // alinean los hijos de un widget como Column o Row) en este caaso al inicio
            children: [
              // Sección 1: Header con Avatar y Datos Básicos
              UserHeader(user),
              const SizedBox(height: 25),
              
              // Sección 2: Información de Contacto
              SectionTitle("Contacto"),
              InfoCard(
                icon: Icons.email,
                title: "Email",
                content: user['email'],
              ),
              InfoCard(
                icon: Icons.phone,
                title: "Teléfono",
                content: user['phone'],
              ),
              InfoCard(
                icon: Icons.public,
                title: "Website",
                content: user['website'],
                isLast: true,
              ),
              
              // Sección 3: Dirección
              SectionTitle("Dirección"),
              ...AddressInfo(user['address']),    // operador spread (...): Spread operator para insertar varios widgets
              
              // Sección 4: Empresa
              SectionTitle("Empresa"),
              CompanyCard(user['company']),
            ],
          ),
        ),
    );
  });
}

// CREACUIÓN DE WIDGETS PARA LOS DATOS
// 1. Encabezado de Usuario | Avatar y datos basicos
Widget UserHeader(dynamic user) {
  return Center(
    child: Column(
      children: [      // Array de varios elemntos
        CircleAvatar(  // Avatar
          radius: 60,
          backgroundColor: Colors.deepPurple[100],
          child: const Icon(
            Icons.person,
            size: 60,
            color: Colors.deepPurple,
          ),
        ),
        const SizedBox(height: 15),
        Text(  // Nombre
          user['name'],
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(  // Username
          '@${user['username']}',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey[600],
          ),
        ),
      ],
    ),
  );
}

// 2. Título de cada Sección | Manera dinamica
Widget SectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.deepPurple,
      ),
    ),
  );
}

// 3. Tarjeta de Información Genérica
Widget InfoCard({
  required IconData icon,
  required String title,
  required String content,
  bool isLast = false,
}) {
  return Card(
    margin: EdgeInsets.only(bottom: isLast ? 20 : 8),
    elevation: 3,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: ListTile(
      leading: Icon(icon, color: Colors.deepPurple),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(content),
    ),
  );
}

// 4. Información de Dirección (Geo + Texto) | Acceder al map address dentro de user
List<Widget> AddressInfo(Map<String, dynamic> address) {
  final geo = address['geo'];    // Acceder al mapa geo dentro de address
  return [
    InfoCard(    // Varios widgets en una lista esto es los ...
      icon: Icons.home,
      title: "Calle",
      content: address['street'],   // Accemos al map address en la pacision street
    ),
    InfoCard(
      icon: Icons.apartment,
      title: "Suite",
      content: address['suite'],
    ),
    InfoCard(
      icon: Icons.location_city,
      title: "Ciudad",
      content: "${address['city']} (${address['zipcode']})",
    ),
    Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: const Icon(Icons.map, color: Colors.deepPurple),
        title: const Text("Geolocalización", style: TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text("Lat: ${geo['lat']}, Lng: ${geo['lng']}"),
        // trailing: IconButton(
        //   icon: const Icon(Icons.open_in_new),
        //   onPressed: () => print("Abrir mapa..."),
        // ),
      ),
    ),
  ];
}

// 5. Tarjeta de Empresa | Acceder al map company dentro de user
Widget CompanyCard(Map<String, dynamic> company) {
  return Card(
    elevation: 3,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            company['name'],
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            company['catchPhrase'],
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            company['bs'],
            style: const TextStyle(color: Colors.deepPurple),
          ),
        ],
      ),
    ),
  );
}

