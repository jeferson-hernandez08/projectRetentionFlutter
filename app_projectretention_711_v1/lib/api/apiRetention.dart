import 'dart:convert';
import 'package:app_projectretention_711_v1/main.dart';
import 'package:http/http.dart' as http;

const baseUrl = {
  "projectretention_api": 'https://api-projectretention-711.onrender.com',
};

//******************************/
//****API PROYECTO RETENCION ***/
//******************************/
//******CRUD Tabla Rols****** 
Future fetchAPIRols() async {
  final url = '${baseUrl["projectretention_api"]}/api/v1/rols';
  print(url);
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    print("Respuesta API: ${response.body}"); // imprime lo que devuelve la API
    //print(jsonDecode(response.body)['data']);
    myReactController.setListRols(jsonDecode(response.body)['data']);
  } else {
    throw Exception('Error al traer los datos de API roles');
  }
}

Future newRolApi(newName) async {
  const headers = {
    'Content-Type': 'application/json',
  };

  dynamic data = {
    'name': newName
  };

dynamic url = Uri.parse('${baseUrl["projectretention_api"]}/api/v1/rols');

final response = await http.post(
    url,
    headers: headers,
    body: jsonEncode(data),
  );

  if (response.statusCode == 201) {
    // Si la respuesta es exitosa, actualizamos la lista de roles
    await fetchAPIRols();
    return true;  // Retornamos true si se creó correctamente
  } else {
    //throw Exception('Error al crear el nuevo ambiente');
    return false;  // Retornamos false si hubo un error
  }

}

Future editRolApi(id, newName) async {
  const headers = {
    'Content-Type': 'application/json',
  };

  dynamic data = {
    'name': newName
  };

  dynamic url = Uri.parse('${baseUrl["projectretention_api"]}/api/v1/rols/$id');

  final response = await http.put(
    url,
    headers: headers,
    body: jsonEncode(data),
  );

  if (response.statusCode == 200) {
    // Si la respuesta es exitosa, actualizamos la lista de roles
    await fetchAPIRols();
    return true;  // Retornamos true si se creó correctamente
  } else {
    //throw Exception('Error al crear el nuevo rol');
    return false;  // Retornamos false si hubo un error
  }

}

Future fetchDeleteRol(int id) async {
  final url = '${baseUrl["projectretention_api"]}/api/v1/rols/$id';   // Recibir el utl con id rol a aliminar
  final response = await http.delete(Uri.parse(url));

  if (response.statusCode == 200) {
    // Actualizamos la lista de ambientes después de eliminar un rol
    await fetchAPIRols();
  } else {
    throw Exception('Error al eliminar el ambiente con ID: $id');
  }
}

//**********CRUD Tabla Users**********//
Future fetchAPIUsers() async {
  final url = '${baseUrl["projectretention_api"]}/api/v1/users';
  print(url);
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    print("Respuesta API: ${response.body}"); // imprime lo que devuelve la API
    //print(jsonDecode(response.body)['data']);
    myReactController.setListUsers(jsonDecode(response.body)['data']);
  } else {
    throw Exception('Error al traer los datos de API users');
  }
}

Future newUserApi(newFirstName, newLastName, newEmail, newPhone, newDocument, newPassword, newCoordinadorType, newManager, newRolId) async {
  const headers = {
    'Content-Type': 'application/json',
  };

  dynamic data = {
    'firstName': newFirstName,
    'lastName': newLastName,
    'email': newEmail,
    'phone': newPhone,
    'document': newDocument,
    'password': newPassword,
    'coordinadorType': newCoordinadorType, 
    'manager': newManager,
    'rolId': newRolId,
    //'passwordResetToken': newPasswordResetToken,
    //'passwordResetExpires': newPasswordResetExpires
  };

dynamic url = Uri.parse('${baseUrl["projectretention_api"]}/api/v1/users');
print('URL: $url');

final response = await http.post(
    url,
    headers: headers,
    body: jsonEncode(data),
  );

  if (response.statusCode == 201) {
    // Si la respuesta es exitosa, actualizamos la lista de users
    await fetchAPIUsers();
    return true;  // Retornamos true si se creó correctamente
  } else {
    //throw Exception('Error al crear el nuevo ambiente');
    return false;  // Retornamos false si hubo un error
  }

}

Future editUserApi(id, newFirstName, newLastName, newEmail, newPhone, newDocument, newPassword, newCoordinadorType, newManager, newRolId) async {
  const headers = {
    'Content-Type': 'application/json',
  };

  dynamic data = {
    'firstName': newFirstName,
    'lastName': newLastName,
    'email': newEmail,
    'phone': newPhone,
    'document': newDocument,
    'password': newPassword,
    'coordinadorType': newCoordinadorType, 
    'manager': newManager,
    'rolId': newRolId,
    // 'passwordResetToken': newPasswordResetToken,
    // 'passwordResetExpires': newPasswordResetExpires
  };

  dynamic url = Uri.parse('${baseUrl["projectretention_api"]}/api/v1/users/$id');

  final response = await http.put(
    url,
    headers: headers,
    body: jsonEncode(data),
  );

  if (response.statusCode == 200) {
    // Si la respuesta es exitosa, actualizamos la lista de usuarios
    await fetchAPIUsers();
    return true;  // Retornamos true si se creó correctamente
  } else {
    //throw Exception('Error al crear el nuevo rol');
    return false;  // Retornamos false si hubo un error
  }

}

