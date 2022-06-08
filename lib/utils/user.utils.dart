import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();
//step 1 creating user id
Future<String> loadUserId() async {
  var preferences = await SharedPreferences.getInstance();
  var userId;
  if (preferences.containsKey("userId")) {
    userId = preferences.getString("userId");
  } else {
    userId = uuid.v4();
    preferences.setString("userId", userId);
  }
  return userId;
}
