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

Future newUserApi(newFirstName, newLastName, newEmail, newPhone, newDocument, newPassword, newCoordinadorType, newManager, newFkIdRols) async {
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
    'fkIdRols': newFkIdRols,
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

Future editUserApi(id, newFirstName, newLastName, newEmail, newPhone, newDocument, newPassword, newCoordinadorType, newManager, newFkIdRols) async {
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
    'fkIdRols': newFkIdRols,
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

//**********CRUD Tabla Groups**********//

Future fetchAPIGroups() async {
  final url = '${baseUrl["projectretention_api"]}/api/v1/groups';
  print(url);
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    print("Respuesta API: ${response.body}"); // imprime lo que devuelve la API
    //print(jsonDecode(response.body)['data']);
    myReactController.setListGroups(jsonDecode(response.body)['data']);
  } else {
    throw Exception('Error al traer los datos de API groups');
  }
}

Future newGroupApi(newFile, newTrainingStart, newTrainingEnd, newPracticeStart, newPracticeEnd, newManagerName, newShift, newModality, newFkIdTrainingPrograms) async {
  const headers = {
    'Content-Type': 'application/json',
  };

  dynamic data = {
    'file': newFile,
    'trainingStart': newTrainingStart,
    'trainingEnd': newTrainingEnd,
    'practiceStart': newPracticeStart,
    'practiceEnd': newPracticeEnd,
    'managerName': newManagerName,
    'shift': newShift,
    'modality': newModality,
    'fkIdTrainingPrograms': newFkIdTrainingPrograms,
  };

  dynamic url = Uri.parse('${baseUrl["projectretention_api"]}/api/v1/groups');
  print('URL: $url');

  final response = await http.post(
    url,
    headers: headers,
    body: jsonEncode(data),
  );

  if (response.statusCode == 201) {
    // Si la respuesta es exitosa, actualizamos la lista de groups
    await fetchAPIGroups();
    return true;  // Retornamos true si se creó correctamente
  } else {
    //throw Exception('Error al crear el nuevo grupo');
    return false;  // Retornamos false si hubo un error
  }
}

Future editGroupApi(id, newFile, newTrainingStart, newTrainingEnd, newPracticeStart, newPracticeEnd, newManagerName, newShift, newModality, newFkIdTrainingPrograms) async {
  const headers = {
    'Content-Type': 'application/json',
  };

  dynamic data = {
    'file': newFile,
    'trainingStart': newTrainingStart,
    'trainingEnd': newTrainingEnd,
    'practiceStart': newPracticeStart,
    'practiceEnd': newPracticeEnd,
    'managerName': newManagerName,
    'shift': newShift,
    'modality': newModality,
    'fkIdTrainingPrograms': newFkIdTrainingPrograms,
  };

  dynamic url = Uri.parse('${baseUrl["projectretention_api"]}/api/v1/groups/$id');

  final response = await http.put(
    url,
    headers: headers,
    body: jsonEncode(data),
  );

  if (response.statusCode == 200) {
    // Si la respuesta es exitosa, actualizamos la lista de groups
    await fetchAPIGroups();
    return true;  // Retornamos true si se editó correctamente
  } else {
    //throw Exception('Error al editar el grupo');
    return false;  // Retornamos false si hubo un error
  }
}

Future deleteGroupApi(int id) async {
  final url = '${baseUrl["projectretention_api"]}/api/v1/groups/$id';   // Recibir el url con id del grupo a eliminar
  final response = await http.delete(Uri.parse(url));

  if (response.statusCode == 200) {
    // Actualizamos la lista de groups después de eliminar
    await fetchAPIGroups();
  } else {
    throw Exception('Error al eliminar el grupo con ID: $id');
  }
}

//**********CRUD Tabla Apprentices**********//

Future fetchAPIApprentices() async {
  final url = '${baseUrl["projectretention_api"]}/api/v1/apprentices';
  print(url);
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    print("Respuesta API: ${response.body}"); // imprime lo que devuelve la API
    //print(jsonDecode(response.body)['data']);
    myReactController.setListApprentices(jsonDecode(response.body)['data']);
  } else {
    throw Exception('Error al traer los datos de API apprentices');
  }
}

