<div align="center">
<img src="assets/images/logoSenaContigo.png" alt="SENA Contigo Logo" width="220"/>
# 🎓 SENA Contigo
### Plataforma de Apoyo y Retención de Aprendices
 
[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
[![GetX](https://img.shields.io/badge/GetX-State_Manager-8A2BE2?style=for-the-badge)](https://pub.dev/packages/get)
[![Node.js](https://img.shields.io/badge/API-Node.js-339933?style=for-the-badge&logo=nodedotjs&logoColor=white)](https://nodejs.org/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![Android](https://img.shields.io/badge/Android-APK-3DDC84?style=for-the-badge&logo=android&logoColor=white)](https://developer.android.com/)
[![Version](https://img.shields.io/badge/Versión-1.0_Flutter-blue?style=for-the-badge)](https://github.com/jeferson-hernandez08/projectRetentionFlutter)
 
*Flutter · Dart · GetX · MVC · API REST Node.js · PostgreSQL*
 
[📱 Descargar APK](#-despliegue-y-distribución) · [🌐 API en producción](https://api-projectretention-711.onrender.com/) · [📋 Documentación](#-documentación-de-la-api) · [🐛 Reportar bug](../../issues)
 
</div>
---
 
## 📌 Tabla de Contenidos
 
- [Sobre el Proyecto](#-sobre-el-proyecto)
- [Ecosistema SENA Contigo](#-ecosistema-sena-contigo)
- [Capturas de Pantalla](#-capturas-de-pantalla)
- [Arquitectura](#-arquitectura)
- [Tecnologías y Dependencias](#-tecnologías-y-dependencias)
- [Estructura del Proyecto](#-estructura-del-proyecto)
- [Módulos y Funcionalidades](#-módulos-y-funcionalidades)
- [Requisitos del Sistema](#-requisitos-del-sistema)
- [Instalación y Configuración](#-instalación-y-configuración)
- [Despliegue y Distribución](#-despliegue-y-distribución)
- [Documentación de la API](#-documentación-de-la-api)
- [Seguridad](#-seguridad)
- [Equipo](#-equipo)
---
 
## 🎯 Sobre el Proyecto
 
**SENA Contigo** es una aplicación móvil desarrollada en **Flutter** para el **Centro de Procesos Industriales y Construcción (CPIC) del SENA**, cuyo objetivo es combatir la deserción estudiantil mediante el seguimiento en tiempo real del progreso de los aprendices, la detección temprana de riesgos y el registro de intervenciones de apoyo.
 
La app actúa como la **capa de presentación (frontend)** del ecosistema SENA Contigo, consumiendo los servicios expuestos por la **API REST** desarrollada en **Node.js + Express**, y brindando a instructores, coordinadores y personal de bienestar una herramienta ágil, segura e intuitiva disponible desde cualquier dispositivo Android.
 
> 💡 **Versión 1.0 — Framework Frontend Flutter.** La aplicación implementa una arquitectura reactiva basada en **GetX**, garantizando una experiencia de usuario fluida y una integración sólida con el backend del sistema.
 
---
 
## 🌐 Ecosistema SENA Contigo
 
Este repositorio es el **frontend móvil** del ecosistema SENA Contigo, compuesto por tres proyectos interconectados:
 
| Repositorio | Tecnología | Rol | URL / Link |
|---|---|---|---|
| **`projectRetentionFlutter`** *(este repo)* | Flutter + Dart | 📱 App móvil — Frontend principal | — |
| `api_projectretention_711` | Node.js + Express | ⚙️ API REST — Backend y base de datos | [Ver repositorio](https://github.com/jeferson-hernandez08/api_projectretention_711) |
| `projectRetencion` | PHP + MVC | 🌐 Plataforma web de administración | — |
 
> 🔗 La aplicación Flutter se comunica exclusivamente con la **API REST** mediante solicitudes HTTP/HTTPS en formato JSON, con autenticación JWT en cada petición.
 
---
 
## 📸 Capturas de Pantalla
 
<div align="center">
| Login | Dashboard | Reportes |
|---|---|---|
| *(Pantalla de acceso con validación JWT)* | *(Panel principal del sistema)* | *(Gestión de reportes de riesgo)* |
 
| Aprendices | Intervenciones | Perfil |
|---|---|---|
| *(Listado y seguimiento)* | *(Registro de acciones)* | *(Datos del usuario autenticado)* |
 
</div>
> 📌 *Reemplaza este bloque con capturas reales de la aplicación.*
 
---
 
## 🏗 Arquitectura
 
La app implementa una arquitectura **reactiva modular** basada en **GetX**, con separación clara entre la capa de datos (API), lógica (controladores) y presentación (vistas).
 
```
┌─────────────────────────────────────────────────────────────┐
│                  USUARIO FINAL (Android)                    │
│                  Interacción con la UI                      │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────┐
│                    VISTAS  (lib/views/)                     │
│   Login · Dashboard · Aprendices · Reportes · Usuarios      │
│         Intervenciones · Programas · Grupos ...             │
└───────────────────────┬─────────────────────────────────────┘
                        │  Obserba y llama al controlador
                        ▼
┌─────────────────────────────────────────────────────────────┐
│             CONTROLADOR GLOBAL  (lib/controllers/)          │
│                   ReactController.dart                      │
│  • Estado global (.obs) · Token JWT · Usuario autenticado   │
│  • Listas de datos · Navegación · Roles · Cierre de sesión  │
└───────────────────────┬─────────────────────────────────────┘
                        │  Llama a los servicios de API
                        ▼
┌─────────────────────────────────────────────────────────────┐
│              SERVICIOS API  (lib/api/)                      │
│             apiRetention.dart  +  archivos por módulo       │
│     Peticiones HTTP: GET · POST · PUT · DELETE + JWT        │
└───────────────────────┬─────────────────────────────────────┘
                        │  HTTPS / JSON
                        ▼
┌─────────────────────────────────────────────────────────────┐
│          API REST BACKEND  (api_projectretention_711)       │
│       Node.js + Express + Sequelize ORM + PostgreSQL        │
│    https://api-projectretention-711.onrender.com/api/v1     │
└─────────────────────────────────────────────────────────────┘
```
 
### Flujo de una interacción
 
```
Usuario toca botón en Vista
  → Vista llama al ReactController (GetX)
  → Controller invoca servicio en lib/api/
  → Servicio hace petición HTTP con token JWT
  → API REST responde en JSON
  → Controller actualiza variable .obs
  → Vista se reconstruye automáticamente (reactivo)
```
 
### ReactController — Núcleo de la Aplicación
 
El `ReactController` es el corazón del sistema. Gestiona de forma centralizada:
 
| Responsabilidad | Detalle |
|---|---|
| 🔐 **Autenticación** | Almacena y valida el token JWT, maneja login/logout |
| 👤 **Usuario activo** | Nombre, email, rol, ID del usuario autenticado |
| 📋 **Listas de datos** | Roles, usuarios, aprendices, programas, grupos, reportes, intervenciones, etc. |
| 🧭 **Navegación** | Controla el índice de página activa (`_pagina.obs`) |
| 🔒 **Control de roles** | Método `hasRole()` para restringir funcionalidades por perfil |
| 🧹 **Limpieza de estado** | Reinicia toda la información al cerrar sesión |
 
---
 
## 🛠 Tecnologías y Dependencias
 
### Core
 
| Tecnología | Versión | Descripción |
|---|---|---|
| ![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white) | 3.x estable | Framework multiplataforma para construir la app |
| ![Dart](https://img.shields.io/badge/Dart-0175C2?logo=dart&logoColor=white) | 3.x | Lenguaje de programación — POO + async/await |
 
### Gestión de Estado y Navegación
 
| Librería | Versión | Descripción |
|---|---|---|
| **GetX** | ^4.x | Estado reactivo `.obs`, navegación sin contexto, inyección de dependencias |
 
> 🔑 **GetX** es la librería arquitectónica principal del proyecto. Permite que cualquier cambio en el `ReactController` se refleje automáticamente en todas las vistas sin `setState()` ni `StreamBuilder`.
 
### Comunicación con la API
 
| Librería | Descripción |
|---|---|
| **http** | Peticiones HTTP (GET, POST, PUT, DELETE) con envío de token JWT |
| **dart:convert** | Serialización / deserialización de JSON |
 
### Almacenamiento y Utilidades
 
| Librería | Descripción |
|---|---|
| **GetStorage** | Almacenamiento local seguro (caché de sesión) |
| **intl** | Formateo de fechas y datos internacionales |
 
### UI / Diseño
 
| Tecnología | Descripción |
|---|---|
| **Material Design (Flutter SDK)** | Widgets nativos: botones, formularios, listas, cards, navegación |
 
### Herramientas de Desarrollo
 
| Herramienta | Descripción |
|---|---|
| **Android Studio / VS Code** | IDEs recomendados con plugins Flutter y Dart |
| **flutter pub** | Gestor de paquetes de Flutter |
| **ADB** | Android Debug Bridge — instalación en dispositivos físicos |
| **Git** | Control de versiones |
 
---
 
## 📁 Estructura del Proyecto
 
```
projectRetentionFlutter/
│
├── lib/
│   │
│   ├── api/                        # Capa de comunicación con la API REST
│   │   ├── apiRetention.dart       # ⭐ Archivo principal — todos los CRUDs y endpoints
│   │   └── ...                     # Archivos complementarios por módulo
│   │
│   ├── controllers/                # Controladores — lógica y estado global (GetX)
│   │   └── ReactController.dart   # ⭐ Controlador principal del sistema
│   │
│   ├── views/                      # Pantallas de la aplicación (UI)
│   │   ├── login/                  # Vista de autenticación
│   │   ├── home/                   # Dashboard principal
│   │   ├── usuarios/               # Gestión de usuarios
│   │   ├── aprendices/             # Gestión de aprendices
│   │   ├── programas/              # Programas de formación
│   │   ├── grupos/                 # Grupos / fichas
│   │   ├── reportes/               # Reportes de riesgo
│   │   ├── intervenciones/         # Intervenciones de apoyo
│   │   ├── categorias/             # Categorías de riesgo
│   │   ├── causas/                 # Causas de deserción
│   │   ├── estrategias/            # Estrategias de intervención
│   │   └── roles/                  # Gestión de roles
│   │
│   ├── widgets/                    # Componentes reutilizables de UI
│   ├── routes/                     # Definición de rutas de navegación
│   ├── utils/                      # Utilidades y helpers
│   └── main.dart                   # ⭐ Punto de entrada — inicializa GetX y la app
│
├── android/                        # Configuración nativa Android
│   ├── app/
│   │   ├── build.gradle
│   │   └── src/
│   └── key.properties              # Configuración de firma (producción)
│
├── assets/                         # Recursos estáticos
│   └── images/                     # Imágenes y logos del sistema
│
├── build/
│   └── app/outputs/flutter-apk/   # APK generado tras compilación
│       └── app-release.apk
│
├── pubspec.yaml                    # Dependencias y configuración del proyecto
├── pubspec.lock                    # Lock de versiones
└── README.md                       # Este archivo
```
 
---
 
## ✨ Módulos y Funcionalidades
 
### 👥 Roles de Usuario
 
| Rol | Acceso en la App |
|---|---|
| 🔴 **Coordinador Académico** | Acceso total — todos los módulos y reportes globales |
| 🟠 **Instructor** | Gestión de reportes, intervenciones y aprendices de su grupo |
| 🟢 **Prof. de Bienestar** | Estrategias de apoyo y seguimiento de aprendices |
| 🔵 **Aprendiz Vocero** | Solo visualización de información |
 
### 📋 Vistas y Operaciones
 
Cada módulo implementa operaciones **CRUD completas** consumiendo la API REST:
 
| Módulo | Operaciones |
|---|---|
| 🔐 **Login** | Autenticación con JWT, validación de credenciales |
| 🏠 **Dashboard / Home** | Vista general del sistema, navegación por módulos |
| 👤 **Usuarios** | Crear, listar, editar y eliminar usuarios del sistema |
| 🎓 **Aprendices** | Registro completo, estado y seguimiento de aprendices |
| 📚 **Programas de Formación** | Gestión de programas técnicos y tecnológicos |
| 👥 **Grupos / Fichas** | Administración de grupos por programa |
| ⚠️ **Categorías y Causas** | Categorías y causas de riesgo de deserción |
| 📋 **Reportes** | Creación y consulta de reportes de riesgo por aprendiz |
| 🤝 **Intervenciones** | Registro y seguimiento de intervenciones aplicadas |
| 💡 **Estrategias** | Estrategias de apoyo disponibles en el sistema |
| 🔑 **Roles** | Gestión de roles y permisos del sistema |
 
---
 
## ⚙️ Requisitos del Sistema
 
### Software de Desarrollo
 
| Requisito | Versión mínima |
|---|---|
| **Flutter SDK** | 3.x (canal estable) |
| **Dart SDK** | Incluido con Flutter |
| **Android Studio** o **VS Code** | Última versión estable |
| **Android SDK** | API Level 21+ (Android 5.0+) |
| **Git** | Cualquier versión reciente |
 
### Hardware Recomendado
 
| Componente | Mínimo | Recomendado |
|---|---|---|
| **CPU** | 2 núcleos | 4 núcleos o superior |
| **RAM** | 4 GB | 8 GB o superior |
| **Almacenamiento** | 20 GB libres (SSD) | 40 GB SSD |
| **Dispositivo de prueba** | Emulador Android | Dispositivo físico Android |
 
### Dispositivo de Usuario Final
 
| Requisito | Detalle |
|---|---|
| **Sistema Operativo** | Android 5.0 (API 21) o superior |
| **RAM** | 2 GB mínimo |
| **Almacenamiento** | ~50 MB para la app |
| **Conectividad** | Internet requerido (consume API REST) |
 
---
 
## 🚀 Instalación y Configuración
 
### 1. Clonar el repositorio
 
```bash
git clone https://github.com/jeferson-hernandez08/projectRetentionFlutter.git
cd projectRetentionFlutter
```
 
### 2. Verificar el entorno Flutter
 
```bash
flutter doctor
```
 
Asegúrate de que no haya errores críticos. Corrige los problemas indicados antes de continuar.
 
### 3. Instalar dependencias
 
```bash
flutter pub get
```
 
Esto descarga todas las librerías definidas en `pubspec.yaml`: GetX, http, GetStorage, intl, etc.
 
### 4. Configurar la URL de la API
 
Edita el archivo de configuración de la API:
 
```
lib/api/apiRetention.dart
```
 
Localiza la URL base y actualízala según el entorno:
 
```dart
// Desarrollo local
const String baseUrl = "http://10.0.2.2:4000/api/v1";
 
// Producción (Render)
const String baseUrl = "https://api-projectretention-711.onrender.com/api/v1";
```
 
> ⚠️ En emuladores Android, `10.0.2.2` apunta a `localhost` de tu máquina.
 
### 5. Ejecutar la aplicación
 
Conecta un emulador o dispositivo físico, luego:
 
```bash
flutter run
```
 
También puedes presionar **F5** en VS Code o Android Studio para lanzar con depuración.
 
### 6. Verificar configuración inicial
 
Antes de ejecutar, confirma:
 
- ✅ `ReactController` correctamente inyectado en `main.dart` (`Get.put(ReactController())`)
- ✅ URL base de la API configurada
- ✅ API REST en funcionamiento (local o en Render)
- ✅ Dependencias instaladas (`flutter pub get`)
---
 
## 📦 Despliegue y Distribución
 
### Compilar APK para producción
 
```bash
flutter build apk --release
```
 
El archivo generado se encuentra en:
 
```
build/app/outputs/flutter-apk/app-release.apk
```
 
### Firmar la aplicación (distribución oficial)
 
**1. Generar keystore:**
```bash
keytool -genkey -v -keystore key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key
```
 
**2. Configurar `android/key.properties`:**
```properties
storePassword=tu_contraseña
keyPassword=tu_contraseña
keyAlias=key
storeFile=../key.jks
```
 
**3. Referenciar en `android/app/build.gradle`** según la documentación oficial de Flutter.
 
### Instalar en dispositivo físico
 
```bash
# Con ADB
adb install build/app/outputs/flutter-apk/app-release.apk
 
# O transferir el APK directamente al dispositivo
```
 
### Generar AAB (Google Play Store)
 
```bash
flutter build appbundle --release
```
 
---
 
## 📡 Documentación de la API
 
La aplicación Flutter consume la **API REST SENA Contigo**, desplegada en Render.
 
### Información General
 
| Campo | Valor |
|---|---|
| **URL Base de producción** | `https://api-projectretention-711.onrender.com/api/v1` |
| **Tecnología** | Node.js + Express + Sequelize ORM |
| **Base de datos** | PostgreSQL (Render) |
| **Autenticación** | JWT — Bearer Token |
| **Formato de datos** | `application/json` |
 
### Endpoints consumidos por la App
 
#### 🔐 Autenticación
```
POST  /auth/login           → Iniciar sesión, retorna JWT
POST  /auth/recovery        → Recuperación de contraseña
POST  /auth/reset-password  → Restablecer contraseña
```
 
#### 👥 Usuarios
```
GET    /usuarios        → Listar usuarios
GET    /usuarios/:id    → Obtener usuario
POST   /usuarios        → Crear usuario
PUT    /usuarios/:id    → Actualizar usuario
DELETE /usuarios/:id    → Eliminar usuario
```
 
#### 🎓 Aprendices
```
GET    /aprendices        → Listar aprendices
GET    /aprendices/:id    → Obtener aprendiz
POST   /aprendices        → Registrar aprendiz
PUT    /aprendices/:id    → Actualizar aprendiz
DELETE /aprendices/:id    → Eliminar aprendiz
```
 
#### 📋 Reportes e Intervenciones
```
GET    /reportes             → Listar reportes
POST   /reportes             → Crear reporte de riesgo
GET    /intervenciones       → Listar intervenciones
POST   /intervenciones       → Registrar intervención
PUT    /intervenciones/:id   → Actualizar intervención
```
 
#### 📚 Programas y Grupos
```
GET    /programas    → Listar programas
GET    /grupos       → Listar grupos / fichas
POST   /programas    → Crear programa
POST   /grupos       → Crear grupo
```
 
### Header de autenticación requerido
 
```dart
// Ejemplo de petición autenticada en Flutter
headers: {
  "Content-Type": "application/json",
  "Authorization": "Bearer $token",
}
```
 
> 📄 Para la documentación completa del backend, visita el repositorio: [`api_projectretention_711`](https://github.com/jeferson-hernandez08/api_projectretention_711)
 
---
 
## 🔒 Seguridad
 
### Autenticación JWT
 
```
Usuario ingresa credenciales
  → App envía POST /auth/login
  → API valida y retorna token JWT
  → ReactController almacena el token
  → Token se envía en CADA petición HTTP:
    Authorization: Bearer <token>
```
 
### Control de Acceso por Roles
 
La app restringe vistas y funcionalidades según el rol del usuario autenticado, gestionado desde el `ReactController`:
 
```dart
// Verificación de rol en la app
hasRole("COORDINATOR")  // Acceso total
hasRole("INSTRUCTOR")   // Solo su grupo
hasRole("WELFARE")      // Estrategias y seguimiento
```
 
### Resumen de medidas implementadas
 
| Medida | Descripción |
|---|---|
| **JWT** | Tokens firmados para todas las peticiones protegidas |
| **HTTPS** | Comunicación cifrada con la API en producción |
| **Roles** | Restricción de funcionalidades por perfil de usuario |
| **Logout seguro** | `logout()` limpia token, usuario y todo el estado de la app |
| **GetStorage** | Sin contraseñas en texto plano — solo tokens necesarios |
| **Validación de formularios** | Campos obligatorios, formato email, longitud de contraseña |
| **Sin claves en código** | URL base en archivo de configuración, no hardcodeada |
 
---
 
## 👥 Equipo
 
Proyecto desarrollado por aprendices del **SENA — Centro de Procesos Industriales y Construcción (CPIC)**:
 
| Nombre | Rol |
|---|---|
| **Jeferson Hernandez** | Fullstack Developer / Scrum Master |
| **Juan Manuel Zuluaga** | Frontend Developer |
| **Jose Miguel Sierra** | Frontend Developer |
 
> 📅 *Proyecto formativo — Versión 1.0 Flutter · Octubre 2025*
 
---
 
## 📄 Licencia
 
Este proyecto fue desarrollado con fines educativos y formativos en el marco del SENA. Consulta el archivo [LICENSE](LICENSE) para más detalles.
 
---
 
<div align="center">
**⭐ Si este proyecto te fue útil, no olvides darle una estrella al repositorio ⭐**
 
Hecho con ❤️ por aprendices del **SENA CPIC**
 
[![Flutter](https://img.shields.io/badge/Made%20with-Flutter-02569B?style=flat-square&logo=flutter)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Language-Dart-0175C2?style=flat-square&logo=dart)](https://dart.dev/)
[![GetX](https://img.shields.io/badge/State-GetX-8A2BE2?style=flat-square)](https://pub.dev/packages/get)
[![API](https://img.shields.io/badge/API-Online-brightgreen?style=flat-square)](https://api-projectretention-711.onrender.com/)
 
</div>
 