class Configurations {

 static List<Map<String,String>> credentials = [
   {'userid':'vit1@vit.edu','password':'Vit@1234'},
   {'userid':'1321a@viit.ac.in','password':'Vit@1321a'}
 ];

 static bool validateEmail(String text) {
   return RegExp(
     r"^[a-zA-Z0-9]+(\.[a-zA-Z0-9]+)*@[a-zA-Z0-9]+(\.[a-zA-Z]{2,4}){1,2}$",
   ).hasMatch(text);
 }

static bool validateLogin(String userid, String password) {
  for (var cred in credentials) {
    if (cred['userid'] == userid && cred['password'] == password) {
      return true;
    }
  }
  return false;
}

static bool isUserUnique(String userid) {
  for (var cred in credentials) {
    if (cred['userid'] == userid) {
      return false; // already exists
    }
  }
  return true; // unique
}

//  static bool validatePassword(String text) {
//    return RegExp(
//      r"^[a-zA-Z0-9]+(\.[a-zA-Z0-9]+)*@[a-zA-Z0-9]+(\.[a-zA-Z]{2,4}){1,2}$",
//    ).hasMatch(text);
//  }


}