Future newApprenticeApi(newDocumentType, newDocument, newFirtsName, newLastName, newPhone, newEmail, newStatus, newQuarter, newFkIdGroups) async {
  const headers = {
    'Content-Type': 'application/json',
  };

  dynamic data = {
    'documentType': newDocumentType,
    'document': newDocument,
    'firtsName': newFirtsName,
    'lastName': newLastName,
    'phone': newPhone,
    'email': newEmail,
    'status': newStatus,
    'quarter': newQuarter,
    'fkIdGroups': newFkIdGroups,
  };

  dynamic url = Uri.parse('${baseUrl["projectretention_api"]}/api/v1/apprentices');
  print('URL: $url');

  final response = await http.post(
    url,
    headers: headers,
    body: jsonEncode(data),
  );

  if (response.statusCode == 201) {
    // Si la respuesta es exitosa, actualizamos la lista de apprentices
    await fetchAPIApprentices();
    return true;  // Retornamos true si se creó correctamente
  } else {
    //throw Exception('Error al crear el nuevo aprendiz');
    return false;  // Retornamos false si hubo un error
  }
}

Future editApprenticeApi(id, newDocumentType, newDocument, newFirtsName, newLastName, newPhone, newEmail, newStatus, newQuarter, newFkIdGroups) async {
  const headers = {
    'Content-Type': 'application/json',
  };

  dynamic data = {
    'documentType': newDocumentType,
    'document': newDocument,
    'firtsName': newFirtsName,
    'lastName': newLastName,
    'phone': newPhone,
    'email': newEmail,
    'status': newStatus,
    'quarter': newQuarter,
    'fkIdGroups': newFkIdGroups,
  };

  dynamic url = Uri.parse('${baseUrl["projectretention_api"]}/api/v1/apprentices/$id');

  final response = await http.put(
    url,
    headers: headers,
    body: jsonEncode(data),
  );

  if (response.statusCode == 200) {
    // Si la respuesta es exitosa, actualizamos la lista de apprentices
    await fetchAPIApprentices();
    return true;  // Retornamos true si se editó correctamente
  } else {
    //throw Exception('Error al editar el aprendiz');
    return false;  // Retornamos false si hubo un error
  }
}

Future deleteApprenticeApi(int id) async {
  final url = '${baseUrl["projectretention_api"]}/api/v1/apprentices/$id';   // Recibir el url con id del aprendiz a eliminar
  final response = await http.delete(Uri.parse(url));

  if (response.statusCode == 200) {
    // Actualizamos la lista de apprentices después de eliminar
    await fetchAPIApprentices();
  } else {
    throw Exception('Error al eliminar el aprendiz con ID: $id');
  }
}

//**********CRUD Tabla Categories**********//

// Traer todas las categorías desde la API
Future fetchAPICategories() async {
  final url = '${baseUrl["projectretention_api"]}/api/v1/categories';
  print(url);
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    print("Respuesta API: ${response.body}"); // imprime lo que devuelve la API
    //print(jsonDecode(response.body)['data']);
    myReactController.setListCategories(jsonDecode(response.body)['data']);
  } else {
    throw Exception('Error al traer los datos de API categories');
  }
}

// Crear una nueva categoría en la API
Future newCategoryApi(newName, newDescription, newAddressing) async {
  const headers = {
    'Content-Type': 'application/json',
  };

  dynamic data = {
    'name': newName,
    'description': newDescription,
    'addressing': newAddressing,
  };

  dynamic url = Uri.parse('${baseUrl["projectretention_api"]}/api/v1/categories');
  print('URL: $url');

  final response = await http.post(
    url,
    headers: headers,
    body: jsonEncode(data),
  );

  if (response.statusCode == 201) {
    // Si la respuesta es exitosa, actualizamos la lista de categorías
    await fetchAPICategories();
    return true; // Retornamos true si se creó correctamente
  } else {
    //throw Exception('Error al crear la nueva categoría');
    return false; // Retornamos false si hubo un error
  }
}

