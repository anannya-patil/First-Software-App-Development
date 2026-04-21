import 'package:http/http.dart' as http;
import 'dart:convert';
import 'configurations.dart';

class Utility {

  static bool validateEmail(String text) {
    return RegExp(
      r"^[a-zA-Z0-9]+(\.[a-zA-Z0-9]+)*@[a-zA-Z0-9]+(\.[a-zA-Z]{2,4}){1,2}$",
    ).hasMatch(text);
  }

  static bool validatePassword(String text) {
    return RegExp(
      r'^(?=(?:.*[A-Za-z]){2,})(?=.*\d)(?=.*[^A-Za-z0-9]).{7,}$',
    ).hasMatch(text);
  }

  static Future<String> loginAPI(String userid, String password) async {
    try {
      var url = Uri.parse("https://json-placeholder.mock.beeceptor.com/login");

      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": userid,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        String token;

        if (data is String) {
          token = data;
        } else if (data["success"] == true) {
          token = data["token"];
        } else {
          return "Invalid response format";
        }

        Configurations.globalpref.setBool("isLoggedin", true);
        Configurations.globalpref.setString("token", token);

        return "success";
      }

      else if (response.statusCode == 401) {
        return "Invalid credentials";
      }

      else if (response.statusCode >= 500) {
        return "Server error. Try again later";
      }

      else {
        return "Unexpected error: ${response.statusCode}";
      }

    } catch (e) {
      return "Network error. Check your connection";
    }
  }
}