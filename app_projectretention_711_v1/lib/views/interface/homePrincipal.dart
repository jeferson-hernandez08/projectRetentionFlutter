import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../main.dart';

class HomePrincipal extends StatefulWidget {
  const HomePrincipal({super.key});

  @override
  State<HomePrincipal> createState() => _HomePrincipalState();
}

class _HomePrincipalState extends State<HomePrincipal> {
  Map<String, dynamic> _getWelcomeData() {
    final userRole = myReactController.userRole;
    final userName = myReactController.fullName;

    Map<String, dynamic> welcomeData = {
      'title': '¡Bienvenido!',
      'role': userRole,
      'userName': userName,
      'message': '',
      'quickActions': [],
    };

    switch (userRole) {
      case 'Administrador':
        welcomeData['message'] =
            'Como **Administrador**, tienes acceso completo al sistema para gestionar roles y usuarios.\n\n¡Bienvenido al Sistema de Retención Estudiantil SENA! Este espacio está diseñado para acompañar a los usuarios en su proceso formativo.';
        welcomeData['quickActions'] = [
          {'title': 'Administrar Roles', 'page': 1, 'icon': Icons.security, 'color': Colors.teal},
          {'title': 'Gestionar Usuarios', 'page': 2, 'icon': Icons.people, 'color': Colors.green},
        ];
        break;

      case 'Instructor':
        welcomeData['message'] =
            'Como **Instructor**, eres fundamental en el proceso de detección temprana de situaciones que afecten la permanencia de los aprendices.\n\nTu labor es clave para reportar casos que requieran intervención y contribuir al éxito formativo.';
        welcomeData['quickActions'] = [
          {'title': 'Gestionar Aprendices', 'page': 5, 'icon': Icons.person, 'color': Colors.orange},
          {'title': 'Crear Reportes', 'page': 9, 'icon': Icons.description, 'color': Colors.brown},
        ];
        break;

      case 'Coordinador':
        welcomeData['message'] =
            'Como **Coordinador**, lideras las estrategias de retención estudiantil y monitoreas el avance académico.';
        welcomeData['quickActions'] = [
          {'title': 'Programas', 'page': 3, 'icon': Icons.school, 'color': Colors.deepPurple},
          {'title': 'Grupos', 'page': 4, 'icon': Icons.groups, 'color': Colors.cyan},
          {'title': 'Aprendices', 'page': 5, 'icon': Icons.person, 'color': Colors.orange},
          {'title': 'Reportes', 'page': 9, 'icon': Icons.description, 'color': Colors.brown},
          {'title': 'Intervenciones', 'page': 10, 'icon': Icons.handshake, 'color': Colors.indigo},
          {'title': 'Estrategias', 'page': 8, 'icon': Icons.flag, 'color': Colors.teal},
        ];
        break;

      case 'Profesional de Bienestar':
        welcomeData['message'] =
            'Como **Profesional de Bienestar**, acompañas el desarrollo psicosocial y emocional de los aprendices.';
        welcomeData['quickActions'] = [
          {'title': 'Categorías', 'page': 6, 'icon': Icons.category, 'color': Colors.purple},
          {'title': 'Causas', 'page': 7, 'icon': Icons.warning_amber, 'color': Colors.red},
          {'title': 'Estrategias', 'page': 8, 'icon': Icons.flag, 'color': Colors.teal},
          {'title': 'Aprendices', 'page': 5, 'icon': Icons.person, 'color': Colors.orange},
          {'title': 'Reportes', 'page': 9, 'icon': Icons.description, 'color': Colors.brown},
          {'title': 'Intervenciones', 'page': 10, 'icon': Icons.handshake, 'color': Colors.indigo},
        ];
        break;

      case 'Aprendiz Vocero':
        welcomeData['message'] =
            'Como **Aprendiz Vocero**, representas a tus compañeros y fortaleces la comunicación institucional.';
        welcomeData['quickActions'] = [
          {'title': 'Ver Aprendices', 'page': 5, 'icon': Icons.person, 'color': Colors.orange},
          {'title': 'Crear Reportes', 'page': 9, 'icon': Icons.description, 'color': Colors.brown},
        ];
        break;

      default:
        welcomeData['message'] =
            '¡Bienvenido a **SENA Contigo**! Este espacio está diseñado para acompañarte en tu proceso de formación.';
        welcomeData['quickActions'] = [];
    }

    return welcomeData;
  }