// Editar una categoría existente en la API
Future editCategoryApi(id, newName, newDescription, newAddressing) async {
  const headers = {
    'Content-Type': 'application/json',
  };

  dynamic data = {
    'name': newName,
    'description': newDescription,
    'addressing': newAddressing,
  };

  dynamic url = Uri.parse('${baseUrl["projectretention_api"]}/api/v1/categories/$id');

  final response = await http.put(
    url,
    headers: headers,
    body: jsonEncode(data),
  );

  if (response.statusCode == 200) {
    // Si la respuesta es exitosa, actualizamos la lista de categorías
    await fetchAPICategories();
    return true; // Retornamos true si se editó correctamente
  } else {
    //throw Exception('Error al editar la categoría');
    return false; // Retornamos false si hubo un error
  }
}

// Eliminar una categoría de la API
Future deleteCategoryApi(int id) async {
  final url = '${baseUrl["projectretention_api"]}/api/v1/categories/$id'; // Recibir la URL con id de categoría a eliminar
  final response = await http.delete(Uri.parse(url));

  if (response.statusCode == 200) {
    // Actualizamos la lista de categorías después de eliminar una
    await fetchAPICategories();
  } else {
    throw Exception('Error al eliminar la categoría con ID: $id');
  }
}

//**********CRUD Tabla Causes**********//

// Obtener todas las causas desde la API
Future fetchAPICauses() async {
  final url = '${baseUrl["projectretention_api"]}/api/v1/causes';
  print(url);
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    print("Respuesta API: ${response.body}"); // imprime lo que devuelve la API
    //print(jsonDecode(response.body)['data']);
    myReactController.setListCauses(jsonDecode(response.body)['data']); // Guardamos las causas en el controlador Reactivo
  } else {
    throw Exception('Error al traer los datos de API causes');
  }
}

// Crear una nueva causa
Future newCauseApi(newCause, newVariable, newFkIdCategories) async {
  const headers = {
    'Content-Type': 'application/json',
  };

  dynamic data = {
    'cause': newCause,
    'variable': newVariable,
    'fkIdCategories': newFkIdCategories,
  };

  dynamic url = Uri.parse('${baseUrl["projectretention_api"]}/api/v1/causes');
  print('URL: $url');

  final response = await http.post(
    url,
    headers: headers,
    body: jsonEncode(data),
  );

  if (response.statusCode == 201) {
    // Si la respuesta es exitosa, actualizamos la lista de causas
    await fetchAPICauses();
    return true;  // Retornamos true si se creó correctamente
  } else {
    //throw Exception('Error al crear la nueva causa');
    return false;  // Retornamos false si hubo un error
  }
}

// Editar una causa existente
Future editCauseApi(id, newCause, newVariable, newFkIdCategories) async {
  const headers = {
    'Content-Type': 'application/json',
  };

  dynamic data = {
    'cause': newCause,
    'variable': newVariable,
    'fkIdCategories': newFkIdCategories,
  };

  dynamic url = Uri.parse('${baseUrl["projectretention_api"]}/api/v1/causes/$id');

  final response = await http.put(
    url,
    headers: headers,
    body: jsonEncode(data),
  );

  if (response.statusCode == 200) {
    // Si la respuesta es exitosa, actualizamos la lista de causas
    await fetchAPICauses();
    return true;  // Retornamos true si se actualizó correctamente
  } else {
    //throw Exception('Error al editar la causa');
    return false;  // Retornamos false si hubo un error
  }
}

// Eliminar una causa por ID
Future deleteCauseApi(int id) async {
  final url = '${baseUrl["projectretention_api"]}/api/v1/causes/$id';   // Recibir el url con id de la causa a eliminar
  final response = await http.delete(Uri.parse(url));

  if (response.statusCode == 200) {
    // Actualizamos la lista de causas después de eliminar una
    await fetchAPICauses();
  } else {
    throw Exception('Error al eliminar la causa con ID: $id');
  }
}

//**********CRUD Tabla Strategies**********//

// Traer todas las estrategias desde la API
Future fetchAPIStrategies() async {
  final url = '${baseUrl["projectretention_api"]}/api/v1/strategies';
  print(url);
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    print("Respuesta API: ${response.body}"); // imprime lo que devuelve la API
    //print(jsonDecode(response.body)['data']);
    myReactController.setListStrategies(jsonDecode(response.body)['data']);
  } else {
    throw Exception('Error al traer los datos de API strategies');
  }
}

