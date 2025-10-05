import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../api/apiRetention.dart';

class ViewResetPassword extends StatefulWidget {
  const ViewResetPassword({Key? key}) : super(key: key);

  @override
  _ViewResetPasswordState createState() => _ViewResetPasswordState();
}

class _ViewResetPasswordState extends State<ViewResetPassword> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  String get _token => Get.parameters['token'] ?? '';

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        Get.snackbar(
          'Error', 
          'Las contraseñas no coinciden',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
        );
        return;
      }

      if (_token.isEmpty) {
        Get.snackbar(
          'Error', 
          'Token de recuperación inválido',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
        );
        return;
      }

      setState(() => _isLoading = true);

      final result = await resetPasswordApi(_passwordController.text, _token);

      setState(() => _isLoading = false);

      if (result['success']) {
        Get.snackbar(
          'Éxito', 
          result['message'],
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade600,
          colorText: Colors.white,
          duration: Duration(seconds: 5),
        );
        
        // Redirigir al login después de 2 segundos
        await Future.delayed(Duration(seconds: 2));
        Get.offAllNamed('/login');
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
                      'Restablecer Contraseña',
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
                      
                      // Campo Nueva Contraseña
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFE8E8E8),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            hintText: 'Nueva Contraseña',
                            hintStyle: TextStyle(color: Colors.grey[600]),
                            prefixIcon: Icon(Icons.lock, color: Colors.black),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa tu nueva contraseña';
                            }
                            if (value.length < 6) {
                              return 'La contraseña debe tener al menos 6 caracteres';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 20),

                      // Campo Confirmar Contraseña
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFE8E8E8),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          decoration: InputDecoration(
                            hintText: 'Confirmar Contraseña',
                            hintStyle: TextStyle(color: Colors.grey[600]),
                            prefixIcon: Icon(Icons.lock, color: Colors.black),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword = !_obscureConfirmPassword;
                                });
                              },
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor confirma tu contraseña';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 40),

                      // Botón Restablecer
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
                                onPressed: _resetPassword,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                child: Text(
                                  'RESTABLECER CONTRASEÑA',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ),
                      SizedBox(height: 20),

                      // Botón Volver al Login
                      TextButton(
                        onPressed: () => Get.offAllNamed('/login'),
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