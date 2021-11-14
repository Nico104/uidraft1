import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uidraft1/utils/constants/global_constants.dart';

Future<int> isAuthenticated() async {
  var url = Uri.parse(baseURL + 'protected');
  String? token = await getToken();

  final response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  });

  // print('Response status: ${response.statusCode}');
  // print('Response body: ${response.body}');

  if (response.statusCode != 200) {
    return response.statusCode;
  }

  return response.statusCode;
}

Future<String?> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('access_token');
}

Future<String?> getMyUsername() async {
  var url = Uri.parse(baseURL + 'user/getMyUsername');
  String? token = await getToken();

  final response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  });

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode != 200) {
    throw Error();
  }

  return response.body;
}

Future<int> changePassword(String password) async {
  var url = Uri.parse(baseURL + 'user/updateUserPassword');
  String? token = await getToken();

  final response = await http.patch(url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{"userpassword": password}));

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode != 200) {
    throw Error();
  }

  return response.statusCode;
}

// Future<bool> isFirstLogin() async {
//   var url = Uri.parse(baseURL + 'user/getIsFirstLogin');
//   String? token = await getToken();

//   final response = await http.get(url, headers: {
//     'Content-Type': 'application/json',
//     'Accept': 'application/json',
//     'Authorization': 'Bearer $token',
//   });

//   print('Response status: ${response.statusCode}');
//   print('Response body: ${response.body}');

//   if (response.statusCode != 200) {
//     throw Error();
//   } else {
//     print("Gen Password: " +
//         json.decode(response.body)['genPassword'].toString());
//     return json.decode(response.body)['genPassword'];
//   }
// }

Future<void> logout() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('access_token');
}

Future<bool> checkCode(String usermail, String code) async {
  var url = Uri.parse(baseURL + 'user/checkCode');
  // String? token = await getToken();

  // final response = await http.post(url, headers: {
  //   'Content-Type': 'application/json',
  //   'Accept': 'application/json',
  //   // 'Authorization': 'Bearer $token',
  // }, body: {
  //   json.encode(<String, String>{"useremail": usermail, "code": code})
  // });
  final response = await http.post(url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        // 'Authorization': 'Bearer $token',
      },
      body: json.encode(<String, String>{
        "useremail": '$usermail',
        "code": '$code',
        // "notificationtext": notificationText
      }));

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode != 201) {
    throw Error();
  } else {
    if (int.parse(response.body) == 0) {
      return false;
    } else {
      return true;
    }
  }
}

Future<bool> createPendingAccount(String usermail) async {
  print(usermail);

  var url = Uri.parse(baseURL + 'user/signupPendingAccount');
  // String? token = await getToken();

  // final response = await http.post(url, headers: {
  //   "Content-Type": "application/json"
  // }, body: {
  //   jsonEncode(<String, String>{"useremail": usermail})
  // });

  final response = await http.post(url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        // 'Authorization': 'Bearer $token',
      },
      body: json.encode(<String, String>{
        "useremail": '$usermail',
        // "notificationtext": notificationText
      }));

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode != 201) {
    return false;
  } else {
    return true;
  }
}

Future<bool> isUsernameAvailable(String username) async {
  var url = Uri.parse(baseURL + 'user/isUsernameAvailable/$username');
  final response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      // 'Authorization': 'Bearer $token',
    },
  );

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode != 200) {
    throw Error();
  } else {
    if (response.body == 'true') {
      return true;
    } else {
      return false;
    }
  }
}

Future<bool> isUseremailAvailable(String username) async {
  var url = Uri.parse(baseURL + 'user/isUseremailAvailable/$username');
  final response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      // 'Authorization': 'Bearer $token',
    },
  );

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode != 200) {
    throw Error();
  } else {
    if (response.body == 'true') {
      return true;
    } else {
      return false;
    }
  }
}