// Crear una nueva estrategia en la API
Future newStrategyApi(newStrategy, newFkIdCategories) async {
  const headers = {
    'Content-Type': 'application/json',
  };

  dynamic data = {
    'strategy': newStrategy,
    'fkIdCategories': newFkIdCategories,
  };

  dynamic url = Uri.parse('${baseUrl["projectretention_api"]}/api/v1/strategies');
  print('URL: $url');

  final response = await http.post(
    url,
    headers: headers,
    body: jsonEncode(data),
  );

  if (response.statusCode == 201) {
    // Si la respuesta es exitosa, actualizamos la lista de strategies
    await fetchAPIStrategies();
    return true;  // Retornamos true si se creó correctamente
  } else {
    //throw Exception('Error al crear la nueva estrategia');
    return false;  // Retornamos false si hubo un error
  }
}

// Editar una estrategia existente en la API
Future editStrategyApi(id, newStrategy, newFkIdCategories) async {
  const headers = {
    'Content-Type': 'application/json',
  };

  dynamic data = {
    'strategy': newStrategy,
    'fkIdCategories': newFkIdCategories,
  };

  dynamic url = Uri.parse('${baseUrl["projectretention_api"]}/api/v1/strategies/$id');

  final response = await http.put(
    url,
    headers: headers,
    body: jsonEncode(data),
  );

  if (response.statusCode == 200) {
    // Si la respuesta es exitosa, actualizamos la lista de strategies
    await fetchAPIStrategies();
    return true;  // Retornamos true si se editó correctamente
  } else {
    //throw Exception('Error al editar la estrategia');
    return false;  // Retornamos false si hubo un error
  }
}

// Eliminar una estrategia de la API
Future deleteStrategyApi(int id) async {
  final url = '${baseUrl["projectretention_api"]}/api/v1/strategies/$id';   // Recibir el url con id estrategia a eliminar
  final response = await http.delete(Uri.parse(url));

  if (response.statusCode == 200) {
    // Actualizamos la lista de estrategias después de eliminar una
    await fetchAPIStrategies();
  } else {
    throw Exception('Error al eliminar la estrategia con ID: $id');
  }
}

//********** 👉 CRUD Tabla Reports**********//

// Obtener todos los reportes desde la API
Future fetchAPIReports() async {
  final url = '${baseUrl["projectretention_api"]}/api/v1/reports';
  print(url);
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    print("Respuesta API: ${response.body}"); // imprime lo que devuelve la API
    //print(jsonDecode(response.body)['data']);
    myReactController.setListReports(jsonDecode(response.body)['data']);
  } else {
    throw Exception('Error al traer los datos de API reports');
  }
}

// Crear un nuevo reporte en la API
Future newReportApi(newCreationDate, newDescription, newAddressing, newState, newFkIdApprentices, newFkIdUsers) async {
  const headers = {
    'Content-Type': 'application/json',
  };

  dynamic data = {
    'creationDate': newCreationDate,
    'description': newDescription,
    'addressing': newAddressing,
    'state': newState,
    'fkIdApprentices': newFkIdApprentices,
    'fkIdUsers': newFkIdUsers,
  };

  dynamic url = Uri.parse('${baseUrl["projectretention_api"]}/api/v1/reports');
  print('URL: $url');

  final response = await http.post(
    url,
    headers: headers,
    body: jsonEncode(data),
  );

  if (response.statusCode == 201) {
    // Si la respuesta es exitosa, actualizamos la lista de reports
    await fetchAPIReports();
    return true;  // Retornamos true si se creó correctamente
  } else {
    //throw Exception('Error al crear el nuevo reporte');
    return false;  // Retornamos false si hubo un error
  }
}

// Editar un reporte existente en la API
Future editReportApi(id, newCreationDate, newDescription, newAddressing, newState, newFkIdApprentices, newFkIdUsers) async {
  const headers = {
    'Content-Type': 'application/json',
  };

  dynamic data = {
    'creationDate': newCreationDate,
    'description': newDescription,
    'addressing': newAddressing,
    'state': newState,
    'fkIdApprentices': newFkIdApprentices,
    'fkIdUsers': newFkIdUsers,
  };

  dynamic url = Uri.parse('${baseUrl["projectretention_api"]}/api/v1/reports/$id');

  final response = await http.put(
    url,
    headers: headers,
    body: jsonEncode(data),
  );

  if (response.statusCode == 200) {
    // Si la respuesta es exitosa, actualizamos la lista de reports
    await fetchAPIReports();
    return true;  // Retornamos true si se actualizó correctamente
  } else {
    //throw Exception('Error al editar el reporte');
    return false;  // Retornamos false si hubo un error
  }
}

