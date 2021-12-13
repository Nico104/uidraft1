import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uidraft1/utils/constants/global_constants.dart';

///Return 200 if the User is Authenticated
Future<int> isAuthenticated() async {
  var url = Uri.parse(baseURL + 'protected');
  String? token = await getToken();

  final response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  });
  return response.statusCode;
}

///Return the current saved Access Token
Future<String?> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('access_token');
}

///Returns the Username associated with the, if available, currently saved AccessToken
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

///Changes the Password of the with the, if available, currently saved AccessToken associated Account
///and returns 200 if the operation was successfull
///
///takes in the new Password as a String for [password]
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

///deletes the currently saved Access Token
Future<void> logout() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('access_token');
}

///Checks if the Code is correct to the, with the email, associated Account
///returns true if the [code] is matching to the Account associated with [useremail],
///otherwise return false
///
///takes in a String for [useremail], which will be the pending account which gets checked
///takes in a String for [code], which should be the Code the User received as an Email
Future<bool> checkCode(String usermail, String code) async {
  var url = Uri.parse(baseURL + 'user/checkCode');
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

/// Creates a new Pending Account for a new SignUp
/// returns true if the operation was successfull, otherwise return false
///
/// takes in the given email as a String for [usermail]
Future<bool> createPendingAccount(String usermail) async {
  print(usermail);

  var url = Uri.parse(baseURL + 'user/signupPendingAccount');
  final response = await http.post(url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        // 'Authorization': 'Bearer $token',
      },
      body: json.encode(<String, String>{
        "useremail": '$usermail',
      }));

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode != 201) {
    return false;
  } else {
    return true;
  }
}

///Checks if [username] is a already used Userame or not
///
///return true if [username] is available, otherwise return false
Future<bool> isUsernameAvailable(String username) async {
  print("Usenmae:" + username);
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

///Checks if [useremail] is a already used Userame or not
///
///return true if [useremail] is available, otherwise return false
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
