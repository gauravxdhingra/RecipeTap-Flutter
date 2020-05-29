import 'package:shared_preferences/shared_preferences.dart';

setVisitingFlag() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setBool("alreadyVisited", true);
}

getVisitingFlag() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  bool alreadyVisited = preferences.getBool("alreadyVisited") ?? false;
  return alreadyVisited;
}

setDiet(String diet) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setString("diet", diet);
}

getDiet() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String diet = preferences.getString("diet") ?? "all";
  return diet;
}

setLoginState(bool loginState) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setBool("loginState", loginState);
}

getLoginState() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  bool loginState = preferences.getBool("loginState") ?? false;
  return loginState;
}