// Eliminar un reporte de la API
Future deleteReportApi(int id) async {
  final url = '${baseUrl["projectretention_api"]}/api/v1/reports/$id';   // Recibir el url con id reporte a eliminar
  final response = await http.delete(Uri.parse(url));

  if (response.statusCode == 200) {
    // Actualizamos la lista de reports después de eliminar uno
    await fetchAPIReports();
  } else {
    throw Exception('Error al eliminar el reporte con ID: $id');
  }
}

//********** 👉 CRUD Tabla Interventions**********//

// Traer todas las intervenciones desde la API
Future fetchAPIInterventions() async {
  final url = '${baseUrl["projectretention_api"]}/api/v1/interventions';
  print(url);
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    print("Respuesta API: ${response.body}"); // imprime lo que devuelve la API
    //print(jsonDecode(response.body)['data']);
    myReactController.setListInterventions(jsonDecode(response.body)['data']);
  } else {
    throw Exception('Error al traer los datos de API interventions');
  }
}

// Crear una nueva intervención
Future newInterventionApi(newCreationDate, newDescription, newFkIdStrategies, newFkIdReports, newFkIdUsers) async {
  const headers = {
    'Content-Type': 'application/json',
  };

  dynamic data = {
    'creationDate': newCreationDate,
    'description': newDescription,
    'fkIdStrategies': newFkIdStrategies,
    'fkIdReports': newFkIdReports,
    'fkIdUsers': newFkIdUsers,
  };

  dynamic url = Uri.parse('${baseUrl["projectretention_api"]}/api/v1/interventions');
  print('URL: $url');

  final response = await http.post(
    url,
    headers: headers,
    body: jsonEncode(data),
  );

  if (response.statusCode == 201) {
    // Si la respuesta es exitosa, actualizamos la lista de interventions
    await fetchAPIInterventions();
    return true;  // Retornamos true si se creó correctamente
  } else {
    //throw Exception('Error al crear la nueva intervención');
    return false;  // Retornamos false si hubo un error
  }
}

// Editar una intervención existente
Future editInterventionApi(id, newCreationDate, newDescription, newFkIdStrategies, newFkIdReports, newFkIdUsers) async {
  const headers = {
    'Content-Type': 'application/json',
  };

  dynamic data = {
    'creationDate': newCreationDate,
    'description': newDescription,
    'fkIdStrategies': newFkIdStrategies,
    'fkIdReports': newFkIdReports,
    'fkIdUsers': newFkIdUsers,
  };

  dynamic url = Uri.parse('${baseUrl["projectretention_api"]}/api/v1/interventions/$id');

  final response = await http.put(
    url,
    headers: headers,
    body: jsonEncode(data),
  );

  if (response.statusCode == 200) {
    // Si la respuesta es exitosa, actualizamos la lista de interventions
    await fetchAPIInterventions();
    return true;  // Retornamos true si se actualizó correctamente
  } else {
    //throw Exception('Error al actualizar la intervención');
    return false;  // Retornamos false si hubo un error
  }
}

// Eliminar una intervención por ID
Future deleteInterventionApi(int id) async {
  final url = '${baseUrl["projectretention_api"]}/api/v1/interventions/$id';   // Recibir el url con id intervención a eliminar
  final response = await http.delete(Uri.parse(url));

  if (response.statusCode == 200) {
    // Actualizamos la lista de intervenciones después de eliminar una
    await fetchAPIInterventions();
  } else {
    throw Exception('Error al eliminar la intervención con ID: $id');
  }
}



//********** 🔹 Traer causas asociadas a un reporte **********//
Future<List<dynamic>> fetchAPICausesReportsByReport(int reportId) async {
  final url =
      '${baseUrl["projectretention_api"]}/api/v1/causesReports/report/$reportId';
  print("URL fetchAPICausesReportsByReport: $url");

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final decoded = jsonDecode(response.body);
    print("Respuesta API CausesReports: $decoded");

    // Si la API responde con { "data": [...] }
    return decoded['data'];
  } else {
    throw Exception(
        'Error al traer las causas asociadas al reporte con ID $reportId');
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