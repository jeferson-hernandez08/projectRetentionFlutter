import 'package:get/get.dart';

class ReactController extends GetxController  {
  final _pagina = 0.obs;
  final _tituloAppBar = 'Sena Contigo'.obs;
  final _listRols = [].obs; 
  final _listUsers = [].obs; 
  final _listTrainingPrograms = [].obs; 
  final _listGroups = [].obs; 
  final _listApprentices = [].obs; 
  final _listCategories = [].obs; 
  final _listCauses = [].obs;   
  final _listStrategies = [].obs;   
  final _listReports = [].obs;   
  final _listInterventions = [].obs;   

  final _token = ''.obs;
  final _user = {}.obs;

  // ============ MÉTODOS SET ============ //

  void setPagina(int newPage){
    _pagina.value = newPage;
  }
  void setTituloAppBar(String newTitle){
    _tituloAppBar.value = newTitle;
  }
  void setListRols(List itemList){
    _listRols.value = itemList;
  }
  void setListUsers(List itemList){
    _listUsers.value = itemList;
  }
  void setListTrainingPrograms(List itemList){
    _listTrainingPrograms.value = itemList;
  }
  void setListGroups(List itemList){
    _listGroups.value = itemList;
  }
  void setListApprentices(List itemList){
    _listApprentices.value = itemList;
  }
  void setListCategories(List itemList){
    _listCategories.value = itemList;
  }
  void setListCauses(List itemList){
    _listCauses.value = itemList;
  }
  void setListStrategies(List itemList){
    _listStrategies.value = itemList;
  }
  void setListReports(List itemList){
    _listReports.value = itemList;
  }
  void setListInterventions(List itemList){
    _listInterventions.value = itemList;
  }


  void setToken(String newToken) {
    _token.value = newToken;
  }
  void setUser(Map newUser) {
  _user.value = newUser;
  }

  // ============ MÉTODOS GET ============ //
 
  int get getPagina => _pagina.value;
  String get getTituloAppBar => _tituloAppBar.value;
      
  List get getListRols => _listRols.value;     
  List get getListUsers => _listUsers.value;        
  List get getListTrainingPrograms => _listTrainingPrograms.value;     
  List get getListGroups => _listGroups.value;     
  List get getListApprentices => _listApprentices.value;     
  List get getListCategories => _listCategories.value;     
  List get getListCauses => _listCauses.value;     
  List get getListStrategies => _listStrategies.value;     
  List get getListReports=> _listReports.value;     
  List get getListInterventions=> _listInterventions.value;     


  String get getToken => _token.value;
  Map get getUser => _user.value;

  // ============ MÉTODOS DE AUTENTICACIÓN ============ //
  // 🚪 CERRAR SESIÓN COMPLETA
  void logout() {
    _token.value = '';
    _user.value = {};
    _pagina.value = 0;
    print('✅ Sesión cerrada completamente');
  }

  // 🔍 VERIFICAR SI ESTÁ AUTENTICADO
  bool get isAuthenticated => _token.value.isNotEmpty && _user.value.isNotEmpty;

  // 👤 OBTENER NOMBRE COMPLETO
  String get fullName {
    if (_user.value.isEmpty) return '';
    return '${_user.value['firstName']} ${_user.value['lastName']}';
  }

  // 🎯 OBTENER ROL
  String get userRole {
    if (_user.value.isEmpty) return '';
    return _user.value['rol']?['name'] ?? 'Sin rol';
  }

  // 📧 OBTENER EMAIL
  String get userEmail {
    if (_user.value.isEmpty) return '';
    return _user.value['email'] ?? '';
  }

  // 👤 OBTENER ID DEL USUARIO
  int get userId {
    if (_user.value.isEmpty) return 0;
    return _user.value['id'] ?? 0;
  }

  // 🏢 OBTENER TIPO DE COORDINADOR
  String get coordinadorType {
    if (_user.value.isEmpty) return '';
    return _user.value['coordinadorType'] ?? '';
  }

  // 👨‍💼 VERIFICAR SI ES MANAGER
  bool get isManager {
    if (_user.value.isEmpty) return false;
    return _user.value['manager'] == true;
  }

  // 🔄 VERIFICAR SI EL USUARIO TIENE UN ROL ESPECÍFICO
  bool hasRole(String roleName) {
    if (_user.value.isEmpty) return false;
    return _user.value['rol']?['name'] == roleName;
  }

  // 🔄 VERIFICAR SI EL USUARIO TIENE ALGUNO DE LOS ROLES
  bool hasAnyRole(List<String> roleNames) {
    if (_user.value.isEmpty) return false;
    final userRole = _user.value['rol']?['name'];
    return roleNames.contains(userRole);
  }

  // 📋 OBTENER INFORMACIÓN COMPLETA DEL USUARIO (PARA DEBUG)
  Map<String, dynamic> get userInfo {
    if (_user.value.isEmpty) return {};
    return {
      'id': _user.value['id'],
      'nombreCompleto': fullName,
      'email': userEmail,
      'rol': userRole,
      'coordinadorType': coordinadorType,
      'manager': isManager,
      'token': _token.value.isNotEmpty ? '✅ Presente' : '❌ Ausente'
    };
  }

  // 🔍 VERIFICAR SI EL TOKEN ESTÁ PRESENTE
  bool get hasToken => _token.value.isNotEmpty;

  // 📊 ESTADO DE AUTENTICACIÓN COMPLETO
  Map<String, dynamic> get authStatus {
    return {
      'isAuthenticated': isAuthenticated,
      'hasToken': hasToken,
      'user': _user.value.isNotEmpty ? userInfo : 'No autenticado',
      'tokenLength': _token.value.length
    };
  }

  // 🖨️ IMPRIMIR ESTADO DE AUTENTICACIÓN (PARA DEBUG)
  void printAuthStatus() {
    print('🔐 ESTADO DE AUTENTICACIÓN:');
    print('   ✅ Autenticado: $isAuthenticated');
    print('   🔑 Token presente: $hasToken');
    print('   👤 Usuario: $fullName');
    print('   🎯 Rol: $userRole');
    print('   📧 Email: $userEmail');
    print('   🏢 Tipo coordinador: $coordinadorType');
    print('   👨‍💼 Es manager: $isManager');
  }

  // 🔄 LIMPIAR TODOS LOS DATOS (RESET COMPLETO)
  void clearAllData() {
    _pagina.value = 0;
    _token.value = '';
    _user.value = {};
    _listRols.value = [];
    _listUsers.value = [];
    _listTrainingPrograms.value = [];
    _listGroups.value = [];
    _listApprentices.value = [];
    _listCategories.value = [];
    _listCauses.value = [];
    _listStrategies.value = [];
    _listReports.value = [];
    _listInterventions.value = [];
    
    print('🧹 Todos los datos han sido limpiados');
  }
}