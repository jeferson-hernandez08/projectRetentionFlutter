import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../api/apiRetention.dart';
import '../login/viewLogin.dart';     // Importarmos ViewLoginCPIC de viewLogin.dart

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
        // Mostrar diálogo con la contraseña temporal
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
        title: Text('Contraseña Temporal Generada'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Hola ${result['userInfo']['firstName']} ${result['userInfo']['lastName']},'),
              SizedBox(height: 16),
              Text('Tu contraseña temporal es:'),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(12),
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
                      icon: Icon(Icons.copy),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: result['tempPassword']));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Contraseña copiada al portapapeles')),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text(
                '⚠️ Instrucciones importantes:',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange[800]),
              ),
              SizedBox(height: 8),
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
            onPressed: () {
              // ✅ CORRECCIÓN: Usar Get.offAll con la clase directamente
              Get.offAll(() => ViewLoginCPIC());
            },
            child: Text('Ir al Login'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 23, 214, 214),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Image.asset(
                      '../assets/images/logoSenaContigo.png',
                      width: 200,
                      height: 100,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Recuperar Contraseña',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Formulario
              Container(
                margin: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(140),
                  ),
                ),
                padding: EdgeInsets.all(30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 40),
                      
                      // Campo Email
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFE8E8E8),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: 'Email institucional',
                            hintStyle: TextStyle(color: Colors.grey[600]),
                            prefixIcon: Icon(Icons.email, color: Colors.black),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa tu email';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 20),

                      // Campo Documento
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFE8E8E8),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: TextFormField(
                          controller: _documentController,
                          decoration: InputDecoration(
                            hintText: 'Número de documento',
                            hintStyle: TextStyle(color: Colors.grey[600]),
                            prefixIcon: Icon(Icons.badge, color: Colors.black),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa tu documento';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 40),

                      // Botón Recuperar Contraseña
                      Container(
                        height: 55,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 7, 25, 83),
                              Color.fromARGB(255, 23, 214, 214),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: _isLoading
                            ? Center(
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
                                child: Text(
                                  'RECUPERAR CONTRASEÑA',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ),
                      SizedBox(height: 20),

                      // ✅ CORRECCIÓN: Botón Volver al Login usando la clase directamente
                      TextButton(
                        onPressed: () => Get.offAll(() => ViewLoginCPIC()),
                        child: Text(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}