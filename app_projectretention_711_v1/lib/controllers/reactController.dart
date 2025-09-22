import 'package:get/get.dart';

class ReactController extends GetxController  {
  final _pagina = 0.obs;
  final _tituloAppBar = 'Proyecto Retencion SENA controller'.obs;
  final _listRols = [].obs; 
  final _listUsers = [].obs; 
  final _listTrainingPrograms = [].obs; 

  final _token = ''.obs;
  final _user = {}.obs;

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

  void setToken(String newToken) {
    _token.value = newToken;
  }
  void setUser(Map newUser) {
  _user.value = newUser;
  }
 
  int get getPagina => _pagina.value;
  String get getTituloAppBar => _tituloAppBar.value;
      
  List get getListRols => _listRols.value;     
  List get getListUsers => _listUsers.value;        
  List get getListTrainingPrograms => _listTrainingPrograms.value;        
 
  String get getToken => _token.value;
  Map get getUser => _user.value;
 
}