Future deleteUserApi(int id) async {
  final url = '${baseUrl["projectretention_api"]}/api/v1/users/$id';   // Recibir el utl con id rol a aliminar
  final response = await http.delete(Uri.parse(url));

  if (response.statusCode == 200) {
    // Actualizamos la lista de ambientes después de eliminar un usuario
    await fetchAPIUsers();
  } else {
    throw Exception('Error al eliminar el usuario con ID: $id');
  }
}

//**********CRUD Tabla TrainingPrograms**********//
Future fetchAPITrainingPrograms() async {
  final url = '${baseUrl["projectretention_api"]}/api/v1/trainingPrograms';
  print(url);
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    print("Respuesta API: ${response.body}"); // imprime lo que devuelve la API
    //print(jsonDecode(response.body)['data']);
    myReactController.setListTrainingPrograms(jsonDecode(response.body)['data']);
  } else {
    throw Exception('Error al traer los datos de API training programs');
  }
}

Future newTrainingProgramApi(newName, newLevel, newVersion) async {
  const headers = {
    'Content-Type': 'application/json',
  };

  dynamic data = {
    'name': newName,
    'level': newLevel,
    'version': newVersion,
  };

  dynamic url = Uri.parse('${baseUrl["projectretention_api"]}/api/v1/trainingPrograms');
  print('URL: $url');

  final response = await http.post(
    url,
    headers: headers,
    body: jsonEncode(data),
  );

  if (response.statusCode == 201) {
    // Si la respuesta es exitosa, actualizamos la lista de training programs
    await fetchAPITrainingPrograms();
    return true;  // Retornamos true si se creó correctamente
  } else {
    //throw Exception('Error al crear el nuevo programa de formación');
    return false;  // Retornamos false si hubo un error
  }
}

Future editTrainingProgramApi(id, newName, newLevel, newVersion) async {
  const headers = {
    'Content-Type': 'application/json',
  };

  dynamic data = {
    'name': newName,
    'level': newLevel,
    'version': newVersion,
  };

  dynamic url = Uri.parse('${baseUrl["projectretention_api"]}/api/v1/trainingPrograms/$id');

  final response = await http.put(
    url,
    headers: headers,
    body: jsonEncode(data),
  );

  if (response.statusCode == 200) {
    // Si la respuesta es exitosa, actualizamos la lista de training programs
    await fetchAPITrainingPrograms();
    return true;  // Retornamos true si se editó correctamente
  } else {
    //throw Exception('Error al editar el programa de formación');
    return false;  // Retornamos false si hubo un error
  }
}

Future deleteTrainingProgramApi(int id) async {
  final url = '${baseUrl["projectretention_api"]}/api/v1/trainingPrograms/$id';   // Recibir el url con id del programa a eliminar
  final response = await http.delete(Uri.parse(url));

  if (response.statusCode == 200) {
    // Actualizamos la lista de training programs después de eliminar
    await fetchAPITrainingPrograms();
  } else {
    throw Exception('Error al eliminar el programa de formación con ID: $id');
  }
}

// ************ Login *************//
Future<bool> loginApi(String email, String password) async {
  const headers = {
    'Content-Type': 'application/json',
  };

  dynamic data = {
    'email': email,
    'password': password,
  };

  dynamic url = Uri.parse('${baseUrl["projectretention_api"]}/api/v1/auth/login');

  print('🔐 Intentando login con:');
  print('📧 Email: $email');
  print('🔑 Password: $password');
  print('🌐 URL: $url');

  try {
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(data),
    );

    print('📥 Respuesta del servidor:');
    print('📊 Status Code: ${response.statusCode}');
    print('📦 Body: ${response.body}');

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      
      // Verificar la estructura de la respuesta
      if (responseData['status'] == 'Ok' && responseData['data'] != null) {
        print('✅ Login exitoso');
        print('🔑 Token recibido: ${responseData['data']['token']}');
        print('👤 Datos usuario: ${responseData['data']['user']}');

        // 👇🏼 CORREGIR: Acceder a los datos dentro de 'data'
        myReactController.setToken(responseData['data']['token']);
        myReactController.setUser(responseData['data']['user']);
        return true;
      } else {
        print('❌ Estructura de respuesta inesperada');
        return false;
      }
    } else {
      print('❌ Error en login - Status code: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('💥 Excepción durante login: $e');
    return false;
  }
}