  /// ✅ SOLO mejora visual de botones de acciones rápidas
Widget _buildQuickActionCard(Map<String, dynamic> action) {
  return Card(
    color: Colors.white,
    elevation: 4, // Reducido para un estilo más sutil y moderno
    shadowColor: action['color'].withOpacity(0.2), // Opacidad más baja para sombra más suave
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), // Radio más pequeño para una forma menos "píldora" y más compacta
    child: InkWell(
      borderRadius: BorderRadius.circular(80), // Coincide con el Card para consistencia
      splashColor: action['color'].withOpacity(0.12), // Splash más sutil
      onTap: () {
        myReactController.setPagina(action['page']);
        myReactController.setTituloAppBar('Listado ${action['title']} CPIC');
      },
      child: Padding(
        padding: const EdgeInsets.all(12), // Padding reducido para hacer el widget más pequeño
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: action['color'].withOpacity(0.1), // Opacidad más baja para fondo de icono más discreto
              ),
              padding: const EdgeInsets.all(12), // Padding del icono reducido para tamaño general más pequeño
              child: Icon(
                action['icon'],
                color: action['color'],
                size: 28, // Icono un poco más pequeño
              ),
            ),
            const SizedBox(height: 8), // Espacio reducido entre icono y texto
            Text(
              action['title'],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14, // Tamaño de fuente un poco más pequeño
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final welcomeData = _getWelcomeData();
    final quickActions = welcomeData['quickActions'] as List<dynamic>;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 7, 25, 83),
              Color.fromARGB(255, 23, 214, 214),
              Color.fromARGB(255, 23, 214, 214),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ LOGO CENTRADO
                Center(
                  child: Image.asset(
                    '../assets/images/logoSenaContigo.png',
                    height: 85,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 25),

                // TARJETA DE BIENVENIDA (igual)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.waving_hand,
                          color: Color.fromARGB(255, 7, 25, 83), size: 34),
                      const SizedBox(height: 10),
                      Text(
                        welcomeData['title'],
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 7, 25, 83),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        welcomeData['userName'],
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 23, 214, 214).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          welcomeData['role'],
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 7, 25, 83),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // MENSAJE DE BIENVENIDA (igual)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.message_rounded,
                              color: Color.fromARGB(255, 7, 25, 83)),
                          SizedBox(width: 8),
                          Text(
                            'Mensaje de Bienvenida',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 7, 25, 83),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        welcomeData['message'],
                        style: const TextStyle(fontSize: 15, height: 1.5, color: Colors.black87),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // ✅ ACCIONES RÁPIDAS (solo visual mejorado)
                if (quickActions.isNotEmpty) ...[
                  const Text(
                    'Acciones Rápidas',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 14),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1,
                    ),
                    itemCount: quickActions.length,
                    itemBuilder: (context, index) {
                      return _buildQuickActionCard(quickActions[index]);
                    },
                  ),
                ],

                const SizedBox(height: 40),

                // SOBRE EL SISTEMA (igual)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline,
                              color: Color.fromARGB(255, 7, 25, 83)),
                          SizedBox(width: 8),
                          Text(
                            'Sobre el Sistema',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 7, 25, 83),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        'SENA Contigo: Plataforma de Apoyo y Retención Estudiantil.\nFortalece el acompañamiento a los aprendices y mejora la permanencia en la Regional Caldas.',
                        style: TextStyle(fontSize: 14, height: 1.5, color: Colors.black87),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),
                Center(
                  child: Text(
                    '© 2025 SENA Contigo · Regional Caldas',
                    style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
