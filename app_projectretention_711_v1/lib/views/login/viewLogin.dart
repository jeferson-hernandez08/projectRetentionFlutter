import 'package:app_projectretention_711_v1/views/interface/inicio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import '../../api/apiRetention.dart';


class ViewLoginCPIC extends StatefulWidget {
  const ViewLoginCPIC({super.key});

  @override
  State<ViewLoginCPIC> createState() => _ViewLoginCPICState();
}

class _ViewLoginCPICState extends State<ViewLoginCPIC> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _rememberMe = false;
  //bool modoDesarrollo = true;  // Cambiar esta bandera a true para saltar login | Mientras tanto para ingreso facil
 

  // Función para manejar el login
  Future<void> _handleLogin() async {
    // if (modoDesarrollo) {
    //   Get.offAll(() => const Inicio());
    //   return;
    // }

    // 🔹 Login real con API
    if (_formKey.currentState!.validate()) {
      // Cerrar teclado
      FocusScope.of(context).unfocus();
      
      setState(() => _isLoading = true);
      
      // Simular un pequeño delay para que se vea la animación de carga
      await Future.delayed(const Duration(milliseconds: 500));
      
      bool success = await loginApi(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      setState(() => _isLoading = false);

      if (success) {
        // Mostrar mensaje de éxito con una animación
        Get.snackbar(
          '¡Éxito!', 
          'Inicio de sesión satisfactorio',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade600,
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle, color: Colors.white),
          shouldIconPulse: true,
          barBlur: 20,
          isDismissible: true,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(10),
          borderRadius: 10,
        );
        
        // Navegar al inicio después de un breve delay
        await Future.delayed(const Duration(milliseconds: 1500));
        Get.offAll(() => Inicio());
      } else {
        // Mostrar error con vibración
        HapticFeedback.heavyImpact();
        Get.snackbar(
          'Error', 
          'Credenciales incorrectas. Por favor, inténtalo de nuevo.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
          icon: const Icon(Icons.error_outline, color: Colors.white),
          shouldIconPulse: true,
          barBlur: 20,
          isDismissible: true,
          duration: const Duration(seconds: 4),
          margin: const EdgeInsets.all(10),
          borderRadius: 10,
        );
      }
    }
  }

  // Función para recuperar contraseña
  void _handleForgotPassword() {
    if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
      Get.snackbar(
        'Email requerido', 
        'Por favor, ingresa tu email para recuperar tu contraseña',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade600,
        colorText: Colors.white,
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Recuperar contraseña'),
          content: Text(
              '¿Deseas enviar un enlace de recuperación a ${_emailController.text}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Get.snackbar(
                  'Enlace enviado', 
                  'Revisa tu correo electrónico para restablecer tu contraseña',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green.shade600,
                  colorText: Colors.white,
                );
              },
              child: const Text('Enviar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 7, 25, 83), // Verde azulado más oscuro
              Color.fromARGB(255, 23, 214, 214), // Verde azulado medio
              Color.fromARGB(255, 23, 214, 214), // Verde azulado medio
              Color.fromARGB(255, 23, 214, 214), // Verde azulado medio
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                // Header con logos y título
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  child: Column(
                    children: [
                      // Logo placeholder - reemplazar con tu imagen real
                      Container(
                        child: Image.asset(
                          '../assets/images/logoSenaContigo.png',
                          width: 200,
                          height: 100,
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Subtítulo
                      const Text.rich(
                        TextSpan(
                          text: 'Sistema de prevención\n',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            height: 1.3,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'de la deserción',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                // Contenedor del formulario
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(140),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 20),
                          // Título Login
                          const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          // Subtítulo
                          const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              'Ingreso de usuarios registrados',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 40),

                          // Campo Email
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8E8E8),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                hintText: 'Correo electrónico',
                                hintStyle: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                                prefixIcon: const Icon(
                                  Icons.email,
                                  color: Colors.black,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 18,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingresa tu correo electrónico';
                                }
                                if (!value.contains('@') || !value.contains('.')) {
                                  return 'Por favor ingresa un correo electrónico válido';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Campo Contraseña
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8E8E8),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                hintText: 'Contraseña',
                                hintStyle: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  color: Colors.black,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 18,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingresa tu contraseña';
                                }
                                if (value.length < 6) {
                                  return 'La contraseña debe tener al menos 6 caracteres';
                                }
                                return null;
                              },
                              onFieldSubmitted: (_) => _handleLogin(),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Enlace para recuperar contraseña
                          GestureDetector(
                            onTap: _handleForgotPassword,
                            child: const Text(
                              '¿Olvidaste tu contraseña?',
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 40),

                          // Botón Ingresar
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
                                      strokeWidth: 3,
                                    ),
                                  )
                                : ElevatedButton(
                                    onPressed: _handleLogin,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                    ),
                                    child: const Text(
                                      'INICIAR SESIÓN',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  ),
                          ),

                          const SizedBox(height: 40),

                          // Texto inferior
                          const Text(
                            'Seguimiento y apoyo para aprendices',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),

                          const Text.rich(
                            TextSpan(
                              text: 'Sistema de prevención\n',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                height: 1.3,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'de la deserción',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Pie de página
                          const Text(
                            '© 2025 Mi Bienestar SENA. Todos los derechos reservados.',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}