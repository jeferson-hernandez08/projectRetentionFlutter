import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../main.dart';

class HomePrincipal extends StatefulWidget {
  const HomePrincipal({super.key});

  @override
  State<HomePrincipal> createState() => _HomePrincipalState();
}

class _HomePrincipalState extends State<HomePrincipal> {
  
  // Método para obtener el mensaje de bienvenida según el rol
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
        welcomeData['message'] = 'Como **Administrador**, tienes acceso completo al sistema para gestionar roles y usuarios.\n\n¡Bienvenido al Sistema de Retención Estudiantil SENA! Este espacio está diseñado para acompañar a los usuarios en su proceso formativo, brindándoles el apoyo necesario para superar cualquier desafío que pueda afectar la permanencia en la institución.';
        welcomeData['quickActions'] = [
          {'title': 'Administrar Roles', 'page': 1, 'icon': Icons.security, 'color': Colors.teal},
          {'title': 'Gestionar Usuarios', 'page': 2, 'icon': Icons.people, 'color': Colors.green},
        ];
        break;

      case 'Instructor':
        welcomeData['message'] = 'Como **Instructor**, eres fundamental en el proceso de detección temprana de situaciones que afecten la permanencia de los aprendices.\n\nTu labor es clave para identificar oportunidades de mejora y reportar casos que requieran intervención, contribuyendo así al éxito formativo de nuestros aprendices.';
        welcomeData['quickActions'] = [
          {'title': 'Gestionar Aprendices', 'page': 5, 'icon': Icons.person, 'color': Colors.orange},
          {'title': 'Crear Reportes', 'page': 9, 'icon': Icons.description, 'color': Colors.brown},
        ];
        break;

      case 'Coordinador':
        welcomeData['message'] = 'Como **Coordinador**, tienes una visión integral del proceso formativo y lideras las estrategias de retención estudiantil.\n\nDesde este espacio podrás gestionar programas, grupos, aprendices y coordinar las intervenciones necesarias para garantizar la permanencia y éxito de nuestros estudiantes.';
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
        welcomeData['message'] = 'Como **Profesional de Bienestar**, eres el pilar del acompañamiento psicosocial y emocional de nuestros aprendices.\n\nTu expertise es fundamental para diseñar estrategias de intervención que fortalezcan la resiliencia y el bienestar integral de la comunidad educativa.';
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
        welcomeData['message'] = 'Como **Aprendiz Vocero**, eres el puente entre la comunidad estudiantil y las instancias de apoyo institucional.\n\nTu rol es fundamental para representar las necesidades de tus compañeros y promover una cultura de acompañamiento y solidaridad entre pares.';
        welcomeData['quickActions'] = [
          {'title': 'Ver Aprendices', 'page': 5, 'icon': Icons.person, 'color': Colors.orange},
          {'title': 'Crear Reportes', 'page': 9, 'icon': Icons.description, 'color': Colors.brown},
        ];
        break;

      default:
        welcomeData['message'] = '¡Bienvenido al Sistema de Retención Estudiantil SENA! Este espacio está diseñado para acompañarte en tu proceso de formación, brindándote el apoyo necesario para superar cualquier desafío que pueda afectar tu permanencia en la institución.';
        welcomeData['quickActions'] = [];
    }

    return welcomeData;
  }

  // Widget para las tarjetas de acciones rápidas
  Widget _buildQuickActionCard(Map<String, dynamic> action) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          myReactController.setPagina(action['page']);
          myReactController.setTituloAppBar('Listado ${action['title']} CPIC');
        },
        child: Container(
          width: 150,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: action['color'].withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  action['icon'],
                  color: action['color'],
                  size: 30,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                action['title'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
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
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado de bienvenida
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.amber.shade700, Colors.amber.shade400],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    welcomeData['title'],
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      welcomeData['role'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    welcomeData['userName'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Mensaje de bienvenida
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mensaje de Bienvenida',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      welcomeData['message'],
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Acciones rápidas
            if (quickActions.isNotEmpty) ...[
              const Text(
                'Acciones Rápidas',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Accede rápidamente a las funcionalidades principales de tu rol:',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 20),
              
              // Grid de acciones rápidas
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.9,
                ),
                itemCount: quickActions.length,
                itemBuilder: (context, index) {
                  return _buildQuickActionCard(quickActions[index] as Map<String, dynamic>);
                },
              ),
            ],

            const SizedBox(height: 32),

            // Información del sistema
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.info, color: Colors.amber, size: 24),
                        SizedBox(width: 8),
                        Text(
                          'Sobre el Sistema',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'En Sena Contigo: Plataforma de Apoyo y Retención de Aprendices SENA está diseñado para prevenir la deserción estudiantil, fortalecer el acompañamiento a los aprendices y mejorar la permanencia en la Regional Caldas.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.amber.withOpacity(0.3)),
                          ),
                          child: const Text(
                            'Regional Caldas',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.amber,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.green.withOpacity(0.3)),
                          ),
                          child: const Text(
                            'CPIC',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}