import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../api/apiRetention.dart';
import '../login/viewLogin.dart';

class ViewForgotPassword extends StatefulWidget {
  const ViewForgotPassword({Key? key}) : super(key: key);

  @override
  _ViewForgotPasswordState createState() => _ViewForgotPasswordState();
}

class _ViewForgotPasswordState extends State<ViewForgotPassword> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _documentController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _handleForgotPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final result = await forgotPasswordApi(
        email: _emailController.text,
        document: _documentController.text,
      );

      setState(() => _isLoading = false);

      if (result['success']) {
        _showTempPasswordDialog(result);
      } else {
        Get.snackbar(
          'Error',
          result['message'],
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
        );
      }
    }
  }

  void _showTempPasswordDialog(Map<String, dynamic> result) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Contraseña Temporal Generada'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Hola ${result['userInfo']['firstName']} ${result['userInfo']['lastName']},'),
              const SizedBox(height: 16),
              const Text('Tu contraseña temporal es:'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: SelectableText(
                        result['tempPassword'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: result['tempPassword']));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Contraseña copiada al portapapeles')),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '⚠️ Instrucciones importantes:',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange[800]),
              ),
              const SizedBox(height: 8),
              Text(
                '• Usa esta contraseña para iniciar sesión\n'
                '• Cambia tu contraseña inmediatamente después del login\n'
                '• No compartas esta contraseña con nadie',
                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.offAll(() => const ViewLoginCPIC()),
            child: const Text('Ir al Login'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // ✅ Fondo degradado igual al login
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 7, 25, 83),
              Color.fromARGB(255, 23, 214, 214),
              Color.fromARGB(255, 23, 214, 214),
              Color.fromARGB(255, 23, 214, 214),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                // 🔹 Header con logo y texto superior
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Image.asset(
                        '../assets/images/logoSenaContigo.png',
                        width: 200,
                        height: 100,
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'Sistema de prevención de la deserción',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                // 🔹 Sección blanca con formulario un poco más arriba
                Container(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * 0.75,
                  ),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(140),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start, // 🔺 Subido un poco
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 10), // menos espacio superior

                        // 🔸 Icono + Título + Subtítulo
                        const Icon(
                          Icons.lock_reset_rounded,
                          size: 70,
                          color: Color.fromARGB(255, 7, 25, 83),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Recuperar Contraseña',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Ingresa tu correo institucional y documento\npara restablecer tu acceso.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 25),

                        // 🔸 Formulario
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Campo Email
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8E8E8),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: TextFormField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    hintText: 'Email institucional',
                                    hintStyle: TextStyle(color: Colors.grey[600]),
                                    prefixIcon: const Icon(Icons.email, color: Colors.black),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor ingresa tu email';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 18),

                              // Campo Documento
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8E8E8),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: TextFormField(
                                  controller: _documentController,
                                  decoration: InputDecoration(
                                    hintText: 'Número de documento',
                                    hintStyle: TextStyle(color: Colors.grey[600]),
                                    prefixIcon: const Icon(Icons.badge, color: Colors.black),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor ingresa tu documento';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 50),

                              // Botón Recuperar
                              Container(
                                height: 55,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color.fromARGB(255, 7, 25, 83),
                                      Color.fromARGB(255, 23, 214, 214),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: _isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      )
                                    : ElevatedButton(
                                        onPressed: _handleForgotPassword,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25),
                                          ),
                                        ),
                                        child: const Text(
                                          'RECUPERAR CONTRASEÑA',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                              ),
                              const SizedBox(height: 15),

                              // Botón Volver al login
                              TextButton(
                                onPressed: () => Get.offAll(() => const ViewLoginCPIC()),
                                child: const Text(
                                  'Volver al Login',
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
